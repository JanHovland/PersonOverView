//
//  PersonsOverView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 29/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct PersonsOverView: View {

    @EnvironmentObject var personElements: PersonElements
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                List(personElements.persons) { person in
                    HStack(spacing: 5) {
                        Image(uiImage: person.image!)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        Text(person.firstName)
                        Text(person.lastName)
                        Text(person.address)
                        Text(person.cityNumber)
                        Text(person.city)
                    }
                }
                .navigationBarTitle(NSLocalizedString("Persons overview", comment: "PersonsOverView"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(NSLocalizedString("Cancel", comment: "PersonsOverView"))
                            .foregroundColor(.none)
                    }))
            }
        }
        .onAppear {
            /// Sletter alt tidligere innhold i personElements.persons
            self.personElements.persons.removeAll()
            /// Fetch all persons from CloudKit
            let predicate = NSPredicate(value: true)
            CloudKitPerson.fetchPerson(predicate: predicate)  { (result) in
                switch result {
                case .success(let newItem):
                    self.personElements.persons.append(newItem)
                    print("Successfully fetched item")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}

