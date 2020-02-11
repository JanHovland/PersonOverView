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
                            Text(NSLocalizedString("Delete PostalCode (100 at a time)", comment: "SettingView")
                            )}
                    )
                    Button(
                        action: {
                            self.alertIdentifier = AlertID(id: .third)
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
                return Alert(title: Text(NSLocalizedString("Delete PostalCode", comment: "SettingView")),
                             message: Text(NSLocalizedString("Are you sure you want to delete PostalCode?", comment: "SettingView")),
                             primaryButton: .destructive(Text(NSLocalizedString("Yes", comment: "SettingView")),
                                                         action: {
                                                            CloudKitPostalCode.deleteAllPostalCode()
                                                         }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
            case .third:
                return Alert(title: Text(NSLocalizedString("Save PostalCode", comment: "SettingView")),
                             message: Text(NSLocalizedString("Are you sure you want to save PostalCodes?", comment: "SettingView")),
                             primaryButton: .destructive(Text(NSLocalizedString("Yes", comment: "SettingView")),
                                                         action: {
                                                            // self.testSave()
                                                            self.UpdatePostalCodeFromCSV()
                                                         }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
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

    func testSave() {
        var number = 1
        let maxNumber = 51
        var postalCode: PostalCode! = PostalCode()

        repeat {
            postalCode.postalNumber = "1"
            CloudKitPostalCode.savePostalCode(item: postalCode) { (result) in
                switch result {
                case .success:
                    _ = 1
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            number += 1
        } while number < maxNumber
        print("Poster lagret: \(number-1)")
    }

    func UpdatePostalCodeFromCSV() {

        var index = 0
        /// Finner URL fra prosjektet
        guard let contentsOfURL = Bundle.main.url(forResource: "Postnummerregister-ansi", withExtension: "txt") else { return }
        /// Må bruke encoding == ascii (utf8 virker ikke)
        let postalCodes = parseCSV (contentsOfURL: contentsOfURL,
                                       encoding: String.Encoding.ascii,
                                       delimiter: "\t")
        let maxNumber =  postalCodes!.count
        repeat {
            let postalCode = postalCodes![index]
            CloudKitPostalCode.savePostalCode(item: postalCode) { (result) in
                switch result {
                case .success:
                    _ = 1
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            index += 1
        } while index < maxNumber
        print("Poster lagret: \(index)")
    }
}

/*
 @State var showAlert = false
 @State var showActionSheet = false
 @State var showAddModal = false

 var body: some View {
     VStack {
         // ALERT
         Button(action: { self.showAlert = true }) {
             Text("Show Alert")
         }
         .alert(isPresented: $showAlert) {
              // Alert(...)
              // showAlert set to false through the binding
         }

         // ACTION SHEET
         Button(action: { self.showActionSheet = true }) {
             Text("Show Action Sheet")
         }
         .actionSheet(isPresented: $showActionSheet) {
              // ActionSheet(...)
              // showActionSheet set to false through the binding
         }

         // FULL-SCREEN VIEW
         Button(action: { self.showAddModal = true }) {
             Text("Show Modal")
         }
         .sheet(isPresented: $showAddModal, onDismiss: {} ) {
             // INSERT a call to the new view, and in it set showAddModal = false to close
             // e.g. AddItem(isPresented: self.$showAddModal)
         }
 }
 */
