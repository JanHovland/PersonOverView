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
    
    @State private var email: String = "jan.hovland@lyse.net"
    @State private var password: String = ""
    @State private var selection: Int? = nil
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "")
    
    @EnvironmentObject var userElements: UserElements
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                HStack {
                    Image("CloudKit")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipShape(Circle())
                    Text("Sign In CloudKit")
                        .font(.largeTitle)
                }.padding(40)
                
                VStack (alignment: .leading) {
                    InputTextField(secure: false, heading: "eMail address", placeHolder: "Enter your email address", value: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(15)
                
                VStack (alignment: .leading) {
                    InputTextField(secure: true, heading: "Password", placeHolder: "Enter your password", value: $password)
                }
                .padding(15)
                
                Text("Password must be at least 8 characters long")
                    .font(.footnote)
                    .foregroundColor(.red)
                
                HStack {
                    Button(action: {
                        
                        // Check if the user exists
                        
                        let email = self.email
                        let password = self.password
                        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

                        self.message = ""
                        self.show = false
                        
                        CloudKitUser.fetchUser(predicate: predicate) { (result) in
                            switch result {
                            case .success(let newItem):
                                self.userElements.user.append(newItem)
                                self.message = "Successfully fetched user's data"
                                // UITabBar.appearance().isHidden = false
                            case .failure(let err):
                                self.message = err.localizedDescription
                                self.show.toggle()
                            }
                        }
                        if self.message.count == 0 {
                            self.message = "User does not exist"
                           self.show.toggle()
                        }
                        
                        // self.show.toggle()
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
                    } .padding(30)
                }
                Spacer(minLength: 50)
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
    }
}

