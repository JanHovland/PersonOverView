//
//  UserDeleteView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 14/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct UserDeleteView: View {

    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showingImagePicker = false
    @State private var deleteActionSheet = false

    @State private var alertIdentifier: AlertID?

    var body: some View {
        VStack {
            Text(NSLocalizedString("Delete user", comment: "UserDeleteView"))
                .font(Font.title.weight(.light))
                .foregroundColor(.accentColor)
                .padding(.top)
            ZStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .font(Font.title.weight(.ultraLight))
                if user.image != nil {
                    Image(uiImage: user.image!)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                }
            }
            .padding(.bottom)
            VStack {
                List {
                    OutputTextField(secure: false,
                                    heading: NSLocalizedString("Your name", comment: "UserDeleteView"),
                                    value: $user.name)
                    OutputTextField(secure: false,
                                    heading: NSLocalizedString("eMail address", comment: "UserDeleteView"),
                                    value: $user.email)
                    OutputTextField(secure: true,
                                    heading: NSLocalizedString("Password", comment: "UserDeleteView"),
                                    value: $user.password)
                    Text(NSLocalizedString("Hold and release to activate the actions below", comment: "UserDeleteView"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.blue)

                    HStack {
                        Button(NSLocalizedString("Delete an user", comment: "UserDeleteView")) {
                            self.deleteActionSheet.toggle()
                        }
                        Image(systemName: "trash")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .foregroundColor(.red)

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
                if result != "OK" {
                    //                    self.message = NSLocalizedString(result, comment: "UserDeleteView")
                    //                    self.alertIdentifier = AlertID(id: .first)
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
                            if self.message.contains("authentication token") {
                                self.message = NSLocalizedString("Couldn't get an authentication token", comment: "SignInView")
                            } else if self.message.contains("authenticated account") {
                                self.message = NSLocalizedString("This request requires an authenticated account", comment: "SignInView")
                            } else {
                                self.message = err.localizedDescription
                            }
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }
                }
            }
        }
        .modifier(DismissingKeyboard())
        .actionSheet(isPresented: $deleteActionSheet) {
            ActionSheet(title: Text(NSLocalizedString("Delete an user", comment: "UserDeleteView")),
                        message: Text(NSLocalizedString("Are you sure you want to delete this user?", comment: "UserDeleteView")),
                        buttons: [.default(Text(NSLocalizedString("No", comment: "UserDeleteView")), action: {
                            // print("default")
                        }),
                                .destructive(Text("Delete this user"), action: {
                                    if self.user.name.count > 0, self.user.email.count > 0,     self.user.password.count > 0 {
                                    // MARK: - delete user in CloudKit
                                    CloudKitUser.deleteUser(recordID: self.user.recordID!) { (result) in
                                        switch result {
                                        case .success:
                                            let message1 = NSLocalizedString("User", comment: "UserDeleteView")
                                            let message2 = NSLocalizedString("deleted", comment: "UserDeleteView")
                                            self.message = message1 + " '\(self.user.name)'" + " " + message2
                                            self.user.name = ""
                                            self.user.email = ""
                                            self.user.password = ""
                                            self.user.image = nil
                                            self.alertIdentifier = AlertID(id: .first)
                                        case .failure(let err):
                                            self.message = err.localizedDescription
                                            self.alertIdentifier = AlertID(id: .first)
                                        }
                                    }
                                } else {
                                    self.message = NSLocalizedString("Missing parameters", comment: "UserDeleteView")
                                    self.alertIdentifier = AlertID(id: .first)
                                }
                              }),
                              .cancel()
        ])
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            case .third:
                return Alert(title: Text(self.message))
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

