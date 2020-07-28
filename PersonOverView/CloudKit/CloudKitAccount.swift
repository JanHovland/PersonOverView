//
//  CloudKitAccount.swift
//  PersonOverView
//
//  Created by Jan Hovland on 28/07/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct CloudKitAccount {
    struct RecordType {
        /// Bruker "User" siden "Account" ikke er definert i CliudKit
        /// Modellen for "Account" er definert lik "User"
        static let account = "User"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    // MARK: - fetching from CloudKit
    static func fetchAccount(predicate:  NSPredicate, completion: @escaping (Result<Account, Error>) -> ()) {
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.account, predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name","email","password","image"]
        operation.resultsLimit = 500
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let email = record["email"] as? String else { return }
                guard let password = record["password"] as? String else { return }
                
                if let image = record["image"], let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        let account = Account(recordID: recordID,
                                              name: name,
                                              email: email,
                                              password: password,
                                              image: image)
                        completion(.success(account))
                    }
                }
                else {
                    let account = Account(recordID: recordID,
                                          name: name,
                                          email: email,
                                          password: password,
                                          image: nil)
                    completion(.success(account))
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
    
}

