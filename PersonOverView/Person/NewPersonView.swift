//
//  NewPersonView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 01/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct NewPersonView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var newPerson = NSLocalizedString("New person", comment: "NewPersonView")
    @State private var showingImagePicker = false
    @State private var findPostalCodeNewPerson = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var firstName: String = ""
    @State private var tmpFirstName: String = ""
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
    @State private var showRefreshButton = false
    @State private var changeButtonText = false
    @State private var recordID: CKRecord.ID?
    @State private var saveNumber: Int = 0

    var buttonText1 = NSLocalizedString("Modify", comment: "NewPersonView")
    var buttonText2 = NSLocalizedString("Save", comment: "NewPersonView")

    var genders = [NSLocalizedString("Man", comment: "NewPersonView"),
                   NSLocalizedString("Woman", comment: "NewPersonView")]

    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .center, spacing: 60) {
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
                    Button(NSLocalizedString("Profile Image", comment: "NewPersonView")) {
                        self.showingImagePicker.toggle()
                    }
                    Button(NSLocalizedString("Refresh", comment: "NewPersonView")) {
                        if globalCityNumberNewPerson.count > 0 {
                            self.cityNumber = globalCityNumberNewPerson
                        }
                        if globalMunicipalityNumberNewPerson.count > 0 {
                            self.municipalityNumber = globalMunicipalityNumberNewPerson
                        }
                        if globalMunicipalityNameNewPerson.count > 0 {
                            self.municipality = globalMunicipalityNameNewPerson
                        }
                    }
                    /// Skjuler teksten uten å påvirke layout
                    .opacity(showRefreshButton ? 1 : 0)
                }
                .padding(.top, 40)
                .sheet(isPresented: $showingImagePicker, content: {
                    ImagePicker.shared.view
                }).onReceive(ImagePicker.shared.$image) { image in
                    self.image = image
                }
                Form {
                    InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                   checkPhone: false,
                                   secure: false,
                                   heading: NSLocalizedString("First name", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your first name", comment: "NewPersonView"),
                                   value: $firstName)
                        .autocapitalization(.words)
                    InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                   checkPhone: false,
                                   secure: false,
                                   heading: NSLocalizedString("Last name", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your last name", comment: "NewPersonView"),
                                   value: $lastName)
                        .autocapitalization(.words)
                    InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                   checkPhone: false,
                                   secure: false,
                                   heading: NSLocalizedString("eMail", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "NewPersonView"),
                                   value: $personEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                   checkPhone: false,
                                   secure: false,
                                   heading: NSLocalizedString("Address", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your address", comment: "NewPersonView"),
                                   value: $address)
                        .autocapitalization(.words)
                    InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                   checkPhone: true,
                                   secure: false,
                                   heading: NSLocalizedString("Phone Number", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your phone number", comment: "NewPersonView"),
                                   value: $phoneNumber)
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                       checkPhone: false,
                                       secure: false,
                                       heading: NSLocalizedString("Postalcode", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "NewPersonView"),
                                       value: $cityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                       checkPhone: false,
                                       secure: false,
                                       heading: NSLocalizedString("City", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter city", comment: "NewPersonView"),
                                       value: $city)
                            .autocapitalization(.words)
                        VStack {
                            Button(action: {
                                self.findPostalCodeNewPerson.toggle()
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.blue)
                                    .font(.title)
                            })
                            }
                            .sheet(isPresented: $findPostalCodeNewPerson) {
                                FindPostalCodeNewPerson(city: self.city,
                                                        firstName: self.firstName,
                                                        lastName: self.lastName,
                                                        showRefreshButton: self.$showRefreshButton)
                            }
                    }
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                       checkPhone: false,
                                       secure: false,
                                       heading: NSLocalizedString("Municipality number", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "NewPersonView"),
                                       value: $municipalityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(showPassword: UserDefaults.standard.bool(forKey: "showPassword"),
                                       checkPhone: false,
                                       secure: false,
                                       heading: NSLocalizedString("Municipality", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter municipality", comment: "NewPersonView"),
                                       value: $municipality)
                            .autocapitalization(.none)
                            .autocapitalization(.words)
                    }
                    DatePicker(
                        selection: $dateOfBirth,
                        // in: ...dato,                  /// Uten in: -> ingen begrensning på datoutvalg
                        displayedComponents: [.date],
                        label: {
                            Text(NSLocalizedString("Date of birth", comment: "NewPersonView"))
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                                .padding(-5)
                    })
                    /// Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: NSLocalizedString("Gender", comment: "NewPersonView"),
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

                                                            /// Finner recordID etter å ha lagret den nye personen
                                                            let firstName = self.firstName
                                                            let lastName = self.lastName
                                                            let predicate = NSPredicate(format: "firstName == %@ AND lastName = %@", firstName, lastName)
                                                            CloudKitPerson.fetchPerson(predicate: predicate)  { (result) in
                                                                switch result {
                                                                case .success(let person):
                                                                    self.recordID = person.recordID
                                                                case .failure(let err):
                                                                    print(err.localizedDescription)
                                                                }
                                                            }
                                                            if self.recordID != nil {
                                                                self.ModifyNewPerson(recordID: self.recordID,
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
                                                                                     dateMonthDay: MonthDay(date: self.dateOfBirth),
                                                                                     gender: self.gender,
                                                                                     image: self.image)
                                                            } else {
                                                                self.message = NSLocalizedString("Can not modify this person yet, due to missing value for its recordID.\nPlease try again later...", comment: "NewPersonView")
                                                                self.alertIdentifier = AlertID(id: .third)
                                                            }
                                                        } else {
                                                            self.saveNumber += 1
                                                            if self.saveNumber == 1 {
                                                                self.changeButtonText = false
                                                                self.tmpFirstName = self.firstName
                                                                /// Dersom første tegn i firstName er "Å" legg firstName etter en emoji
                                                                /// Eks, firstName = "😀" + "Ågot"
                                                                /// Dersom første tegn er en emoji ikke endre firstName
                                                                let index0 = self.tmpFirstName.index(self.tmpFirstName.startIndex, offsetBy: 0)
                                                                let firstChar = String(self.tmpFirstName[index0...index0])
                                                                if firstChar.containsEmoji == false, firstChar.uppercased() == "Å"  {
                                                                    self.tmpFirstName = "😀" + self.tmpFirstName
                                                                }
                                                                let person = Person(
                                                                                    firstName: self.tmpFirstName,
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
                                                                        self.changeButtonText = true
                                                                        let person1 = "'\(self.firstName)" + " \(self.lastName)'"
                                                                        let message1 =  NSLocalizedString("was saved", comment: "NewPersonView")
                                                                        self.message = person1 + " " + message1
                                                                        self.alertIdentifier = AlertID(id: .first)
                                                                    case .failure(let err):
                                                                        self.message = err.localizedDescription
                                                                        self.alertIdentifier = AlertID(id: .first)
                                                                    }
                                                                }
                                                            }
                                                        }
                        }
                    } else {
                        self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "NewPersonView")
                        self.alertIdentifier = AlertID(id: .first)
                    }
                }, label: {
                   Text(changeButtonText ? buttonText1 : buttonText2)
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
            /// Skal bare lagre dersom saveNumber ==0
            self.saveNumber = 0
            /// Skjuler "Refresh" før en har valgt "Sted" (poststed)
            self.showRefreshButton = false
            /// Sletter det sist valgte bildet fra ImagePicker
            ImagePicker.shared.image = nil
            /// Sletter også selve image
            self.image = nil
            /// Resetter de globale variablene
            globalCityNumber  = ""
            globalMunicipalityNumber  = ""
            globalMunicipalityName  = ""
            globalCityNumberNewPerson = ""
            globalMunicipalityNumberNewPerson = ""
            globalMunicipalityNameNewPerson = ""
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

    func ModifyNewPerson(recordID: CKRecord.ID?,
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
                         dateMonthDay: String,
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
            personItem.dateMonthDay = MonthDay(date: dateOfBirth)
            personItem.gender = gender
            /// Først vises det gamle bildet til personen, så kommer det nye bildet opp
            if image != nil {
                personItem.image = image
            }
            CloudKitPerson.modifyPerson(item: personItem) { (result) in
            switch result {
                case .success:
                    let person = "'\(personItem.firstName)" + " \(personItem.lastName)'"
                    let message1 =  NSLocalizedString("was modified", comment: "PersonView")
                    self.message = person + " " + message1
                    self.alertIdentifier = AlertID(id: .second)
                case .failure(let err):
                    self.message = err.localizedDescription
                    self.alertIdentifier = AlertID(id: .second)
                }
            }
        }
        else {
            self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "PersonView")
            self.alertIdentifier = AlertID(id: .first)
        }
    }


}

