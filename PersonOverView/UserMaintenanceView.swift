//
//  UserMaintenanceView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct AlertID: Identifiable {
    enum Choice {
        case first, second
    }

    var id: Choice
}

struct UserMaintenanceView: View {
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    // @State private var show: Bool = false
    @State private var newItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showingImagePicker = false

    @State private var alertIdentifier: AlertID?

    var body: some View {
        VStack {
            Text(NSLocalizedString("User maintenance", comment: "UserMaintenanceView"))
                .font(Font.title.weight(.light))
                .foregroundColor(.accentColor)
            ZStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .font(Font.title.weight(.ultraLight))
                if user.image != nil {
                    Image(uiImage: user.image!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(color: .gray, radius: 3)
                }
            }
            .padding(.bottom)
            VStack {
                List {
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("Your name", comment: "UserMaintenanceView"),
                                   placeHolder: NSLocalizedString("Enter your name", comment: "UserMaintenanceView"),
                                   value: $user.name)
                        .autocapitalization(.words)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail address", comment: "UserMaintenanceView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "UserMaintenanceView"),
                                   value: $user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    InputTextField(secure: true,
                                   heading: NSLocalizedString("Password", comment: "UserMaintenanceView"),
                                   placeHolder: NSLocalizedString("Enter your password", comment: "UserMaintenanceView"),
                                   value: $user.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer()
                    HStack (alignment: .center, spacing: 30) {
                        Button(NSLocalizedString("Choose Profile Image", comment: "UserMaintenanceView")) {
                            self.showingImagePicker.toggle()
                        }
                        Text(NSLocalizedString("(Hold and press to activate)", comment: "UserMaintenanceView"))
                            .font(.footnote)
                    }
                    .foregroundColor(.blue)
                    Button(action: {
                        self.alertIdentifier = AlertID(id: .second)
                    }, label: {
                       HStack (alignment: .center, spacing: 30) {
                           Text(NSLocalizedString("Modify user", comment: "UserMaintenanceView"))
                            Text(NSLocalizedString("(Hold and press to activate)", comment: "UserMaintenanceView"))
                                    .font(.footnote)
                        }
                        .foregroundColor(.red)
                        })
                    }.padding(.bottom)
                    /// Fjerner linjer mellom elementene
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
        }
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.user.image  = image
        }
        .onAppear {
            let email = self.user.email
            CloudKitUser.doesUserExist(email: self.user.email, password: self.user.password) { (result) in
                if result == false {
                    self.message = NSLocalizedString("Unknown email or password:", comment: "SignInView")
                    self.alertIdentifier = AlertID(id: .first)
                } else {
                    let predicate = NSPredicate(format: "email == %@", email)
                    CloudKitUser.fetchUser(predicate: predicate) { (result) in
                        switch result {
                        case .success(let userItem):
                            if userItem.image != nil {
                                self.user.image = userItem.image!
                            }
                        case .failure(let err):
                            self.message = err.localizedDescription
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }
                }
            }
        }
        .modifier(DismissingKeyboard())
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(NSLocalizedString("Update user", comment: "UserMaintenanceView")),
                          message: Text(NSLocalizedString("Are you sure you want to update this user?", comment: "UserMaintenanceView")),
                          primaryButton: .default(Text(NSLocalizedString("Yes", comment: "UserMaintenanceView")),
                          action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.newItem.name = self.user.name
                                self.newItem.email = self.user.email
                                self.newItem.password = self.user.password
                                self.newItem.recordID = self.user.recordID
                                // MARK: - modify in CloudKit
                                CloudKitUser.modifyUser(item: self.newItem) { (result) in
                                    switch result {
                                    case .success:
                                        self.message = NSLocalizedString("Successfully modified the user", comment: "UserMaintenanceView")
                                        self.alertIdentifier = AlertID(id: .first)
                                    case .failure(let err):
                                        self.message = err.localizedDescription
                                        self.alertIdentifier = AlertID(id: .first)
                                    }
                                }
                            } else {
                                self.message = NSLocalizedString("Missing parameters", comment: "UserMaintenanceView")
                                self.alertIdentifier = AlertID(id: .first)
                            }
                          }),
                          secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "UserMaintenanceView"))))
            }

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
                        .padding(.top, 100)
                    Spacer()
                }
            }
        )
    }
}
