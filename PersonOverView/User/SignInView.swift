//
//  SignInView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)


/// Ref: SwiftUICloudKit-master-3

import SwiftUI
import Combine

struct SignInView : View {
    
    @EnvironmentObject var user: User
    @EnvironmentObject var person: Person
    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var userItem = UserElement(name: "", email: "", password: "")
    @State private var showUserMaintenanceView: Bool = false
    @State private var showDeleteUserView: Bool = false
    @State private var showAdministrationView: Bool = false
    @State private var showToDoView: Bool = false
    @State private var showPersonView: Bool = false

    @State private var showOptionMenu = false

    @State private var alertIdentifier: AlertID?

    var body: some View {
        ScrollView  {
            VStack {
                Spacer(minLength: 17)
                HStack {
                    Text(NSLocalizedString("Sign in CloudKit", comment: "SignInView"))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                ZStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .font(Font.title.weight(.ultraLight))
                    if self.user.image != nil {
                        Image(uiImage: self.user.image!)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: .gray, radius: 3)
                    }
                }
                HStack (alignment: .center, spacing: 10) {
                    Text(NSLocalizedString("Options Menu", comment: "SignInView"))
                        /// Skjuler teksten uten å påvirke layout
                        .opacity(showOptionMenu ? 1 : 0)
                    Image(systemName: "square.stack")      ///"line.horizontal.3")
                        /// Skjuler bildet  uten å påvirke layout
                        .opacity(showOptionMenu ? 1 : 0)
                }
                .foregroundColor(.accentColor)
                .padding(10)
                .contextMenu {
                    /// User maintenance
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showUserMaintenanceView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                        }, label: {
                            Text(NSLocalizedString("User maintenance", comment: "SignInView"))
                            Image(systemName: "square.and.pencil")
                                .font(Font.system(.headline).weight(.thin))

                        })
                    }
                    .sheet(isPresented: $showUserMaintenanceView) {
                        /// må kalles på denne måten for å kunne benytte flere environmentObject
                        UserMaintenanceView().environmentObject(self.user)
                    }
                    /// Delete user
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showDeleteUserView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("Delete user", comment: "SignInView"))
                                Image(systemName: "trash")
                                    .font(Font.system(.headline).weight(.thin))
                            }
                            .foregroundColor(.red)
                        })
                    }
                    .sheet(isPresented: $showDeleteUserView) {
                        /// må kalles på denne måten for å kunne benytte flere environmentObject
                        UserDeleteView().environmentObject(self.user)
                    }
                    /// Settings
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showAdministrationView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("Settings", comment: "SignInView"))
                                Image(systemName: "gear")
                                    .font(Font.system(.headline).weight(.thin))
                            }
                            .foregroundColor(.red)
                        })
                    }
                    .sheet(isPresented: $showAdministrationView) {
                        SettingView()
                    }
                    /// ToDo
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showToDoView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("To do", comment: "SignInView"))
                                Image(systemName: "square.and.pencil")
                                    .font(Font.system(.headline).weight(.thin))
                            }
                            .foregroundColor(.red)
                        })
                    }
                    .sheet(isPresented: $showToDoView) {
                        ToDoView()
                    }
                    /// Person
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showPersonView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("Person", comment: "SignInView"))
                                Image(systemName: "person")
                                    .font(Font.system(.headline).weight(.thin))
                            }
                            .foregroundColor(.red)
                        })
                    }
                    .sheet(isPresented: $showPersonView) {
                        PersonView().environmentObject(self.person)
                    }
                    /// Uten padding blir noe av visningen kuttet bort
                    .padding()
                    /// Brukes for å få med "Image(systemName: "chevron.down")"
                    .overlay(
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("Exit", comment: "SignInView"))
                                Image(systemName: "return")
                                    .font(Font.system(.title).weight(.ultraLight))
                            }
                        })
                    )
                }
                Spacer(minLength: 32)
                VStack (alignment: .leading) {
                    OutputTextField(secure: false,
                                    heading: NSLocalizedString("Your name", comment: "SignInView"),
                                    value: $user.name)
                        .autocapitalization(.words)
                    Spacer(minLength: 22)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail address", comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "SignInView"),
                                   value: $user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                    InputTextField(secure: true,
                                   heading: NSLocalizedString("Password",  comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your password", comment: "SignInView"),
                                   value: $user.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                }
                .padding(10)
                VStack {
                    Button(action: {
                        if self.user.email.count > 0, self.user.password.count > 0 {
                            /// Skjuler OptionMenu
                            self.showOptionMenu = false
                            let email = self.user.email
                            /// Check different predicates at :   https://nspredicate.xyz
                            /// %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.
                            let predicate = NSPredicate(format: "email == %@", email)
                            CloudKitUser.doesUserExist(email: self.user.email, password: self.user.password) { (result) in
                                if result == false {
                                    self.message = NSLocalizedString("Unknown email or password:", comment: "SignInView")
                                    self.alertIdentifier = AlertID(id: .first)
                                } else {
                                    CloudKitUser.fetchUser(predicate: predicate) { (result) in
                                        switch result {
                                        case .success(let userItem):
                                            self.user.email = userItem.email
                                            self.user.password = userItem.password
                                            self.user.name = userItem.name
                                            if userItem.image != nil {
                                                self.user.image = userItem.image!
                                            } else {
                                                self.user.image = nil
                                            }
                                            self.user.recordID = userItem.recordID
                                            /// Viser OptionMenu
                                            self.showOptionMenu = true
                                        case .failure(let err):
                                            self.message = err.localizedDescription
                                            self.alertIdentifier = AlertID(id: .first)
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            self.message = NSLocalizedString("Both email and Password must have a value", comment: "SignInView")
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }) {
                        Text(NSLocalizedString("Sign In", comment: "SignInView"))
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
        }
            /// Ta bort tastaturet når en klikker utenfor feltet
            .modifier(DismissingKeyboard())
            /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
            .modifier(AdaptsToSoftwareKeyboard())
    }
}