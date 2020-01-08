//
//  UserMaintenanceView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct UserMaintenanceView: View {
    @State private var userItem = UserElement(name: "", email: "", password: "", image: nil)
    var body: some View {
        VStack {
            Text("User maintenance")
                .font(.largeTitle)
                .padding(.top)
            Form {
                InputTextField(secure: false,
                               heading: NSLocalizedString("Your name", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your name", comment: "UserMaintenanceView"),
                               value: $userItem.name)
                    .autocapitalization(.words)

                InputTextField(secure: false,
                               heading: NSLocalizedString("eMail address", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your email address", comment: "UserMaintenanceView"),
                               value: $userItem.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                InputTextField(secure: true,
                               heading: NSLocalizedString("Password", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your password", comment: "UserMaintenanceView"),
                               value: $userItem.password)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }.padding(.bottom)

        }

    }

}


struct UserMaintenanceView_Previews: PreviewProvider {
    static var previews: some View {
        UserMaintenanceView()
    }
}
