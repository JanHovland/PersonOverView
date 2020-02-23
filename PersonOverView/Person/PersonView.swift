//
//  PersonOverView.swift
//  PersonView
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

/// Short cuts made by me:
/// Ctrl + Cmd + / (on number pad)  == Comment or Uncomment
/// Ctrl + Cmd + * (on number pad)  == Indent

import SwiftUI
import CloudKit

struct PersonView : View {

    var person: Person

    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var showingImagePicker = false
    @State private var findPostalCode = false

    @State private var recordID: CKRecord.ID?
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
        VStack {
            HStack (alignment: .center, spacing: 115) {
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
                    VStack {
                    Button(action: {
                        self.findPostalCode.toggle()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                            .font(.title)
                    })
                    }
                    .sheet(isPresented: $findPostalCode) {
                        FindPostalCode(city: self.city,
                                       firstName: self.firstName,
                                       lastName: self.lastName,
                                       person: self.person)
                    }
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
        /// Removes all separators below in the List view
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Person", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.ModifyPersonPersonView(recordID: self.recordID,
                                            firstName: self.firstName,
                                            lastName: self.lastName,
                                            personEmail: self.personEmail,
                                            address: self.address,
                                            phoneNumber: self.phoneNumber,
                                            city: self.city,
                                            cityNumber: self.cityNumber,
                                            municipalityNumber: self.municipalityNumber,
                                            municipality: self.municipality,
                                            dateOfBirth: self.dateOfBirth,
                                            gender: self.gender,
                                            image: self.image)
            }, label: {
                Text(NSLocalizedString("Modify", comment: "PersonsOverView"))
            })
        )
        .onAppear {
            self.ShowPerson()
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
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
    }

    func ShowPerson() {
        self.firstName = self.person.firstName
        self.lastName = self.person.lastName
        let firstName = self.firstName
        let lastName = self.lastName
        let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@", firstName, lastName)
        /// Må finne recordID for å kunne modifisere personen  i  CloudKit
        CloudKitPerson.fetchPerson(predicate: predicate) { (result) in
            switch result {
            case .success(let perItem):
                self.recordID = perItem.recordID
                self.firstName = perItem.firstName
                self.lastName = perItem.lastName
                self.personEmail = perItem.personEmail
                self.address = perItem.address
                self.phoneNumber = perItem.phoneNumber
                self.city = perItem.city
                self.cityNumber = perItem.cityNumber
                self.municipalityNumber = perItem.municipalityNumber
                self.municipality = perItem.municipality
                self.dateOfBirth = perItem.dateOfBirth
                self.gender = perItem.gender
                /// Setter image (personens bilde)  til det bildet som er lagret på personen
                self.image = perItem.image
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

    func ModifyPersonPersonView(recordID: CKRecord.ID?,
                                firstName: String,
                                lastName: String,
                                personEmail: String,
                                address: String,
                                phoneNumber: String,
                                city: String,
                                cityNumber: String,
                                municipalityNumber: String,
                                municipality: String,
                                dateOfBirth: Date,
                                gender: Int,
                                image: UIImage?) {

        if firstName.count > 0, lastName.count > 0 {
            /// Modify the person in CloudKit
            /// Kan ikke bruke person fordi: Kan ikke inneholde @State private var fordi:  'PersonView' initializer is inaccessible due to 'private' protection level
            var personItem: PersonElement! = PersonElement()
            personItem.recordID = recordID
            personItem.firstName = firstName
            personItem.lastName = lastName
            personItem.personEmail = personEmail
            personItem.address = address
            personItem.phoneNumber = phoneNumber
            personItem.city = city
            personItem.cityNumber = cityNumber
            personItem.municipalityNumber = municipalityNumber
            personItem.municipality = municipality
            personItem.dateOfBirth = dateOfBirth
            personItem.gender = gender
            /// Først vises det gamle bildet til personen, så kommer det nye bildet opp
            if image != nil {
                personItem.image = image
            }
            CloudKitPerson.modifyPerson(item: personItem) { (result) in
            switch result {
                case .success:
                    let person = "'\(personItem.firstName)" + " \(personItem.lastName)'"
                    let message1 =  NSLocalizedString("was modified", comment: "PersonsOverView")
                    self.message = person + " " + message1
                    print(self.message as Any)
                    self.alertIdentifier = AlertID(id: .second)
                case .failure(let err):
                    self.message = err.localizedDescription
                    self.alertIdentifier = AlertID(id: .second)
                }
            }
        }
        else {
            self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "PersonsOverView")
            self.alertIdentifier = AlertID(id: .first)
        }
    }

}

