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
                Button(action: {
                    UserDefaults.standard.set(self.showPassword, forKey: "showPassword")
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            }
            .navigationBarTitle(NSLocalizedString("Administration", comment: "AdministrationView"))
        }
        .onAppear {
            self.showPassword = UserDefaults.standard.bool(forKey: "showPassword")
        }
       .padding()
    }
}
