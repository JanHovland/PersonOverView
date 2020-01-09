//
//  DeleteUserView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct DeleteUserView: View {
        @EnvironmentObject var m: Main
    var body: some View {
        ScrollView {
            NavigationView {
                Text("Delete a user View")
            }
            .navigationBarTitle(m.name)
        }
    }
}

struct DeleteUserView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUserView()
    }
}
