//
//  SignInView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

//  Bug in 13.2 and 13.3 (17C5038a)  see: https://forums.developer.apple.com/thread/124757
//  similar issue. I have a "normal" NavigationLink for my details view and going back to the list view causes the same crash as mentioned.
//  All used to work well with ios 13.1 (iPhone and iPad), after upgrading to ios 13.2, the crash occurs.

import SwiftUI

struct SignInView : View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "")
    
    @EnvironmentObject var userElements: UserElements

    var body: some View {
        Form {
            VStack (alignment: .center) {
                Spacer(minLength: 30)
                Image("CloudKit")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                Spacer(minLength: 30)
                Text("Sign In CloudKit")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 30)
                VStack {
                    InputTextField(secure: false,
                                   heading: "Your name",
                                   placeHolder: "Enter your name",
                                   value: $newItem.name)
                        .autocapitalization(.words)

                    Spacer(minLength: 30)

                    InputTextField(secure: false,
                                   heading: "eMail address",
                                   placeHolder: "Enter your email address",
                                   value: $newItem.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 30)

                    InputTextField(secure: true,
                                   heading: "Password",
                                   placeHolder: "Enter your Enter your password",
                                   value: $newItem.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 30)

                }
                .padding(10)

                VStack {
                    Button(action: {
                        if self.newItem.email.count > 0, self.newItem.password.count > 0 {
                            // Check if the user exists
                            let email = self.newItem.email
                            let password = self.newItem.password
                            
                            // Check different predicates at :   https://nspredicate.xyz
                            // %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.
                            
                            let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
                            
                            CloudKitUser.doesUserExist(name: self.newItem.name,
                                                       email: self.newItem.email) { (result) in
                                                        if result == false {
                                                            self.message = "Unknown user: '\(self.newItem.name)'"
                                                        } else {
                                                            CloudKitUser.fetchUser(predicate: predicate) { (result) in
                                                                switch result {
                                                                case .success(let newItem):
                                                                    self.userElements.user.append(newItem)
                                                                    self.message = "Fetched user: '\(self.newItem.name)'"
                                                                    self.newItem.name = newItem.name
                                                                    self.newItem.email = newItem.email
                                                                    self.newItem.password = newItem.password
                                                                case .failure(let err):
                                                                    self.message = err.localizedDescription
                                                                }
                                                            }
                                                        }
                            }
                            self.show.toggle()
                        }
                        else {
                            self.message = "Both eMail and Password must have a value"
                            self.show.toggle()
                        }
                        
                    }) {
                        Text("Sign In")
                            .padding(10)
                    }
                }
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
    }
}

