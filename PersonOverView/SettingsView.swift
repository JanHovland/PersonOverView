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
        VStack {
            if settings.hideTabBar {
                
                toSignInView()
                
//                NavigationView {
//                    NavigationLink(destination: SignInView()) {
//                        Text(settings.textMessage)
//                    }
//                }
            } else {
                Text("Settings")
                    .font(.title)
            }
        }
    }
}

func toSignInView() -> some View {
    SignInView()
}

func toSignUpView() -> some View {
    SignUpView()
}

