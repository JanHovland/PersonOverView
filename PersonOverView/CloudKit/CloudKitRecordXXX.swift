//
//  CloudKitRecordXXX.swift
//  PersonOverView
//
//  Created by Jan Hovland on 12/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct CloudKitRecordXXXX {

    static func saveUser(item: UserElement) -> String {
        var error = ""
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let record = CKRecord(recordType: "User")
        record["name"] = item.name as CKRecordValue
        record["email"] = item.email as CKRecordValue
        record["password"] = item.password as CKRecordValue
        if ImagePicker.shared.imageFileURL != nil {
            record["image"] = CKAsset(fileURL: ImagePicker.shared.imageFileURL!)
        }
        privateDatabase.save(record) { (cursor,  err) in
            DispatchQueue.main.async {
                if err != nil {
                    error = err!.localizedDescription
                }
            }
        }
        return error
    }

    // MARK: - find user(s) from CloudKit
    static func findUser(predicate:  NSPredicate) -> String {
        var error = ""
        let privateDatabase = CKContainer.default().privateCloudDatabase

        var email = [String]()
        var recordIDs = [CKRecord.ID]()

        let query = CKQuery(recordType: "User", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name","email","password","image"]
        operation.resultsLimit = 10
        email.removeAll()
        recordIDs.removeAll()

        operation.recordFetchedBlock = { record in
            email.append(record["email"]!)
            recordIDs.append(record.recordID)
            
        }
        operation.queryCompletionBlock = { cursor, err in
            DispatchQueue.main.async {
                if err != nil {
                    error = err!.localizedDescription
                }
                print("email: \(email)")
                print("RecordIDs: \(recordIDs)")
            }
        }
        privateDatabase.add(operation)

        return error
    }
    
    // MARK: - update from CloudKit
    static func updateRecord() {
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let recordIDs = [CKRecord.ID]()
        let newTitle = "Anything But The Old Title"
        let recordID = recordIDs.first!
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            if error == nil {
                record?.setValue(newTitle, forKey: "title")
                privateDatabase.save(record!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("Record Saved")
                    } else {
                        print("Record Not Saved")
                    }
                })
            } else {
                print("Could not fetch record")
            }
        }
    }
    
    // MARK: - fetching from CloudKit
    static func deleteRecord() {
        let recordIDs = [CKRecord.ID]()
        let recordID = recordIDs.first!
        let privateDatabase = CKContainer.default().privateCloudDatabase
        privateDatabase.delete(withRecordID: recordID) { (deletedRecordID, error) in
            if error == nil {
                print("Record Deleted")
            } else {
                print("Record Not Deleted")
            }
        }
    }
}

