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
    /// SearchBar er ikke er ikke en dekl av SWIFTUI
    struct SearchBar: UIViewRepresentable {
        @Binding var text: String
        class Coordinator: NSObject, UISearchBarDelegate {
            @Binding var text: String
            init(text: Binding<String>) {
                _text = text
            }
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                text = searchText
            }
        }
        func makeCoordinator() -> SearchBar.Coordinator {
            return Coordinator(text: $text)
        }
        func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
            let searchBar = UISearchBar(frame: .zero)
            searchBar.delegate = context.coordinator
            searchBar.placeholder = NSLocalizedString("Search for a person...", comment: "PersonsOverView")
            searchBar.autocapitalizationType = .none
            return searchBar
        }
        func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
            uiView.text = text
        }
    }

    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var searchText: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()
    @State private var newPerson = false
    @State private var personsOverview = NSLocalizedString("Persons overview", comment: "PersonsOverView")

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    /// Søker etter personer som inneholder $searchText i for- eller etternavnet
                    ForEach(persons.filter({ self.searchText.isEmpty ||
                                             $0.firstName.localizedStandardContains(self.searchText) ||
                                             $0.lastName.localizedStandardContains (self.searchText)    })) {
                        person in
                        NavigationLink(destination: PersonView(person: person)) {
                            ShowPersons(person: person)
                        }
                    }
                    /// Sletter  valgt person og oppdaterer CliudKit
                    .onDelete { (indexSet) in
                        guard let recordID = self.persons[indexSet.first!].recordID else { return }
                        CloudKitPerson.deletePerson(recordID: recordID) { (result) in
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
                        self.persons.remove(atOffsets: indexSet)
                    }
                }
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
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
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
        var body: some View {
            HStack(spacing: 10) {
                if person.image != nil {
                    Image(uiImage: person.image!)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                }
                VStack (alignment: .leading, spacing: 5) {
                    HStack {
                        Text(person.firstName)
                        .font(.custom("system", size: 19)).bold()
                        Text(person.lastName)
                        .font(.custom("system", size: 19)).bold()
                    }
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
}

