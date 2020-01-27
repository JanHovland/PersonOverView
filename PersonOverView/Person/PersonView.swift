//
//  PersonOverView.swift
//  PersonView
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

// Short cuts made by me:
// Ctrl + Cmd + / (on number pad)  == Comment or Uncomment
// Ctrl + Cmd + * (on number pad)  == Indent

import SwiftUI

struct PersonView : View {

    @Environment(\.presentationMode) var presentationMode

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var personEmail: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var cityNumber: String = ""
    @State private var city: String = ""
    @State private var municipalityNumber: String = ""
    @State private var municipality: String = ""
    @State private var dateOfBirth = Date()
    @State private var gender = 0

    var genders = [NSLocalizedString("Man", comment: "PersonView"),
                   NSLocalizedString("Woman", comment: "PersonView")]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("First name", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your first name", comment: "PersonView"),
                                   value: $firstName)

                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Last name", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your last name", comment: "PersonView"),
                                   value: $lastName)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "PersonView"),
                                   value: $personEmail)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Address", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your address", comment: "PersonView"),
                                   value: $address)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Phone Number", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your phone number", comment: "PersonView"),
                                   value: $phoneNumber)
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Postalcode", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "PersonView"),
                                       value: $cityNumber)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("City", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("City", comment: "PersonView"),
                                       value: $city)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality number", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "PersonView"),
                                       value: $municipalityNumber)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Municipality", comment: "PersonView"),
                                       value: $municipality)
                    }
                    DatePicker(
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: [.date],
                        label: {
                            Text(NSLocalizedString("Date of birth", comment: "PersonView"))
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                                .padding(-5)
                    })
                    // Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: NSLocalizedString("Gender", comment: "PersonView"), genders: genders, value: $gender)
                }

            }
                // Removes all separators below in the List view
                .listStyle(GroupedListStyle())

                /// Ta bort tastaturet når en klikker utenfor feltet
                .modifier(DismissingKeyboard())
                /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
                .modifier(AdaptsToSoftwareKeyboard())

                .navigationBarTitle("Person")
                .navigationBarItems(leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.none)
                    })
                    , trailing:
                    Button(action: {
                        /// Save person data
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .foregroundColor(.none)
                    })
            )}
    }
}

