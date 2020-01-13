//
//  qwerty.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct qwerty: View {

    @State private var item = UserElement(name: "", email: "", password: "")
    @State private var show: Bool = false
    @State private var message: String = ""

    var body: some View {
        Form {
            Text("CloudKit")
                .font(.largeTitle)
                .padding()

            TextField("Navn", text: $item.name)
            TextField("email", text: $item.email)
            SecureField("Password", text: $item.password)



            Button(
                action: {
//                    let predicate = NSPredicate(format: "email == %@", self.item.email)
                    let predicate = NSPredicate(value: true)
                    let error = CloudKitRecord.findUser(predicate: predicate)
                    if error.count == 0 {
                        self.message = "Find OK"
                        self.show.toggle()
                    } else {
                        self.message = error
                        self.show.toggle()
                    }

                },
                label: { Text("Test -F I N D- function for CloudKit") }
            )
        }
        .alert(isPresented: $show) {
            return Alert(title: Text(self.message))
        }
    }
}
