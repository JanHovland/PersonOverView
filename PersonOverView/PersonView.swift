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
    
    @EnvironmentObject var settings: UserSettings
    
    var genders = ["Man", "Woman"]
    
    var body: some View {
        VStack {
            if settings.hideTabBar {
                toSignInView()
            } else {
                Form {
                    InputTextField(secure: false, heading: "First name",   placeHolder: "Enter your first name",    value: $firstName)
                    InputTextField(secure: false, heading: "Last name",    placeHolder: "Enter your last name",     value: $lastName)
                    InputTextField(secure: false, heading: "eMail",        placeHolder: "Enter your email address", value: $personEmail)
                    InputTextField(secure: false, heading: "Address",      placeHolder: "Enter your address",       value: $address)
                    InputTextField(secure: false, heading: "Phone Number", placeHolder: "Enter your phone number",  value: $phoneNumber)
                    HStack {
                        InputTextField(secure: false, heading: "City", placeHolder: "Enter the city", value: $city)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    InputTextField(secure: false, heading: "Municipality", placeHolder: "Enter your municipality",  value: $municipality)
                    DatePicker(
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: [.date],
                        label: {
                            Text("Date of birth")
                                .font(.footnote)
                                .padding(-5)
                    })
                    // Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: "Gender ", genders: genders, value: $gender)
                }
            }
        }
        // Removes all separators below in the List view
        .listStyle(GroupedListStyle())
    }
}

