//
//  SignInView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI
import Combine

struct SignInView : View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var image = UIImage()
    @State private var userItem = UserElement(name: "", email: "", password: "")
    @State private var showUserMaintenanceView: Bool = false

    @EnvironmentObject var userElements: UserElements

    var body: some View {
        ScrollView  {
            VStack {
                Spacer(minLength: 20)
                HStack {
                    Text("Sign in CloudKit")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .contextMenu {
                            HStack {
                                Button(action: {
                                    self.showUserMaintenanceView.toggle()
                                }, label: {
                                    Image(systemName: "pencil.and.ellipsis.rectangle")
                                    Text("User maintenance")
                                })
                            }
                        }
                    .sheet(isPresented: $showUserMaintenanceView) {
                        UserMaintenanceView()
                    }

                }

                Spacer(minLength: 20)
                /// Nå vises kun bildet fra CloudKit
                /// Er det ikke noe bilde fra CloudKit blankes det forrige bildet
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    //.aspectRatio(contentMode: .fill)
                    .font(Font.title.weight(.ultraLight))
                    .clipShape(Circle())
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
                            let email = self.email
                            /// Check different predicates at :   https://nspredicate.xyz
                            /// %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.
                            let predicate = NSPredicate(format: "email == %@", email)
                            CloudKitUser.doesUserExist(email: self.email,
                                                       password: self.password) { (result) in
                                                        if result == false {
                                                            self.message = NSLocalizedString("Unknown email or password:", comment: "SignInView")
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
                                                                case .failure(let err):
                                                                    self.message = err.localizedDescription
                                                                }
                                                            }
                                                        }
                            }
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
        .modifier(AdaptsToSoftwareKeyboard())
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


//struct MenuInfo: View {
//    var showUserMaintenanceView
//    var body: some View {
//        HStack {
//            Button(action: {
//                self.showUserMaintenanceView.toggle()
//            }, label: {
//                Image(systemName: "pencil.and.ellipsis.rectangle")
//                Text("User maintenance")
//            })
//        }
//    }
//}
