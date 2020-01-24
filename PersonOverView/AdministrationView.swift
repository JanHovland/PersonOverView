//
//  AdministrationView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct AdministrationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPassword: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Password", comment: "AdministrationView"))) {
                    Toggle(isOn: $showPassword) {
                        Text(NSLocalizedString("Show password", comment: "AdministrationView"))
                    }
                }
            }
            .navigationBarTitle(NSLocalizedString("Administration", comment: "AdministrationView"))
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.none)
                })
                , trailing:
                    Button(action: {
                        UserDefaults.standard.set(self.showPassword, forKey: "showPassword")
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .foregroundColor(.none)
                    })
                )}
      .onAppear {
            self.showPassword = UserDefaults.standard.bool(forKey: "showPassword")
        }
    }

}

