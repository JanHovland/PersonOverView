//
//  NewPersonView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 01/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct NewPersonView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var newPerson = NSLocalizedString("New person", comment: "NewPersonView")
    @State private var showingImagePicker = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
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
    @State private var gender: Int = 0
    @State private var image: UIImage?

    var genders = [NSLocalizedString("Man", comment: "PersonsOverView"),
                   NSLocalizedString("Woman", comment: "PersonsOverView")]

    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .center, spacing: 50) {
                    ZStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .font(Font.title.weight(.ultraLight))
                        if self.image != nil {
                            Image(uiImage: self.image!)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        }
                    }
                    Button(NSLocalizedString("Choose Profile Image", comment: "SignUpView")) {
                        self.showingImagePicker.toggle()
                    }
                }
                .padding(.top, 40)
                .sheet(isPresented: $showingImagePicker, content: {
                    ImagePicker.shared.view
                }).onReceive(ImagePicker.shared.$image) { image in
                    self.image = image
                }
                Form {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("First name", comment: "PersonsOverView"),
                                   placeHolder: NSLocalizedString("Enter your first name", comment: "PersonsOverView"),
                                   value: $firstName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Last name", comment: "PersonsOverView"),
                                   placeHolder: NSLocalizedString("Enter your last name", comment: "PersonsOverView"),
                                   value: $lastName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail", comment: "PersonsOverView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "PersonsOverView"),
                                   value: $personEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Address", comment: "PersonsOverView"),
                                   placeHolder: NSLocalizedString("Enter your address", comment: "PersonsOverView"),
                                   value: $address)
                        .autocapitalization(.sentences)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Phone Number", comment: "PersonsOverView"),
                                   placeHolder: NSLocalizedString("Enter your phone number", comment: "PersonsOverView"),
                                   value: $phoneNumber)
                    // .keyboardType(.xxxxxxx)
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Postalcode", comment: "PersonsOverView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "PersonsOverView"),
                                       value: $cityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("City", comment: "PersonsOverView"),
                                       placeHolder: NSLocalizedString("Enter city", comment: "PersonsOverView"),
                                       value: $city)
                            .autocapitalization(.words)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality number", comment: "PersonsOverView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "PersonsOverView"),
                                       value: $municipalityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality", comment: "PersonsOverView"),
                                       placeHolder: NSLocalizedString("Enter municipality", comment: "PersonsOverView"),
                                       value: $municipality)
                            .autocapitalization(.words)
                    }
                    DatePicker(
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: [.date],
                        label: {
                            Text(NSLocalizedString("Date of birth", comment: "PersonsOverView"))
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                                .padding(-5)
                    })
                    /// Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: NSLocalizedString("Gender", comment: "PersonsOverView"),
                                genders: genders,
                                value: $gender)
                }
            }
            .navigationBarTitle(Text(newPerson), displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    /// Rutine for å returnere til personoversikten
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.none)
                        Text(NSLocalizedString("Person overview", comment: "NewPersonView"))
                            .foregroundColor(.none)
                    }
                })
                , trailing:
                Button(action: {
                    /// Rutine for å legge til en person
                    if self.firstName.count > 0, self.lastName.count > 0 {
                        CloudKitPerson.doesPersonExist(firstName: self.firstName,
                                                       lastName: self.lastName) { (result) in
                                                        if result == true {
                                                            let person = "'\(self.firstName)" + " \(self.lastName)'"
                                                            let message1 =  NSLocalizedString("already exists", comment: "NewPersonView")
                                                            self.message = person + " " + message1
                                                            self.alertIdentifier = AlertID(id: .first)
                                                        } else {
                                                            let person = Person(firstName: self.firstName,
                                                                                lastName: self.lastName,
                                                                                personEmail: self.personEmail,
                                                                                address: self.address,
                                                                                phoneNumber: self.phoneNumber,
                                                                                cityNumber: self.cityNumber,
                                                                                city: self.city,
                                                                                municipalityNumber: self.municipalityNumber,
                                                                                municipality: self.municipality,
                                                                                dateOfBirth: self.dateOfBirth,
                                                                                dateMonthDay: MonthDay(date: self.dateOfBirth),
                                                                                gender: self.gender,
                                                                                image: self.image)
                                                            CloudKitPerson.savePerson(item: person) { (result) in
                                                                switch result {
                                                                case .success:
                                                                    let person = "'\(self.firstName)" + " \(self.lastName)'"
                                                                    let message1 =  NSLocalizedString("was saved", comment: "NewPersonView")
                                                                    self.message = person + " " + message1
                                                                    self.alertIdentifier = AlertID(id: .first)
                                                                case .failure(let err):
                                                                    self.message = err.localizedDescription
                                                                    self.alertIdentifier = AlertID(id: .first)
                                                                }
                                                            }
                                                        }
                        }
                    } else {
                        self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "NewPersonView")
                        self.alertIdentifier = AlertID(id: .first)
                    }
                }, label: {
                    Text(NSLocalizedString("Save", comment: "NewPersonView"))
                })
            )}

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
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
        .onAppear {
            self.image = nil
        }
    }
}

