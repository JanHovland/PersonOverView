//
//  SettingView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode   
    
    @State private var showPassword: Bool = true
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Password", comment: "SettingView"))) {
                    Toggle(isOn: $showPassword) {
                        Text(NSLocalizedString("Show password", comment: "SettingView"))
                    }
                }
                Section(header: Text(NSLocalizedString("PostalCode", comment: "SettingView"))) {
                    Button(
                        action: {
                            self.alertIdentifier = AlertID(id: .second)
                        },
                        label: {
                            Text(NSLocalizedString("Save PostalCode", comment: "SettingView")
                        )}
                    )
                }
            }
            .navigationBarTitle(NSLocalizedString("Settings", comment: "SettingView"))
            .navigationBarItems(trailing:
                Button(action: {
                    UserDefaults.standard.set(self.showPassword, forKey: "showPassword")
                    self.message = NSLocalizedString("Saved the setting", comment: "SettingView")
                    self.alertIdentifier = AlertID(id: .first)
                }, label: {
                    Text("Save")
                        .foregroundColor(.none)
                })
            )}
            .onAppear {
                self.showPassword = UserDefaults.standard.bool(forKey: "showPassword")
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
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(NSLocalizedString("Save PostalCode", comment: "SettingView")),
                             message: Text(NSLocalizedString("Are you sure you want to save the PostalCodes?", comment: "SettingView")),
                             primaryButton: .destructive(Text(NSLocalizedString("Yes", comment: "UserMaintenanceView")),
                                                         action: {
                                                            CloudKitPostalCode.deleteAllPostalCode()
                                                            self.UpdatePostalCodeFromCSV()
                                                         }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
            case .third:
                return Alert(title: Text(self.message))
            }
        }
    }

    func parseCSV (contentsOfURL: URL,
                   encoding: String.Encoding,
                   delimiter: String) -> [(PostalCode)]? {

        /// Hvis denne feilmeldingen kommer : Swift Error: Struct 'XX' must be completely initialized before a member is stored to
        /// endre til : var postalCode: PostalCode! = PostalCode()
        var postalCode: PostalCode! = PostalCode()
        var postalCodes: [(PostalCode)]?
            do {
                let content = try String(contentsOf: contentsOfURL,
                                         encoding: encoding)
                postalCodes = []
                let lines: [String] = content.components(separatedBy: .newlines)
                for line in lines {
                    var values:[String] = []
                    if line != "" {
                        values = line.components(separatedBy: delimiter)
                        postalCode.postalNumber = values[0]
                        postalCode.postalName = values[1]
                        postalCode.municipalityNumber = values[2]
                        postalCode.municipalityName = values[3]
                        postalCode.categori = values[4]
                        postalCodes?.append(postalCode)
                    }
                }
            } catch {
                print(error)
            }
            return postalCodes
    }

    func UpdatePostalCodeFromCSV() {

        var counter = 0

        /// Finner URL fra prosjektet
        guard let contentsOfURL = Bundle.main.url(forResource: "Postnummerregister-ansi", withExtension: "txt") else { return }
        /// Må bruke encoding == ascii (utf8 virker ikke)
        if let postalCodes = parseCSV (contentsOfURL: contentsOfURL,
                                 encoding: String.Encoding.ascii,
                                 delimiter: "\t") {
            for postalCode in postalCodes {
                counter += 1
                /// Lagre postnummerne
                CloudKitPostalCode.savePostalCode(item: postalCode) { (result) in
                    switch result {
                    case .success:
                        let _ = 1
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
        }
        let message1 = NSLocalizedString("Records stored:", comment: "SettingView")
        print(message1  + " \(counter)")
    }
}


