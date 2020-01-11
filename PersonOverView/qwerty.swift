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
                    saveRecord(recordType: "User", value: "Petter",  key: "name")
            },
                label: { Text("Test function for CloudKit") }
            )

        }
    }
}

struct qwerty_Previews: PreviewProvider {
    static var previews: some View {
        qwerty()
    }
}

func saveRecord(recordType: String, value: String, key: String) {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let record = CKRecord(recordType: recordType)
    record.setValue(value, forKey: key)
    privateDatabase.save(record) { (savedRecord, error) in
        if error == nil {
            print("Record Saved")
        } else {
            print("Record Not Saved")
        }
    }

}
