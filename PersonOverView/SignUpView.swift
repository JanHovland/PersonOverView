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
    @State private var userItem = UserElement(name: "", email: "", password: "")
    
    @EnvironmentObject var userElements: UserElements

    var body: some View {
        Form {
            VStack (alignment: .center) {
                //Spacer(minLength: 20)
                Image("CloudKit")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                Spacer(minLength: 20)
                Text("Sign Up CloudKit")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Spacer(minLength: 20)
                VStack {
                    InputTextField(secure: false,
                                   heading: "Your name",
                                   placeHolder: "Enter your name",
                                   value: $userItem.name)
                        .autocapitalization(.words)

                    Spacer(minLength: 20)

                    InputTextField(secure: false,
                                   heading: "eMail address",
                                   placeHolder: "Enter your email address",
                                   value: $userItem.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 20)

                    InputTextField(secure: true,
                                   heading: "Password",
                                   placeHolder: "Enter your Enter your password",
                                   value: $userItem.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 20)

                }
                .padding(10)

                VStack {
                    Button(action: {
                        if self.userItem.name.count > 0, self.userItem.email.count > 0, self.userItem.password.count > 0 {

                            CloudKitUser.doesUserExist(name: self.userItem.name,
                                                       email: self.userItem.email) { (result) in
                                                        if result == false {
                                                            // MARK: - saving to CloudKit
                                                            CloudKitUser.saveUser(item: self.userItem) { (result) in
                                                                switch result {
                                                                case .success(let userItem):
                                                                    self.userElements.user.insert(userItem, at: 0)
                                                                    self.message = "Addedd new user: '\(self.userItem.name)'"
                                                                    self.show.toggle()
                                                                case .failure(let err):
                                                                    print(err.localizedDescription)
                                                                    self.message = err.localizedDescription
                                                                    self.show.toggle()
                                                                }
                                                            }

                                                        } else {
                                                            self.message = "The user: '\(self.userItem.name)' already exists"
                                                            self.show.toggle()
                                                        }
                            }
                        } else {
                            self.message = "Name, eMail or Password must all contain a value."
                            self.show.toggle()
                        }

                    }) {
                        Text("Sign up")
                            .padding(10)
                    }
                }
            }
            // MARK: - Endre logikk slik at message ikke vises dersom message = nil
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
    }
}

struct FormField: View {
    var fieldName = ""
    @Binding var fieldValue: String

    var isSecure = false

    var body: some View {

        VStack {
            if isSecure {
                SecureField(fieldName, text: $fieldValue)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal)

            } else {
                TextField(fieldName, text: $fieldValue)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
            }

            Divider()
                .frame(height: 1)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .padding(.horizontal)

        }
    }
}
