//
//  PersonsOverView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 29/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct PersonsOverView: View {

    var removeChar: String = "✈️"

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var searchText: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()
    @State private var newPerson = false
    @State private var deletePersonActinSheet = false
    @State private var personsOverview = NSLocalizedString("Persons overview", comment: "PersonsOverView")
    @State private var indexSetDelete = IndexSet()
    @State private var recordID: CKRecord.ID?

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List  {
                    /// Søker etter personer som inneholder $searchText i for- eller etternavnet
                    ForEach(persons.filter({ self.searchText.isEmpty ||
                        $0.firstName.localizedStandardContains(self.searchText) ||
                        $0.lastName.localizedStandardContains (self.searchText)    })) {
                            person in

                            NavigationLink(destination: PersonView(person: person)) {
                                ShowPersons(person: person, removeChar: self.removeChar)
                            }
                            // self.postalCodeSettings.postalName = "Varhaug i Hå kommune"
                    }
                        /// Sletter  valgt person og oppdaterer CliudKit
                        .onDelete { (indexSet) in
                            self.indexSetDelete = indexSet
                            self.recordID = self.persons[indexSet.first!].recordID
                            self.deletePersonActinSheet = true
                    }
                    .actionSheet(isPresented: $deletePersonActinSheet) {
                        ActionSheet(title: Text(NSLocalizedString("Delete person", comment: "PersonsOverView")),
                                    message: Text(NSLocalizedString("Are you sure you want to delete this person?", comment: "PersonsOverView")),
                                    buttons: [.default(Text(NSLocalizedString("No", comment: "PersonsOverView")), action: {

                                    }),
                                              .destructive(Text("Delete this person"), action: {
                                                CloudKitPerson.deletePerson(recordID: self.recordID!) { (result) in
                                                    switch result {
                                                    case .success :
                                                        self.message = NSLocalizedString("Successfully deleted a person", comment: "PersonsOverView")
                                                        self.alertIdentifier = AlertID(id: .first)
                                                    case .failure(let err):
                                                        self.message = err.localizedDescription
                                                        self.alertIdentifier = AlertID(id: .first)
                                                    }
                                                }
                                                /// Sletter den valgte raden
                                                self.persons.remove(atOffsets: self.indexSetDelete)
                                              }),
                                              .cancel()
                        ])
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle(personsOverview)
            .navigationBarItems(leading:
                Button(action: {
                    /// Rutine for å friske opp personoversikten
                    self.refresh()
                }, label: {
                    Text("Refresh")
                        .foregroundColor(.none)
                })
                , trailing:
                Button(action: {
                    /// Rutine for å legge til en person
                    self.newPerson.toggle()
                }, label: {
                    Text("Add")
                })
            )
        }
        .sheet(isPresented: $newPerson) {
            NewPersonView()
        }
        .onAppear {
            self.refresh()
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            case .third:
                return Alert(title: Text(self.message))
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.none)
                    })
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                    Spacer()
                }
            }
        )
    }

    /// Rutine for å friske opp bildet
    func refresh() {
        /// Sletter alt tidligere innhold i person
        self.persons.removeAll()
        /// Fetch all persons from CloudKit
        let predicate = NSPredicate(value: true)
        CloudKitPerson.fetchPerson(predicate: predicate)  { (result) in
            switch result {
            case .success(let person):
                self.persons.append(person)
                /// Sortering
                self.persons.sort(by: {$0.firstName < $1.firstName})

//                $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending
//
//               // Must use local sorting of the poststedSectionTitles
//               let region = NSLocale.current.regionCode?.lowercased() // Returns the local region
//               let language = Locale(identifier: region!)
//                let sortedpoststedSection1 = self.persons.sorted {
//                    $0.compare($1, locale: language) == .orderedAscending
//     -----<           localizedCaseInsensitiveCompare(_:)
//
//               }

            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }
}

/// Et eget View for å vise person detail view
struct ShowPersons: View {
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    var person: Person
    var removeChar: String
    var body: some View {
        HStack(spacing: 10) {
            if person.image != nil {
                Image(uiImage: person.image!)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .font(.system(size: 16, weight: .ultraLight))
                    .frame(width: 50, height: 50, alignment: .center)
            }
            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    /// Sletter første character i fornavnet dersom den er "✈️" for at 'Å' skal kommer etter 'Ø'
                    TextDeleteFirstCharacter(firstName : person.firstName, remove: removeChar)
                        .font(Font.title.weight(.ultraLight))
                    Text(person.lastName)
                        .font(Font.body.weight(.ultraLight))
                }
                    .font(Font.body.weight(.ultraLight))
                Text("\(person.dateOfBirth, formatter: Self.taskDateFormat)")
                    .font(.custom("system", size: 17))
                HStack {
                    Text(person.address)
                        .font(.custom("system", size: 17))
                }
                HStack {
                    Text(person.cityNumber)
                    Text(person.city)
                }
                .font(.custom("system", size: 17))
            }
            .padding(.top, 10)
        }
            /// Ta bort tastaturet når en klikker utenfor feltet
            .modifier(DismissingKeyboard())
            /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
            .modifier(AdaptsToSoftwareKeyboard())
    }
}

func TextDeleteFirstCharacter(firstName : String, remove: String) -> some View {
    let index0 = firstName.index(firstName.startIndex, offsetBy: 0)
    let index1 = firstName.index(firstName.startIndex, offsetBy: 1)
    if remove.count > 0 {
        if firstName[index0...index0] == remove {
            return Text(firstName[index1...])
        }
    }

    return Text(firstName)
}

