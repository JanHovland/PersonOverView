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
    @State private var show: Bool = false
    @State private var newItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showingImagePicker = false
    var body: some View {
        VStack {
            Text(NSLocalizedString("Delete user", comment: "UserDeleteView"))
                .multilineTextAlignment(.center)
                .font(Font.headline.weight(.semibold))
                .foregroundColor(.accentColor)
            ZStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .font(Font.title.weight(.ultraLight))
                /// Her legges aktuelt bilde oppå "person.circle"
                if user.image != nil {
                    Image(uiImage: user.image!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                }
            }
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
            }.padding(.bottom)
                /// Fjerner linjer mellom elementene
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            Button(action: {
                if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
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
                            self.show.toggle()
                        case .failure(let err):
                            self.message = err.localizedDescription
                            self.show.toggle()
                        }
                    }
                } else {
                    self.message = NSLocalizedString("Missing parameters", comment: "UserDeleteView")
                    self.show.toggle()
                }
             }, label: {
                 Text(NSLocalizedString("Delete user", comment: "UserDeleteView"))
             })
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
                    self.message = NSLocalizedString("Unknown email or password:", comment: "UserDeleteView")
                    self.show.toggle()
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
                        }
                    }
                }
            }
        }
        .modifier(DismissingKeyboard())
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
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
                        .padding(.top, 80)
                    Spacer()
                }
            }
        )
    }
}

