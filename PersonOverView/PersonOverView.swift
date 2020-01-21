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
             SignInView()  /// SignInView()  qwerty()
                .tabItem {
                     VStack {
                         Image(systemName: "arrow.right.to.line.alt")
                         Text("Sign in")
                     }
                }
                .tag(0)
            SignUpView()
                .tabItem {
                    VStack {
                        Image(systemName: "arrow.right.to.line.alt")
                        Text("Sign Up")
                    }
                }
                .tag(1)
            AdministrationView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Administration")
                    }
                }
                .tag(2)
            ToDoView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Todo")
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

