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
    @State private var findPostalCodeNewPerson = false

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
                }
                .padding(.top, 40)
                .sheet(isPresented: $showingImagePicker, content: {
                    ImagePicker.shared.view
                }).onReceive(ImagePicker.shared.$image) { image in
                    self.image = image
                }
                Form {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("First name", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your first name", comment: "NewPersonView"),
                                   value: $firstName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Last name", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your last name", comment: "NewPersonView"),
                                   value: $lastName)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "NewPersonView"),
                                   value: $personEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Address", comment: "NewPersonView"),
                                   placeHolder: NSLocalizedString("Enter your address", comment: "NewPersonView"),
                                   value: $address)
                        .autocapitalization(.words)
//                    InputTextField(secure: false,
//                                   heading: NSLocalizedString("Phone Number", comment: "NewPersonView"),
//                                   placeHolder: NSLocalizedString("Enter your phone number", comment: "NewPersonView"),
//                                   value: $phoneNumber)

                    ZStack {
                        VStack (alignment: .leading) {
                            Text(NSLocalizedString("Phone Number", comment: "NewPersonView"))
                                .padding(-5)
                                .font(Font.caption.weight(.semibold))
                                .foregroundColor(.accentColor)
                            TextField(NSLocalizedString("Enter your phone number", comment: "NewPersonView"),
                                      text: $phoneNumber,
                                      onEditingChanged: { _ in self.formatPhone(phone: self.phoneNumber) } /// Kommer når en går inn i et felt eller forlater det
                                ///   onCommit: { self.formatPhone(phone: self.phoneNumber) }                                                            /// Kommer når en trykker "retur" på tastatur
                                     )
                                .padding(-7)
                                .padding(.horizontal, 15)
                        }
                    }

                    // .keyboardType(.xxxxxxx)
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Postalcode", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "NewPersonView"),
                                       value: $cityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
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
                                                        lastName: self.lastName)

                            }
                    }
                    HStack (alignment: .center, spacing: 0) {
                        InputTextField(secure: false,
                                       heading: NSLocalizedString("Municipality number", comment: "NewPersonView"),
                                       placeHolder: NSLocalizedString("Enter number", comment: "NewPersonView"),
                                       value: $municipalityNumber)
                            .keyboardType(.numberPad)
                        InputTextField(secure: false,
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
            /// Sletter det sist valgte bildet fra ImagePicker
            ImagePicker.shared.image = nil
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

    func formatPhone(phone: String) {
        /// Fjerne eventuelle "+47" og mellomrom
        let phone1 = phone.replacingOccurrences(of: "+47", with: "")
        let phone2 = phone1.replacingOccurrences(of: " ", with: "")
        /// Dersom lengden er 8 tegn --->  +47 123 45 6789
        if phone2.count == 8, phone2.isNumber() {
            let index2 = phone2.index(phone2.startIndex, offsetBy: 2)
            let index3 = phone2.index(phone2.startIndex, offsetBy: 3)
            let index4 = phone2.index(phone2.startIndex, offsetBy: 4)
            let index5 = phone2.index(phone2.startIndex, offsetBy: 5)
            /// phoneNumer er delklarert slik: @State private var phoneNumber: String = ""
            phoneNumber = "+47 " + String(phone2[...index2]) + " " + String(phone2[index3...index4]) + " " + String(phone2[index5...])
        } else {
            phoneNumber = phone
        }
    }

}

extension NSString  {
    func isNumber() -> Bool {
        let str: String = self as String
        return Int(str) != nil || Double(str) != nil
    }
}
