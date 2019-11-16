//
//  SignInView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

//  Bug in 13.2 and 13.3 (17C5038a)  see: https://forums.developer.apple.com/thread/124757
//  similar issue. I have a "normal" NavigationLink for my details view and going back to the list view causes the same crash as mentioned.
//  All used to work well with ios 13.1 (iPhone and iPad), after upgrading to ios 13.2, the crash occurs.

import SwiftUI

struct SignInView : View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selection: Int? = nil
    @State private var show: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                HStack {
                    Image("CloudKit")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                    Text("Sign In CloudKit")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                }.padding(40)
                
                VStack (alignment: .leading) {
                    InputTextField(heading: "eMail address", placeHolder: "Enter your email address", value: $email)
                }
                .padding(15)
                
                VStack (alignment: .leading) {
                    InputTextField(heading: "Password",      placeHolder: "Enter your password",      value: $password)
                }
                .padding(15)
                
                Text("Password must be at least 8 characters long")
                    .font(.footnote)
                    .foregroundColor(.red)
                
                HStack {
                    Button(action: {
                        // Check if the user is authorized
                        if CheckUser(eMail: self.email, password: self.password) {
                            self.message = "OK"
                        } else {
                            self.message = "Wrong"
                        }
                        self.show.toggle()
                    }) {
                        Text("Login")
                    }.padding(15)
                    
                    Spacer(minLength: 15)
                    
                    NavigationLink(destination: SignUpView(), tag: 4, selection: self.$selection) {
                        Text("")
                    }
                    Text("No account?")
                    Button(action: {
                        self.selection = 4
                    }) {
                        Text("Sign Up")
                    } .padding(15)
                }
                Spacer(minLength: 20)
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
    }
}

