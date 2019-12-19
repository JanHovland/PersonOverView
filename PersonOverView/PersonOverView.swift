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

    var body: some View {
        TabView {
           SwiftUIImagePicker()
               .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Image")
                    }
               }
               .tag(0)
            SignInView()
                .tabItem {
                     VStack {
                         Image(systemName: "arrow.right.to.line.alt")
                         Text("Sign in")
                     }
                }
                .tag(1)
            SignUpView()
                .tabItem {
                    VStack {
                        Image(systemName: "arrow.right.to.line.alt")
                        Text("Sign Up")
                    }
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(3)
            PersonView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Persons")
                    }
                }
                .tag(4)
        }
    }
}

