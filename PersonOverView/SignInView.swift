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
    @State private var image = UIImage()
    @State private var userItem = UserElement(name: "", email: "", password: "")

    @EnvironmentObject var userElements: UserElements

    var body: some View {

        ScrollView  {
            VStack (alignment: .center) {

                Spacer(minLength: 20)

                HStack {
//                    Image("CloudKit")
//                        .resizable()
//                        .frame(width: 40, height: 40, alignment: .center)
//                        .clipShape(Circle())
                    Text("Sign in CloudKit")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                Spacer(minLength: 20)

                ZStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .font(Font.title.weight(.ultraLight))
                    // Her legges aktuelt bilde oppå "person.circle"
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                }

                Spacer(minLength: 40)

                VStack (alignment: .leading) {
                    OutputTextField(secure: false,
                                   heading: NSLocalizedString("Your name", comment: "SignInView"),
                                   value: $name)
                        .autocapitalization(.words)

                    Spacer(minLength: 20)

                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail address", comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "SignInView"),
                                   value: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 20)

                    InputTextField(secure: true,
                                   heading: NSLocalizedString("Password",  comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your password", comment: "SignInView"),
                                   value: $password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    Spacer(minLength: 20)

                }
                .padding(10)

                VStack {
                    Button(action: {
                        if self.email.count > 0, self.password.count > 0 {
                            // Check if the user exists
                            let email = self.email

                            // Check different predicates at :   https://nspredicate.xyz
                            // %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.
                            
                            let predicate = NSPredicate(format: "email == %@", email)
                            
                            CloudKitUser.doesUserExist(email: self.email,
                                                       password: self.password) { (result) in
                                if result == false {
                                    self.message = NSLocalizedString("Unknown email or password:", comment: "SignInView")
//                                    self.message = message + " '\(self.email)'"
                                    self.show.toggle()
                                } else {
                                    CloudKitUser.fetchUser(predicate: predicate) { (result) in
                                        switch result {
                                        case .success(let userItem):
                                            self.userElements.user.append(userItem)
                                            self.email = userItem.email
                                            self.password = userItem.password
                                            self.name = userItem.name
                                            if userItem.image != nil {
                                                self.image = userItem.image!
                                            } 
//                                            let message = NSLocalizedString("Fetched user:", comment: "SignInView")
//                                            self.message = message + " '\(self.name)'"
                                        case .failure(let err):
                                            self.message = err.localizedDescription
                                        }
                                    }
                                }
                        }
                            // self.show.toggle()
                        }
                        else {
                            self.message = NSLocalizedString("Both eMail and Password must have a value", comment: "SignInView")
                            self.show.toggle()
                        }
                        
                    }) {
                        Text("Sign In")
                            .padding(10)
                    }
                }
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
        .modifier(DismissingKeyboard())
     }
}

/// Dismiss the keyboard
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}
