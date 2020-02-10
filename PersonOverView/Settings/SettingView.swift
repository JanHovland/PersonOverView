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
                                                             /// Sletter hele postnummer tabellen
                                                             CloudKitPostalCode.deleteAllPostalCode()
                                                             /// Leser og lagrer fra csv filen: Postnummerregister-ansi.txt 

                                                         }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
            }
        }
    }

}


