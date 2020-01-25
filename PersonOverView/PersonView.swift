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
    
    @State private var firstName: String = ""
    @State var lastName: String = ""
    @State var personEmail: String = ""
    @State var address: String = ""
    @State var phoneNumber: String = ""
    @State var city: String = ""
    @State var municipality: String = ""
    @State var gender = 0
    @State var dateOfBirth = Date()
    
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
                    HStack {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("City", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter the city", comment: "PersonView"),
                                       value: $city)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Municipality", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your municipality", comment: "PersonView"),
                                   value: $municipality)
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
        }

    }
}

