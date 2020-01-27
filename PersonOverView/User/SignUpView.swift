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
    @State private var message: String = ""
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var userItem = UserElement(name: "", email: "", password: "", image: nil)

    @State private var alertIdentifier: AlertID?

    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 17)
                HStack {
                    Text(NSLocalizedString("Sign Up CloudKit", comment: "SignUpView"))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                ZStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .font(Font.title.weight(.ultraLight))
                    // Her legges aktuelt bilde oppå "person.circle"
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: .gray, radius: 3)

                    }
                }
                Spacer(minLength: 18)
                Button(NSLocalizedString("Choose Profile Image", comment: "SignUpView")) {
                    self.showingImagePicker.toggle()
                }
                Spacer(minLength: 43)
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
                                                                case .success:
                                                                    let message1 = NSLocalizedString("Added new user:", comment: "SignUpView")
                                                                    /// Slette feltene
                                                                    self.message = message1 + " '\(self.userItem.name)'"
                                                                    self.userItem.name = ""
                                                                    self.userItem.email = ""
                                                                    self.userItem.password = ""
                                                                    self.userItem.image = nil
                                                                    self.image = nil
                                                                    self.alertIdentifier = AlertID(id: .first)
                                                                case .failure(let err):
                                                                    print(err.localizedDescription)
                                                                    self.message = err.localizedDescription
                                                                    self.alertIdentifier = AlertID(id: .first)
                                                                }
                                                            }
                                                        } else {
                                                            let user = "'\(self.userItem.name)'"
                                                            let message1 = NSLocalizedString("The user:", comment: "SignUpView")
                                                            let message2 =  NSLocalizedString("already exists", comment: "SignUpView")
                                                            self.message = message1 + " " + user + " " + message2
                                                            self.alertIdentifier = AlertID(id: .first)
                                                        }
                            }
                        } else {
                            self.message = NSLocalizedString("Name, eMail or Password must all contain a value.", comment: "SignUpView")
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }) {
                        Text("Sign up")
                            // .padding(10)
                    }
                }
            }
            .alert(item: $alertIdentifier) { alert in
                switch alert.id {
                case .first:
                    return Alert(title: Text(self.message))
                case .second:
                    return Alert(title: Text(self.message))
                }
            }
        }.sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.image = image

        }
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
    }
}

