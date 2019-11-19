//
//  SettingsView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        NavigationView {
            VStack {
                if settings.hideTabBar {
                    NavigationLink(destination: SignInView()) {
                        Text("You are not logged in")
                    }
                } else {
                    Text("Settings")
                        .font(.title)
                }
            }
        }
    }
}


