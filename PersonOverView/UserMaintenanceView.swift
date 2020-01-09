//
//  UserMaintenanceView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct UserMaintenanceView: View {

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @EnvironmentObject var m: Main

    var body: some View {
        VStack {
            Text(m.name)             /// "User maintenance")
                .font(.largeTitle)
                .padding(.top)
            List {
                InputTextField(secure: false,
                               heading: NSLocalizedString("Your name", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your name", comment: "UserMaintenanceView"),
                               value: $name)
                    .autocapitalization(.words)

                InputTextField(secure: false,
                               heading: NSLocalizedString("eMail address", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your email address", comment: "UserMaintenanceView"),
                               value: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                InputTextField(secure: true,
                               heading: NSLocalizedString("Password", comment: "UserMaintenanceView"),
                               placeHolder: NSLocalizedString("Enter your password", comment: "UserMaintenanceView"),
                               value: $password)
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
