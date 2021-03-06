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
var globalMunicipalityNumber = ""
var globalMunicipalityName = ""

struct FindPostalCode: View {

    var city: String
    var firstName: String
    var lastName: String
    var person: Person
    @Binding var showRefreshButton: Bool

    @Environment(\.presentationMode) var presentationMode

    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false
    @State private var selection = 0
    @State private var pickerVisible = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    
    var defaultWheelPickerItemHeight = 6  /// Ser ikke ut til å ha noen innvirkning

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
                                globalMunicipalityNumber = self.postalCodes[self.selection].municipalityNumber
                                globalMunicipalityName = self.postalCodes[self.selection].municipalityName
                                globalMunicipalityName = globalMunicipalityName.lowercased()
                                globalMunicipalityName = globalMunicipalityName.capitalizingFirstLetter()
                            }
                            self.pickerVisible.toggle()
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
            globalMunicipalityNumber = ""
            globalMunicipalityName = ""
            if self.city.count > 0 {
                self.zoomPostalCode(value: self.city)
            } else {
                self.message = NSLocalizedString("You must enter a city", comment: "FindPostalCodeNewPerson")
                self.alertIdentifier = AlertID(id: .first)
            }
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
                        .padding(.top, 47)
                    Spacer()
                }
            }
        )
    }

    /// Rutine for å finne postnummeret
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
                self.showRefreshButton = true
                /// Sortering
                self.postalCodes.sort(by: {$0.postalName < $1.postalName})
                self.postalCodes.sort(by: {$0.postalNumber < $1.postalNumber})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
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

