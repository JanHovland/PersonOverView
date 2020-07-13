//
//  CloudKitUser.swift
//  SwiftUICloudKit.swift
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//


//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import CloudKit
import SwiftUI

struct CloudKitUser {
    struct RecordType {
        static let User = "User"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    /// MARK: - saving to CloudKit
    static func saveUser(item: UserElement, completion: @escaping (Result<UserElement, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.User)
        itemRecord["name"] = item.name as CKRecordValue
        itemRecord["email"] = item.email as CKRecordValue
        itemRecord["password"] = item.password as CKRecordValue
        if ImagePicker.shared.imageFileURL != nil {
            itemRecord["image"] = CKAsset(fileURL: ImagePicker.shared.imageFileURL!)
        }
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
                guard let name = record["name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let email = record["email"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let password = record["password"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                /// MARK: - "image" kan være nil, dersom det ikke er valgt noe bilde
                /// guard (record["image"] as? CKAsset) != nil else {
                ///     completion(.failure(CloudKitHelperError.castFailure))
                ///     return
                /// }
                let userElement = UserElement(recordID: recordID,
                                              name: name,
                                              email: email,
                                              password: password)
                completion(.success(userElement))
            }
        }
    }

    // MARK: - check if the user record exists
    static func doesUserExist(email: String,
                              password: String,
                              completion: @escaping (String) -> ()) {
        var result = "OK"
        let predicate = NSPredicate(format: "email == %@ AND password = %@", email, password)
        let query = CKQuery(recordType: RecordType.User, predicate: predicate)
        DispatchQueue.main.async {
             /// inZoneWith: nil : Specify nil to search the default zone of the database.
             CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, er) in
                DispatchQueue.main.async {
                    if results != nil {
                        if results!.count >= 1 {
                            result = "OK"
                        }
                    } else {
                        let description = "\(String(describing: er))"
                        result = NSLocalizedString(description, comment: "CloudKitUser")
                    }
                    completion(result)
                }
            })
        }
    }

    // MARK: - fetching from CloudKit
    static func fetchUser(predicate:  NSPredicate, completion: @escaping (Result<UserElement, Error>) -> ()) {
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.User, predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name","email","password","image"]
        operation.resultsLimit = 1
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let email = record["email"] as? String else { return }
                guard let password = record["password"] as? String else { return }

                if let image = record["image"], let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        let userElement = UserElement(recordID: recordID,
                                                      name: name,
                                                      email: email,
                                                      password: password,
                                                      image: image)
                        completion(.success(userElement))
                    }
                }
                else {
                    let userElement = UserElement(recordID: recordID,
                                                  name: name,
                                                  email: email,
                                                  password: password,
                                                  image: nil)
                    completion(.success(userElement))
                }
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
    static func deleteUser(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
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
    
    // MARK: - modify in CloudKit
    static func modifyUser(item: UserElement, completion: @escaping (Result<UserElement, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            record["name"] = item.name as CKRecordValue
            record["email"] = item.email as CKRecordValue
            record["password"] = item.password as CKRecordValue
            if ImagePicker.shared.imageFileURL != nil {
                /// Her lagres det et komprimertbilde
                record["image"] = CKAsset(fileURL: ImagePicker.shared.imageFileURL!)
            }

            CKContainer.default().privateCloudDatabase.save(record) { (record, err) in
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
                    guard let name = record["name"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let email = record["email"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let password = record["password"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    let userElement = UserElement(recordID: recordID,
                                                  name: name,
                                                  email: email,
                                                  password: password)

                    completion(.success(userElement))
                }
            }
        }
    }
}
