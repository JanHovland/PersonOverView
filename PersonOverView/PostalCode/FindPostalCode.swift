//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct FindPostalCode: View {

    var city: String
    var firstName: String
    var lastName: String
    var person: Person

    @Environment(\.presentationMode) var presentationMode

    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false
    @State private var selection = 0
    @State private var pickerVisible = false
    @State  var message: String = ""
    @State  var alertIdentifier: AlertID?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("City")
                        Spacer()
                        if self.postalCodes.count > 0 {
                            Button(self.postalCodes[selection].postalNumber + " " + self.postalCodes[selection].postalName) {
                               self.pickerVisible.toggle()
                            }
                            .foregroundColor(self.pickerVisible ? .red : .blue)
                        }
                    }
                    if pickerVisible {
                         Picker(selection: $selection, label: EmptyView()) {
                            ForEach((0..<postalCodes.count), id: \.self) { ix in
                                Text(self.postalCodes[ix].postalNumber + " " + self.postalCodes[ix].postalName).tag(ix)
                            }
                        }
                        /// Denne sørger for å vise det riktige "valget" pålinje 2
                        .id(UUID().uuidString)
                        .onTapGesture {
                            self.pickerVisible.toggle()
                            print("Postnummer: \(self.postalCodes[self.selection].postalNumber)")
                            print("Fornavn: \(self.person.firstName)")
                            print("Gammelt postnummer: \(self.person.cityNumber)")
                            /// Feilmelding:  Cannot assign to property: 'self' is immutable
                            //  self.person.cityNumber = self.postalCodes[self.selection].postalNumber
                            /// Modify person data, men det kommer inger status meldinger !!!!!!!
//                            CloudKitPerson.ModifyPerson(recordID: self.person.recordID,
                            self.ModifyPersonFindPostalCode(recordID: self.person.recordID,
                                                            firstName: self.firstName,
                                                            lastName: self.lastName,
                                                            personEmail: self.person.personEmail,
                                                            address: self.person.address,
                                                            phoneNumber: self.person.phoneNumber,
                                                            city: self.city,
                                                            cityNumber: self.postalCodes[self.selection].postalNumber,  //self.person.cityNumber,
                                                            municipalityNumber: self.person.municipalityNumber,
                                                            municipality: self.person.municipality,
                                                            dateOfBirth: self.person.dateOfBirth,
                                                            gender: self.person.gender,
                                                            image: self.person.image)

                            self.selection = 0
                            /// Nå vises Alert

                            // self.presentationMode.wrappedValue.dismiss()

                        }
                    }
                }
            }
            .navigationBarTitle("PostalCode", displayMode: .inline)
        }
        .onAppear {
            self.zoomPostalCode(value: self.city)
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                print(".second = \(self.message)")
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

/// Funksjon for å sette første bokstav til uppercase
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

func ModifyPerson(recordID: CKRecord.ID?,
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
                  image: UIImage?) -> (Bool) {

    var modified = false

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
                modified = true
//                let person = "'\(personItem.firstName)" + " \(personItem.lastName)'"
//                let message1 =  NSLocalizedString("was modified", comment: "PersonsOverView")
//                message = person + " " + message1
//                print(message as Any)
//                alertIdentifier = AlertID(id: .second)
//                _ = Alert(title: Text(message))
        case .failure( _):
                modified = false
//                message = err.localizedDescription
//                alertIdentifier = AlertID(id: .second)



            
            }
        }
        modified = false

    }
//    else {
//        message = NSLocalizedString("First name and last name must both contain a value.", comment: "PersonsOverView")
//    }

    return(modified)
}

