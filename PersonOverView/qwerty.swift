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

    @State private var item = UserElement(name: "Kjelling", email: "a@b.com", password: "1234")

    var body: some View {
        VStack {
            Text("CloudKit")
                .font(.largeTitle)
                .padding()
            Button(
                action: {
                    CloudKitRecord.saveRecord(item: self.item, recordType: "User")
                },
                label: { Text("Test save function for CloudKit") }
            )
        }
    }
}
