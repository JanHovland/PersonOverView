//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

var globalCityNumber = ""
var globalmunicipalityNumber = ""
var globalmunicipalityName = ""

struct FindPostalCode: View {

    var city: String
    var firstName: String
    var lastName: String
    var person: Person

    @Environment(\.presentationMode) var presentationMode
    // @EnvironmentObject var postalCodeSettings: PostalCodeSettings

    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false
    @State private var selection = 0
    @State private var pickerVisible = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    var defaultWheelPickerItemHeight = 2


    var body: some View {

        VStack {
            Spacer(minLength: 40)
            Text("Select postalcode")
                .font(.title)
            Spacer()
            List {
                HStack {
                    Text(self.city)
                    Spacer()
                    if self.postalCodes.count > 0 {
                        Button(self.postalCodes[selection].postalNumber) {
                            self.pickerVisible.toggle()
                        }
                        .foregroundColor(self.pickerVisible ? .red : .blue)
                    }
                }
                if pickerVisible {
                    Picker(selection: $selection, label: EmptyView()) {
                        ForEach((0..<postalCodes.count), id: \.self) { ix in
                            HStack (alignment: .center) {
                                Text(self.postalCodes[ix].postalNumber).tag(ix)
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                        /// Denne sørger for å vise det riktige "valget" pålinje 2
                        .id(UUID().uuidString)
                        .onTapGesture {
                            /// postalCodes og de globale variablene blir resatt av: .onAppear
                            if self.postalCodes[self.selection].postalNumber.count > 0,
                                self.postalCodes[self.selection].municipalityNumber.count > 0,
                                self.postalCodes[self.selection].municipalityName.count > 0 {
                                globalCityNumber = self.postalCodes[self.selection].postalNumber
                                globalmunicipalityNumber = self.postalCodes[self.selection].municipalityNumber
                                globalmunicipalityName = self.postalCodes[self.selection].municipalityName
                            }
                            self.pickerVisible.toggle()
                            // print(self.postalCodes[self.selection].postalNumber)
                            self.ModifyPersonFindPostalCode(recordID: self.person.recordID,
                                                            firstName: self.firstName,
                                                            lastName: self.lastName,
                                                            personEmail: self.person.personEmail,
                                                            address: self.person.address,
                                                            phoneNumber: self.person.phoneNumber,
                                                            city: self.city,
                                                            cityNumber: globalCityNumber,
                                                            municipalityNumber: globalmunicipalityNumber,
                                                            municipality: globalmunicipalityName,
                                                            dateOfBirth: self.person.dateOfBirth,
                                                            gender: self.person.gender,
                                                            image: self.person.image)
                            
                            self.selection = 0
                            /// Avslutter bildet
                            self.presentationMode.wrappedValue.dismiss()

                    }
                }
            }
        }
        .navigationBarTitle("PostalCode", displayMode: .inline)
        .onAppear {
            globalCityNumber = ""
            globalmunicipalityNumber = ""
            globalmunicipalityName = ""
            self.zoomPostalCode(value: self.city)
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
    }

    /// Rutine for å finne postnummert
    func zoomPostalCode(value: String) {
        /// Sletter alt tidligere innhold
        self.postalCodes.removeAll()
        /// Dette predicate gir følgende feilmelding: Your request contains 4186 items which is more than the maximum number of items in a single request (400)
        /// Dersom operation.resultsLimit i CloudKitPostalCode er for høy verdi 500 er OK
        /// let predicate = NSPredicate(value: true)
        /// Dette predicate gir ikke noen feilmelding
        let predicate = NSPredicate(format: "postalName == %@", value.uppercased())
        /// Dette predicate gir ikke noen feilmelding
        /// let predicate = NSPredicate(format:"postalName BEGINSWITH %@", value.uppercased())
        CloudKitPostalCode.fetchPostalCode(predicate: predicate) { (result) in
            switch result {
            case .success(let postalCode):
                self.postalCodes.append(postalCode)
                /// Sortering
                self.postalCodes.sort(by: {$0.postalName < $1.postalName})
                self.postalCodes.sort(by: {$0.postalNumber < $1.postalNumber})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

    func ModifyPersonFindPostalCode(recordID: CKRecord.ID?,
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
                    self.alertIdentifier = AlertID(id: .first)
                case .failure(let err):
                    self.message = err.localizedDescription
                    self.alertIdentifier = AlertID(id: .first)
                }
            }
        }
        else {
            self.message = NSLocalizedString("First name and last name must both contain a value.", comment: "PersonsOverView")
            self.alertIdentifier = AlertID(id: .first)
        }
    }


}

/// Funksjon for å sette første bokstav til uppercase
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

