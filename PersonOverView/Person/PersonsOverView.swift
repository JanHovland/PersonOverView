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

    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()
    @State private var newPerson = false
    @State private var personsOverview = NSLocalizedString("Persons overview", comment: "PersonsOverView")

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(persons) {
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
                    print(self.DateToString(date: Date()))
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
            print(self.DateToString(date: Date()))
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

    func DateToString(date: Date) -> String {
        /// ref: https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
        /// Returnerer 02.02.2020 for 2. februar 2020
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: date) 
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
        var person: Person
        var body: some View {
            HStack(spacing: 5) {
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
                            .bold()
                        Text(person.lastName)
                            .bold()
                    }

                    /// Text(person.dateOfBirth as String)
                    HStack {
                        Text(person.address)
                        Text(person.cityNumber)
                        Text(person.city)
                    }
                }
                .padding()
            }
        }
    }

}

