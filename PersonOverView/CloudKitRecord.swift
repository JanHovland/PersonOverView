//
//  CloudKitRecord.swift
//  PersonOverView
//
//  Created by Jan Hovland on 12/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct CloudKitRecord {
    /// MARK: - saving to CloudKit
//    static func saveRecord(recordType: String, value: String, key: String) {
//        let record = CKRecord(recordType: recordType)
//        if recordType == "User" {
//            let privateDatabase = CKContainer.default().privateCloudDatabase
//            record.setValue(value, forKey: key)
//            privateDatabase.save(record) { (savedRecord, error) in
//                DispatchQueue.main.async {
//                    if error == nil {
//                        print("Record Saved")
//                    } else {
//                        print("Record Not Saved")
//                    }
//                }
//            }
//        }
//    }

    static func saveRecord(item: UserElement, recordType: String) {
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let record = CKRecord(recordType: recordType)
        if recordType == "User" {
            record["name"] = item.name as CKRecordValue
            record["email"] = item.email as CKRecordValue
            record["password"] = item.password as CKRecordValue
            if ImagePicker.shared.imageFileURL != nil {
                /// Her lagres det et komprimertbilde
                record["image"] = CKAsset(fileURL: ImagePicker.shared.imageFileURL!)
            }
            privateDatabase.save(record) { (savedRecord, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        print("Record Saved")
                    } else {
                        print("Record Not Saved")
                    }
                }
            }
        }
    }

    // MARK: - fetching from CloudKit
    static func fetchRecord() {
        var titles = [String]()
        var recordIDs = [CKRecord.ID]()
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Note", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        let operation = CKQueryOperation(query: query)
        titles.removeAll()
        recordIDs.removeAll()
        operation.recordFetchedBlock = { record in
            titles.append(record["title"]!)
            recordIDs.append(record.recordID)
            
        }
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print("Titles: \(titles)")
                print("RecordIDs: \(recordIDs)")
            }
        }
        privateDatabase.add(operation)
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

