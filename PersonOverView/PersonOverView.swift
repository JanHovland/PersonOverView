//
//  PersonOverView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)


import SwiftUI


struct PersonOverView: View {
    
    @State private var selection = 0
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        TabView(selection: $selection){
           SignInView()
               .tabItem {
                    VStack {
                        Image(systemName: "arrow.right.to.line.alt")
                        Text("Sign in")
                    }
               }
               .tag(0)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(1)
            PersonView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Personas")
                    }
                }
                .tag(2)
        }
    }
}

class UserSettings: ObservableObject {
    @Published var hideTabBar: Bool = false
}


