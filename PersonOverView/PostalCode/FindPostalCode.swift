//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

    var qw: String =  "" // postalCode()

    var globalPostalNumber: String = ""
    var globalPostalName: String = ""
    var globalMunicipalityNumber: String = ""
    var globalMunicipalityName: String = ""
    var globalCategori: String = ""

struct FindPostalCode: View {

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    // @EnvironmentObject var postalCodeSettings: PostalCodeSettings

    @State private var searchText: String = ""
    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false

    @State private var colours = ["Egersund", "Vigrestad", "Varhaug", "Nærbø", "Bryne", "Klepp", "Sandnes"]
    @State private var selection = 0
    @State private var pickerVisible = false

    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .center) {
                    TextField("Search for PostalCode...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        self.postalCodes.removeAll()
                        self.zoomPostalCode(value: self.searchText)
                    }, label: {
                        HStack {
                            Text(NSLocalizedString("Search", comment: "FindPostalCode"))
                        }
                        .foregroundColor(.blue)
                    })
                }
                .padding(.leading, 10)
                .padding(.trailing,10)
                Spacer()
                List {

                    HStack {
                        Text("Poststed")
                        Spacer()
                        if self.postalCodes.count > 0 {
                            Text("count: \(self.postalCodes.count)")
                            Text("selection: \(selection)")
                            Button(self.postalCodes[selection].postalNumber + " " + self.postalCodes[selection].postalName) {
//                            Button("Search Poststed") {
                               self.pickerVisible.toggle()
                            }
                            .foregroundColor(self.pickerVisible ? .red : .blue)
                        }
                    }
                    if pickerVisible {
                        Picker(selection: $selection, label: Text("")) {
                            ForEach(0..<postalCodes.count) {
                                Text(self.postalCodes[$0].postalNumber + " " + self.postalCodes[$0].postalName).tag($0)
                            }
                        }
                        .onTapGesture {
                            globalPostalNumber = self.postalCodes[self.selection].postalNumber
                            globalPostalName = self.postalCodes[self.selection].postalName
                            globalMunicipalityNumber = self.postalCodes[self.selection].municipalityNumber
                            globalMunicipalityName = self.postalCodes[self.selection].municipalityName
                            globalCategori = self.postalCodes[self.selection].categori
                            qw = globalPostalNumber
                            print(qw)
                            self.pickerVisible.toggle()
                        }
                    }

//                    ForEach(postalCodes) {
//                        postalCode in
//
//                        NavigationLink(
//                        destination: DetailView(value: postalCode)) {
//                                HStack {
//                                    Text(postalCode.postalNumber)
//                                    Text(postalCode.postalName.lowercased().capitalizingFirstLetter())
//                                }
//                        }
//
//                    }
                }
            }
            .navigationBarTitle("PostalCode", displayMode: .inline)
        }
//        .onAppear {
//            self.zoomPostalCode(value: "Os")
//        }
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
            /// self.persons.sort(by: {$0.firstName < $1.firstName})
            case .failure(let err):
                print(err.localizedDescription)
                /// self.message = err.localizedDescription
                /// self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct DetailView: View {
  let value: PostalCode

  var body: some View {
    HStack {
        Text(value.postalNumber)
        Text(value.postalName.lowercased().capitalizingFirstLetter())
        Text(value.municipalityNumber)
        Text(value.municipalityName.lowercased().capitalizingFirstLetter())
    }
  }
}
