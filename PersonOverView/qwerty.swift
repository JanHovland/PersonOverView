//
//  qwerty.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct AlertIdentifier: Identifiable {
    enum Choice {
        case first, second
    }

    var id: Choice
}

struct qwerty: View {
    @State private var alertIdentifier: AlertIdentifier?

    var body: some View {
        VStack {
            Button("Show First Alert") {
                self.alertIdentifier = AlertIdentifier(id: .first)
            }
            .padding()
            Button("Show Second Alert") {
                self.alertIdentifier = AlertIdentifier(id: .second)
            }
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text("First Alert"),
                             message: Text("This is the first alert"))
            case .second:
                return Alert(title: Text("Second Alert"),
                             message: Text("This is the second alert"))
            }
        }
    }
}


//    @State private var item = UserElement(name: "", email: "", password: "")
//    @State private var show: Bool = false
//    @State private var message: String = ""
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var showAlert: Bool = false
//
//    @State private var showingAlert1 = false
//    @State private var showingAlert2 = false
//
//        var body: some View {
//        VStack {
//            Button("Show 1") {
//                self.showingAlert1 = true
//            }
//            .alert(isPresented: $showingAlert1) {
//                Alert(title: Text("One"), message: nil, dismissButton: .cancel())
//            }
//
//            Spacer()
//
//            Button("Show 2") {
//                self.showingAlert2 = true
//            }
//            .alert(isPresented: $showingAlert2) {
//                Alert(title: Text("Two"), message: nil, dismissButton: .cancel())
//            }
//        }
//    }
//
//}
//
//
//
//        Form {
//            Text("CloudKit")
//                .font(.largeTitle)
//                .padding()
//
//            TextField("Name", text: $item.name)
//            TextField("email", text: $item.email)
//            SecureField("Password", text: $item.password)
//
//
//
//            Button(
//                action: {
//                    /// let predicate = NSPredicate(format: "email == %@", self.item.email)
//                    let predicate = NSPredicate(value: true)
//                    let error = CloudKitRecord.findUser(predicate: predicate)
//                    if error.count == 0 {
//                        self.message = "Find OK"
//                        self.show.toggle()
//                    } else {
//                        self.message = error
//                        self.show.toggle()
//                    }
//
//                },
//                label: { Text("Test -F I N D- function for CloudKit") }
//            )
//        }
//        .alert(isPresented: $show) {
//            return Alert(title: Text(self.message))
//        }
//    }
//}
