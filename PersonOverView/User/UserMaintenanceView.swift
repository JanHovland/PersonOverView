//
//  UserMaintenanceView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct UserMaintenanceView: View {

    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showingImagePicker = false
    @State private var maintenanceActionSheet = false

    @State private var alertIdentifier: AlertID?


    var body: some View {
        VStack {
            Text(NSLocalizedString("User maintenance", comment: "UserMaintenanceView"))
                .font(Font.title.weight(.light))
                .foregroundColor(.accentColor)
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
                    Text(NSLocalizedString("Hold and release to activate the actions below", comment: "UserMaintenanceView"))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.blue)
                    HStack {
                        Button(NSLocalizedString("Choose Profile Image", comment: "UserMaintenanceView")) {
                            self.showingImagePicker.toggle()
                        }
                        Image(systemName: "photo")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .foregroundColor(.blue)
                    HStack {
                        Button(NSLocalizedString("Modify user", comment: "UserMaintenanceView")) {
                            self.maintenanceActionSheet.toggle()
                        }
                        Image(systemName: "square.and.pencil")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .foregroundColor(.blue)
                }.padding(.bottom)
                    /// Fjerner linjer mellom elementene
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
        }
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        })

            .onReceive(ImagePicker.shared.$image) { image in
                self.user.image = image
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
        .actionSheet(isPresented: $maintenanceActionSheet) {
            ActionSheet(title: Text(NSLocalizedString("Update an user", comment: "UserMaintenanceView")),
                        message: Text(NSLocalizedString("Are you sure you want to update this user?", comment: "UserDeleteView")),
                        buttons: [.default(Text(NSLocalizedString("No", comment: "UserMaintenanceView")), action: {
                            // print("default")
                        }),
                                  .destructive(Text("Update this user"), action: {
                                    if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                        self.newItem.name = self.user.name
                                        self.newItem.email = self.user.email
                                        self.newItem.password = self.user.password
                                        self.newItem.recordID = self.user.recordID
                                        if ImagePicker.shared.image != nil {
                                            self.newItem.image = ImagePicker.shared.image
                                        }
                                        // MARK: - modify in CloudKit
                                        CloudKitUser.modifyUser(item: self.newItem) { (result) in
                                            switch result {
                                            case .success:
                                                self.message = NSLocalizedString("Successfully modified this user", comment: "UserMaintenanceView")
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
