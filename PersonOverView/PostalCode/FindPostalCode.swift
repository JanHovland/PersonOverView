//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct FindPostalCode: View {

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    @State private var searchText: String = ""
    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .center) {
                    TextField("Search for PostalCode...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
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
                    ForEach(postalCodes) {
                        postalCode in
                        HStack {
                            Text(postalCode.postalNumber)
                            Text(postalCode.postalName)
                        }
                    }
                }
            }
            .navigationBarTitle("PostalCode", displayMode: .inline)
        }
        .onAppear {
            self.zoomPostalCode(value: "Varhaug")
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
        CloudKitPostalCode.fetchPostalCode(predicate: predicate)  { (result) in
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


