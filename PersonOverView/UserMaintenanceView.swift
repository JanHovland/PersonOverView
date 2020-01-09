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

    var body: some View {
        VStack {
            Text(NSLocalizedString("User maintenance", comment: "UserMaintenanceView"))
                .font(.largeTitle)
                .padding(.top)
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
            }.padding(.bottom)
        }
    }
}
