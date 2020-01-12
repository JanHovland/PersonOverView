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
    var body: some View {
        VStack {
            Text("CloudKit")
                .font(.largeTitle)
                .padding()
            Button(
                action: {
                    CloudKitRecord.saveRecord(recordType: "User",
                                              value: "Kristian",
                                              key: "name")
            },
                label: { Text("Test save function for CloudKit") }
            )
        }
    }
}
