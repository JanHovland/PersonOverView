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
import CloudKit

struct PersonView : View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var person: Person

    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var showingImagePicker = false
    @State   var image: UIImage? = nil

    @State  var personItem = PersonElement(firstName: "",
                                           lastName: "",
                                           personEmail: "",
                                           address: "",
                                           phoneNumber: "",
                                           cityNumber: "",
                                           city: "",
                                           municipalityNumber: "",
                                           municipality: "",
                                           dateOfBirth: Date(),
                                           gender: 0,
                                           image: nil)

    var genders = [NSLocalizedString("Man", comment: "PersonView"),
                   NSLocalizedString("Woman", comment: "PersonView")]

    var body: some View {
        NavigationView {
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
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(color: .gray, radius: 3)
                        }
                    }
                    Button(NSLocalizedString("Choose Profile Image", comment: "SignUpView")) {
                        self.showingImagePicker.toggle()
                    }
                }
                .sheet(isPresented: $showingImagePicker, content: {
                    ImagePicker.shared.view
                }).onReceive(ImagePicker.shared.$image) { image in
                    self.image = image
                }

                Form {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("First name", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your first name", comment: "PersonView"),
                                   value: $person.firstName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Last name", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your last name", comment: "PersonView"),
                                   value: $person.lastName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "PersonView"),
                                   value: $person.personEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Address", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your address", comment: "PersonView"),
                                   value: $person.address)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Phone Number", comment: "PersonView"),
                                   placeHolder: NSLocalizedString("Enter your phone number", comment: "PersonView"),
                                   value: $person.phoneNumber)
                    // .keyboardType(.xxxxxxx)
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Postalcode", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "PersonView"),
                                       value: $person.cityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("City", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter city", comment: "PersonView"),
                                       value: $person.city)
                            .autocapitalization(.words)
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
                                       value: $person.municipalityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality", comment: "PersonView"),
                                       placeHolder: NSLocalizedString("Enter municipality", comment: "PersonView"),
                                       value: $person.municipality)
                            .autocapitalization(.words)
                    }
                    DatePicker(
                        selection: $person.dateOfBirth,
                        in: ...Date(),
                        displayedComponents: [.date],
                        label: {
                            Text(NSLocalizedString("Date of birth", comment: "PersonView"))
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                                .padding(-5)
                    })
                    // Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: NSLocalizedString("Gender", comment: "PersonView"), genders: genders, value: $person.gender)
                }

            }
                // Removes all separators below in the List view
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Person")
                .navigationBarItems(leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(NSLocalizedString("Cancel", comment: "PersonView"))
                            .foregroundColor(.none)
                    })
                    , trailing:
                    Button(action: {
                        /// Save person data
                        if self.person.firstName.count > 0, self.person.lastName.count > 0 {
                            CloudKitPerson.doesPersonExist(firstName: self.person.firstName,
                                                           lastName: self.person.lastName) { (result) in
                                                            if result == false {
                                                                self.personItem.firstName = self.person.firstName
                                                                self.personItem.lastName = self.person.lastName
                                                                self.personItem.personEmail = self.person.personEmail
                                                                self.personItem.address = self.person.address
                                                                self.personItem.phoneNumber = self.person.phoneNumber
                                                                self.personItem.city = self.person.city
                                                                self.personItem.cityNumber = self.person.cityNumber
                                                                self.personItem.municipalityNumber = self.person.municipalityNumber
                                                                self.personItem.municipality = self.person.municipality
                                                                self.personItem.dateOfBirth = self.person.dateOfBirth
                                                                self.personItem.gender = self.person.gender
                                                                self.personItem.image = self.image
                                                                CloudKitPerson.savePerson(item: self.personItem) { (result) in
                                                                    switch result {
                                                                    case .success:
                                                                        let message1 = NSLocalizedString("Added new person:", comment: "PersonView")
                                                                        self.message = message1 + " '\(self.personItem.firstName)" + " \(self.personItem.lastName)'"
                                                                        self.alertIdentifier = AlertID(id: .first)
                                                                    case .failure(let err):
                                                                        print(err.localizedDescription)
                                                                        self.message = err.localizedDescription
                                                                        self.alertIdentifier = AlertID(id: .first)
                                                                    }
                                                                }
                                                            } else {
                                                                let firstName = self.person.firstName
                                                                let lastName = self.person.lastName
                                                                let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@", firstName, lastName)
                                                                /// Må finne recordID for å kunne modifisere personen  i  CloudKit
                                                                CloudKitPerson.fetchPerson(predicate: predicate) { (result) in
                                                                    switch result {
                                                                    case .success(let perItem):
                                                                        self.person.recordID = perItem.recordID
                                                                        self.person.firstName = perItem.firstName
                                                                        self.person.lastName = perItem.lastName
                                                                        self.person.personEmail = perItem.personEmail
                                                                        self.person.address = perItem.address
                                                                        self.person.phoneNumber = perItem.phoneNumber
                                                                        self.person.city = perItem.city
                                                                        self.person.cityNumber = perItem.cityNumber
                                                                        self.person.municipalityNumber = perItem.municipalityNumber
                                                                        self.person.municipality = perItem.municipality
                                                                        self.person.dateOfBirth = perItem.dateOfBirth
                                                                        self.person.gender = perItem.gender
                                                                        /// Setter image (personens bilde)  til det bildet som er lagret på personen
                                                                        self.image = perItem.image
                                                                    case .failure(let err):
                                                                        self.message = err.localizedDescription
                                                                        self.alertIdentifier = AlertID(id: .first)
                                                                    }
                                                                }

                                                                /// Modify the person in CloudKit
//                                                                self.personItem.recordID = self.person.recordID
//                                                                self.personItem.firstName = self.person.firstName
//                                                                self.personItem.lastName = self.person.lastName
//                                                                self.personItem.personEmail = self.person.personEmail
//                                                                self.personItem.address = self.person.address
//                                                                self.personItem.phoneNumber = self.person.phoneNumber
//                                                                self.personItem.city = self.person.city
//                                                                self.personItem.cityNumber = self.person.cityNumber
//                                                                self.personItem.municipalityNumber = self.person.municipalityNumber
//                                                                self.personItem.municipality = self.person.municipality
//                                                                self.personItem.dateOfBirth = self.person.dateOfBirth
//                                                                self.personItem.gender = self.person.gender
//
////                                                                if ImagePicker.shared.image != nil {
////                                                                    self.personItem.image = ImagePicker.shared.image
////                                                                    self.person.image = ImagePicker.shared.image
////                                                                    ImagePicker.shared.image = nil
////                                                                }
////                                                                else {
////                                                                    self.personItem.image = self.person.image
////                                                                }
//
////                                                                if self.image != nil {
////
////                                                                    self.personItem.image = self.image
////                                                                }
//
//                                                                CloudKitPerson.modifyPerson(item: self.personItem) { (result) in
//                                                                    switch result {
//                                                                    case .success:
//                                                                        self.image = self.personItem.image
//                                                                        let person = "'\(self.personItem.firstName)" + " \(self.personItem.lastName)'"
//                                                                        let message1 =  NSLocalizedString("was modified", comment: "PersonView")
//                                                                        self.message = person + " " + message1
//                                                                        self.alertIdentifier = AlertID(id: .first)
//                                                                    case .failure(let err):
//                                                                        self.message = err.localizedDescription
//                                                                        self.alertIdentifier = AlertID(id: .first)
//                                                                    }
//                                                                }
                                                            }
                            }
                        } else {
                            self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "PersonView")
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }, label: {
                        Text("Save")
                            .foregroundColor(.none)
                    })
            )}
            .alert(item: $alertIdentifier) { alert in
                switch alert.id {
                case .first:
                    return Alert(title: Text(self.message))
                case .second:
                    return Alert(title: Text(self.message))
                }
        }
//        .sheet(isPresented: $showingImagePicker, content: {
//            ImagePicker.shared.view
//        }).onReceive(ImagePicker.shared.$image) { image in
//            self.person.image = image
//        }
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
    }
}


