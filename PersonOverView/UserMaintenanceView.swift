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
            }.padding(.bottom)
                /// Fjerner linjer mellom elementene
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)

        }
        .onAppear {
            // MARK: - fetch from CloudKit
            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                let email = self.user.email
                let predicate = NSPredicate(format: "email == %@", email)
                CloudKitUser.fetchUser(predicate: predicate) { (result) in
                    switch result {
                    case .success(let userItem):
                        self.userElements.user.append(userItem)
//                        self.message = "Successfully fetched item"
//                        self.show.toggle()
                    case .failure(let err):
                        self.message = err.localizedDescription
                        self.show.toggle()
                    }
                }
            } else {
                self.message = "Missing parameters"
                self.show.toggle()
            }
        }
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
        }

    }
}
