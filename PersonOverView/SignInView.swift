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
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var newItem = UserElement(name: "", email: "", password: "")
    
    @EnvironmentObject var userElements: UserElements
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                Image("CloudKit")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .clipShape(Circle())
                Text("Sign In CloudKit")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            VStack (alignment: .leading) {
                InputTextField(disabled: true, secure: false, heading: "Your name", placeHolder: "Disabled field", value: $newItem.name)
                    .autocapitalization(.words)
            }
            .padding(10)
            VStack (alignment: .leading) {
                InputTextField(disabled: false, secure: false, heading: "eMail address", placeHolder: "Enter your email address", value: $newItem.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(10)
            VStack (alignment: .leading) {
                InputTextField(disabled: false, secure: true, heading: "Password", placeHolder: "Enter your password", value: $newItem.password)
            }
            .padding(10)
//            Text("Password must be at least 8 characters long")
//                .font(.footnote)
//                .foregroundColor(.blue)
            if settings.hideTabBar {
                Text(self.settings.hideMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(10)
            } else {
                Text("")
            }
            VStack {
                Button(action: {
                    if self.newItem.email.count > 0, self.newItem.password.count > 0 {
                        // Check if the user exists
                        let email = self.newItem.email
                        let password = self.newItem.password
                        
                        // Check different predicates at :   https://nspredicate.xyz
                        // %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.

                        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
                        
                        self.message = ""
                        self.show = false
                        
                        // self.settings.hideTabBar = false
                        
                        CloudKitUser.fetchUser(predicate: predicate) { (result,Status ) in
                            switch result {
                            case .success(let newItem):
                                self.userElements.user.append(newItem)
                                self.message = "Successfully fetched user's data"
                                self.settings.hideTabBar = Status
                                self.newItem.name = newItem.name
                                self.newItem.email = newItem.email
                                self.newItem.password = newItem.password
                                self.show.toggle()
                            case .failure(let err):
                                self.message = err.localizedDescription
                                self.show.toggle()
                            }
                        }
                        
                       print("hideTabBar #1 = \(self.settings.hideTabBar)")
                    }
                    else {
                        self.message = "Both eMail and Password must have a value"
                        self.show.toggle()
                    }
                    
                    print("hideTabBar #2 = \(self.settings.hideTabBar)")
                    
                }) {
                    Text("Sign In")
                        .padding(45)
                }
            }
        }
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
        }
    }
}
