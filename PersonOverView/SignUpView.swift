//
//  SignupView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 15/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI
import CloudKit


struct SignUpView : View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "")
    
    @EnvironmentObject var userElements: UserElements
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        VStack (alignment: .center) {
            HStack {
                Image("CloudKit")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .clipShape(Circle())
                Text("Sign Up CloudKit")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            VStack (alignment: .leading) {
                InputTextField(disabled: false, secure: false, heading: "Enter your name", placeHolder: "Enter your name", value: $newItem.name)
                    .autocapitalization(.words)
            }
            .padding(10)
            VStack (alignment: .leading) {
                InputTextField(disabled: false, secure: false, heading: "eMail address", placeHolder: "Enter your email address", value: $newItem.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(10)
            VStack (alignment: .leading) {
                InputTextField(disabled: false, secure: true, heading: "Password", placeHolder: "Enter your password", value: $newItem.password)
            }
            .padding(10)
            //            Text("Password must be at least 8 characters long")
            //                .font(.footnote)
            //                .foregroundColor(.blue)
            if settings.hideTabBar {
                Text(self.settings.hideMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(10)
            } else {
                Text("")
            }
            VStack {
                Button(action: {
                    if self.newItem.name.count > 0, self.newItem.email.count > 0, self.newItem.password.count > 0 {
                        
                        CloudKitUser.doesUserExist(name: self.newItem.name,
                                                   email: self.newItem.email) { (result) in
                            if result == false {
                                // MARK: - saving to CloudKit
                                CloudKitUser.saveUser(item: self.newItem) { (result) in
                                    switch result {
                                    case .success(let newItem):
                                        self.userElements.user.insert(newItem, at: 0)
                                        self.message = "Successfully added user \(self.newItem.name)"
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                        self.message = err.localizedDescription
                                    }
                                }

                            } else {
                                self.message = "The user: \(self.newItem.name) already exists"
                            }
                        }
                   } else {
                        self.message = "Name, eMail or Password must all contain a value."
                    }
                    self.show.toggle()
                }) {
                    Text("Sign up")
                        .padding(45)
                }
            }
        }
        // MARK: - endre logikk slik at message ikke vises dersom message = nil
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
        }
    }
}

