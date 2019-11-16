//
//  SignupView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 15/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI

struct SignUpView : View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
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
                    Text("Sign Up CloudKit")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                }
                
                VStack (alignment: .leading) {
                    InputTextField(heading: "Enter your name", placeHolder: "Enter your name", value: $newItem.name)
                }
                .padding(15)
                
                VStack (alignment: .leading) {
                    InputTextField(heading: "eMail address", placeHolder: "Enter your email address", value: $newItem.email)
                }
                .padding(15)
                
                VStack (alignment: .leading) {
                    InputTextField(heading: "Password", placeHolder: "Enter your password", value: $newItem.password)
                }
                .padding(15)
                
                Text("Password must be at least 8 characters long")
                    .font(.footnote)
                    .foregroundColor(.red)
                
                VStack {
                    Button(action: {
                        if !self.newItem.name.isEmpty, !self.newItem.email.isEmpty, !self.newItem.password.isEmpty {
                            let newItem = UserElement(name: self.newItem.name,
                                                      email: self.newItem.email,
                                                      password: self.newItem.password)
                            // MARK: - saving to CloudKit
                            CloudKitUser.saveUser(item: newItem) { (result) in
                                switch result {
                                case .success(let newItem):
                                    self.userElements.user.insert(newItem, at: 0)
                                    self.message = "Successfully added user"
                                case .failure(let err):
                                    print(err.localizedDescription)
                                    self.message = err.localizedDescription
                                }
                            }
                        } else {
                            self.message = "Name, eMail or password cannot be empty." 
                        }
                        self.show.toggle()
                    }) {
                        Text("Sign up")
                            .padding(15)
                    }
                }
                Spacer(minLength: 40)
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
    }
}
