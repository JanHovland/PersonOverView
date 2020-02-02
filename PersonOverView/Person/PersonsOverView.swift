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

    @State private var showPersonView: Bool = false
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
                            HStack(spacing: 5) {
                                Group {
                                    if person.image != nil {
                                        Image(uiImage: person.image!)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    }
                                    Text(person.firstName)
                                    Text(person.lastName)
                                    Text(person.address)
                                    Text(person.cityNumber)
                                    Text(person.city)
                                }
                            }}
                    }
                }
            }
            .navigationBarTitle(personsOverview)
            .navigationBarItems(leading:
                Button(action: {
                    // Rutine for å friske opp personoversikten
                    self.presentationMode.wrappedValue.dismiss()
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
            /// Cannot invoke initializer for type 'NavigationLink<_, _>' with an argument list of type '(destination: NewPersonView)'
            /// NavigationLink(destination: NewPersonView())
        }
        .onAppear {
            /// Sletter alt tidligere innhold i personElements.persons
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
}

