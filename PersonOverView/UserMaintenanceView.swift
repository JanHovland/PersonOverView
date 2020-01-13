//
//  UserMaintenanceView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct UserMaintenanceView: View {
    @EnvironmentObject var user: User
    @State private var message: String = ""
    @State private var show: Bool = false
    @State var newItem = UserElement(name: "", email: "", password: "", image: nil)
    @State private var showingImagePicker = false
    @State var image: UIImage? = nil

    @EnvironmentObject var userElements: UserElements

    var body: some View {
        VStack {
            Text(NSLocalizedString("User maintenance", comment: "UserMaintenanceView"))
                .font(.largeTitle)
                .padding(.top)

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

                // Text(user.recordID)
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
                Button(NSLocalizedString("Choose Profile Image", comment: "UserMaintenanceView")) {
                    self.showingImagePicker.toggle()
                }

            }.padding(.bottom)
                /// Fjerner linjer mellom elementene
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)

            Button(action: {
                if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {

                    self.newItem.name = self.user.name
                    self.newItem.email = self.user.email
                    self.newItem.password = self.user.password
                    self.newItem.recordID = self.user.recordID

                    // MARK: - modify in CloudKit
                    CloudKitUser.modifyUser(item: self.newItem) { (result) in
                        switch result {
                        case .success:
                            print("Successfully modified item")
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                } else {
                    self.message = "Missing parameters"
                    self.show.toggle()
                }
             }, label: {
                 Text("Modify user")
             })

        }
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.image = image
            self.user.image  = image
        }

        .modifier(DismissingKeyboard())
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
        }

    }
}
