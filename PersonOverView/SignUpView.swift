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
    @State private var image: Image? = nil
    @State private var showingImagePicker = false
    @State private var userItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showUserMaintenanceView: Bool = false
    
    @EnvironmentObject var userElements: UserElements
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 20)
                HStack {
                    Text(NSLocalizedString("Sign Up CloudKit", comment: "SignUpView"))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                Spacer(minLength: 20)
                ZStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .font(Font.title.weight(.ultraLight))
                    // Her legges aktuelt bilde oppå "person.circle"
                    if image != nil {
                        image!
                            .resizable()
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                }
                Spacer(minLength: 20)
                Button(NSLocalizedString("Choose Profile Image", comment: "SignUpView")) {
                    self.showingImagePicker.toggle()
                }
                VStack {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Your name", comment: "SignUpiew"),
                                   placeHolder: NSLocalizedString("Enter your name", comment: "SignUpView"),
                                   value: $userItem.name)
                        .autocapitalization(.words)
                    Spacer(minLength: 20)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail address", comment: "SignUpView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "SignUpView"),
                                   value: $userItem.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                    InputTextField(secure: true,
                                   heading: NSLocalizedString("Password", comment: "SignUpView"),
                                   placeHolder: NSLocalizedString("Enter your password", comment: "SignUpView"),
                                   value: $userItem.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                }
                .padding(10)
                VStack {
                    Button(action: {
                        if self.userItem.name.count > 0, self.userItem.email.count > 0, self.userItem.password.count > 0 {
                            CloudKitUser.doesUserExist(email: self.userItem.email,
                                                       password: self.userItem.password) { (result) in
                                                        if result == false {
                                                            CloudKitUser.saveUser(item: self.userItem) { (result) in
                                                                switch result {
                                                                case .success(let userItem):
                                                                    self.userElements.users.insert(userItem, at: 0)
                                                                    let message1 = NSLocalizedString("Added new user:", comment: "SignUpView")
                                                                    self.message = message1 + " '\(self.userItem.name)'"
                                                                    self.show.toggle()
                                                                case .failure(let err):
                                                                    print(err.localizedDescription)
                                                                    self.message = err.localizedDescription
                                                                    self.show.toggle()
                                                                }
                                                            }
                                                        } else {
                                                            let user = "'\(self.userItem.name)'"
                                                            let message1 = NSLocalizedString("The user:", comment: "SignUpView")
                                                            let message2 =  NSLocalizedString("already exists", comment: "SignUpView")
                                                            self.message = message1 + " " + user + " " + message2
                                                            self.show.toggle()
                                                        }
                            }
                        } else {
                            self.message = NSLocalizedString("Name, eMail or Password must all contain a value.", comment: "SignUpView")
                            self.show.toggle()
                        }
                    }) {
                        Text("Sign up")
                            .padding(10)
                    }
                }
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }.sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.image = image
        }
        .modifier(DismissingKeyboard())
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

