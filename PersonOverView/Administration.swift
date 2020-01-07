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
                Section(header: Text("")) {
                    NavigationLink(destination: DeleteUserView()) {
                        Text("Delete user")
                    }
                }
            }
            .navigationBarTitle("Administration")
        }
        .navigationBarTitle("Delete User")
    }
}
