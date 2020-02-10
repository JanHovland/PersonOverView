//
//  CloudKitPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import CloudKit
import SwiftUI

struct CloudKitPostalCode {
    struct RecordType {
        static let PostalCode = "PostalCode"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    /// MARK: - saving to CloudKit
    static func savePostalCode(item: PostalCode, completion: @escaping (Result<PostalCode, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.PostalCode)
        itemRecord["postalNumber"] = item.postalNumber as CKRecordValue
        itemRecord["postalName"] = item.postalName as CKRecordValue
        itemRecord["municipalityNumber"] = item.municipalityNumber as CKRecordValue
        itemRecord["municipalityName"] = item.municipalityName as CKRecordValue
        itemRecord["categori"] = item.categori as CKRecordValue
        CKContainer.default().privateCloudDatabase.save(itemRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                let recordID = record.recordID
                guard let postalNumber = record["postalNumber"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let postalName = record["postalName"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let municipalityNumber = record["municipalityNumber"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let municipalityName = record["municipalityName"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let categori = record["categori"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                let postalCode = PostalCode(recordID: recordID,
                                            postalNumber: postalNumber,
                                            postalName: postalName,
                                            municipalityNumber: municipalityNumber,
                                            municipalityName: municipalityName,
                                            categori: categori)

                completion(.success(postalCode))
            }
        }
    }

    // MARK: - fetching from CloudKit
    static func fetchPostalCode(predicate:  NSPredicate, completion: @escaping (Result<PostalCode, Error>) -> ()) {
        let query = CKQuery(recordType: RecordType.PostalCode, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["postalNumber",
                                 "postalName",
                                 "municipalityNumber",
                                 "municipalityName",
                                 "categori"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let postalNumber  = record["postalNumber"] as? String else { return }
                guard let postalName = record["postalName"] as? String else { return }
                guard let municipalityNumber = record["municipalityNumber"] as? String else { return }
                guard let municipalityName = record["municipalityName"] as? String else { return }
                guard let categori = record["categori"] as? String else { return }
                let postalCode = PostalCode(recordID: recordID,
                                            postalNumber: postalNumber,
                                            postalName: postalName,
                                            municipalityNumber: municipalityNumber,
                                            municipalityName: municipalityName,
                                            categori: categori)
                completion(.success(postalCode))
            }
        }
        operation.queryCompletionBlock = { ( _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
        }
        CKContainer.default().privateCloudDatabase.add(operation)
    }

     // MARK: - delete from CloudKit
     static func deletePostalCode(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
         CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
             DispatchQueue.main.async {
                 if let err = err {
                     completion(.failure(err))
                     return
                 }
                 guard let recordID = recordID else {
                     completion(.failure(CloudKitHelperError.recordIDFailure))
                     return
                 }
                 completion(.success(recordID))
             }
         }
     }

    // MARK: - delete all from CloudKit
    static func deleteAllPostalCode() {
        let privateDb =  CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "PostalCode", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        var counter = 0
        DispatchQueue.main.async {
            privateDb.perform(query, inZoneWith: nil) { (records, error) in
                if error == nil {
                    for record in records! {
                        privateDb.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                            if error == nil {
                                counter += 1
                                print(counter)
                            }
                        })
                    }
                } else {
                    print(error as Any)
                }
            }
            let message1 = NSLocalizedString("Records deleted:", comment: "SettingView")
            print(message1 + " " + "\(counter)")
        }
    }

}

