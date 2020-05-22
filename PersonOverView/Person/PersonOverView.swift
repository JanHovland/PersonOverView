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
        SignInView()  // SettingView()  
//        TabView(selection: $selection){
//            SignInView()
//                .tabItem {
//                    VStack {
//                        Text("SignInView")
//                    }
//            }
//            .tag(0)
//            /// Brukes ikke lenger, men sjekk når neste verson av SwiftUI kommer
//            TestMessage()
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Text("eMail/SMS")
//                    }
//            }
//            .tag(1)
//        }
    }
}


