//
//  Administration.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct Administration: View {
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Users")) {
                    NavigationLink(destination: DeleteUserView()) {
                        Text("Delete user")
                            .padding(.leading)
                    }
                }
                Section {
                    NavigationLink(destination: DeleteUserView()) {
                        Text("Update name")
                            .padding(.leading)
                    }
                }
                Section(header: Text("Miscellaneous")) {
                    NavigationLink(destination: DeleteUserView()) {
                        Text("New password")
                            .padding(.leading)
                    }
                }
            }
            .navigationBarTitle("Administration")
        }
    }
}
