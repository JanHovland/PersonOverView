//
//  CloudKitPerson.swift
//  PersonOverView
//
//  Created by Jan Hovland on 27/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import CloudKit
import SwiftUI

struct CloudKitPerson {
    struct RecordType {
        static let Person = "Person"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    /// MARK: - saving to CloudKit
    static func savePerson(item: Person, completion: @escaping (Result<Person, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.Person)
        itemRecord["firstName"] = item.firstName as CKRecordValue
        itemRecord["lastName"] = item.lastName as CKRecordValue
        itemRecord["personEmail"] = item.personEmail as CKRecordValue
        itemRecord["address"] = item.address as CKRecordValue
        itemRecord["phoneNumber"] = item.phoneNumber as CKRecordValue
        itemRecord["cityNumber"] = item.cityNumber as CKRecordValue
        itemRecord["city"] = item.city as CKRecordValue
        itemRecord["municipalityNumber"] = item.municipalityNumber as CKRecordValue
        itemRecord["municipality"] = item.municipality as CKRecordValue
        itemRecord["dateOfBirth"] = item.dateOfBirth as CKRecordValue
        itemRecord["gender"] = item.gender as CKRecordValue
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
                guard let firstName = record["firstName"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let lastName = record["lastName"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let personEmail = record["personEmail"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let address = record["address"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let phoneNumber = record["phoneNumber"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let cityNumber = record["cityNumber"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let city = record["city"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let municipalityNumber = record["municipalityNumber"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let municipality = record["municipality"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let dateOfBirth = record["dateOfBirth"] as? Date else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let gender = record["gender"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                /// MARK: - "image" kan være nil, dersom det ikke er valgt noe bilde
                /// guard (record["image"] as? CKAsset) != nil else {
                ///     completion(.failure(CloudKitHelperError.castFailure))
                ///     return
                /// }
                let person = Person(recordID: recordID,
                                    firstName: firstName,
                                    lastName: lastName,
                                    personEmail: personEmail,
                                    address: address,
                                    phoneNumber: phoneNumber,
                                    cityNumber: cityNumber,
                                    city: city,
                                    municipalityNumber: municipalityNumber,
                                    municipality: municipality,
                                    dateOfBirth: dateOfBirth,
                                    gender: gender)

                completion(.success(person))
            }
        }
    }

    // MARK: - check if the person record exists
    static func doesPersonExist(firstName: String,
                                lastName: String,
                                completion: @escaping (Bool) -> ()) {
        var result = false
        let predicate = NSPredicate(format: "firstName == %@ AND lastName = %@", firstName, lastName)
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
        DispatchQueue.main.async {
             /// inZoneWith: nil : Specify nil to search the default zone of the database.
             CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (results, er) in
                DispatchQueue.main.async {
                    if results != nil {
                        if results!.count >= 1 {
                            result = true
                        }
                    }
                    completion(result)
                }
            })
        }
    }

    // MARK: - fetching from CloudKit
    static func fetchPerson(predicate:  NSPredicate, completion: @escaping (Result<Person, Error>) -> ()) {
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["firstName",
                                 "lastName",
                                 "personEmail",
                                 "address",
                                 "phoneNumber",
                                 "cityNumber",
                                 "city",
                                 "municipalityNumber",
                                 "municipality",
                                 "dateOfBirth",
                                 "gender",
                                 "image"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let firstName  = record["firstName"] as? String else { return }
                guard let lastName = record["lastName"] as? String else { return }
                guard let personEmail = record["personEmail"] as? String else { return }
                guard let address = record["address"] as? String else { return }
                guard let phoneNumber = record["phoneNumber"] as? String else { return }
                guard let cityNumber = record["cityNumber"] as? String else { return }
                guard let city = record["city"] as? String else { return }
                guard let municipalityNumber = record["municipalityNumber"] as? String else { return }
                guard let municipality = record["municipality"] as? String else { return }
                guard let dateOfBirth = record["dateOfBirth"] as? Date else { return }
                guard let gender = record["gender"] as? Int else { return }

                if let image = record["image"], let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        let person = Person(recordID: recordID,
                                            firstName: firstName,
                                            lastName: lastName,
                                            personEmail: personEmail,
                                            address: address,
                                            phoneNumber: phoneNumber,
                                            cityNumber: cityNumber,
                                            city: city,
                                            municipalityNumber: municipalityNumber,
                                            municipality: municipality,
                                            dateOfBirth: dateOfBirth,
                                            gender: gender,
                                            image: image)
                        completion(.success(person))
                    }
                }
                else {
                    let person = Person(recordID: recordID,
                                        firstName: firstName,
                                        lastName: lastName,
                                        personEmail: personEmail,
                                        address: address,
                                        phoneNumber: phoneNumber,
                                        cityNumber: cityNumber,
                                        city: city,
                                        municipalityNumber: municipalityNumber,
                                        municipality: municipality,
                                        dateOfBirth: dateOfBirth,
                                        gender: gender,
                                        image: nil)
                    completion(.success(person))
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
    static func deletePerson(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
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
    static func modifyPerson(item: PersonElement, completion: @escaping (Result<PersonElement, Error>) -> ()) {
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
            record["firstName"] = item.firstName as CKRecordValue
            record["lastName"] = item.lastName as CKRecordValue
            record["personEmail"] = item.personEmail as CKRecordValue
            record["address"] = item.address as CKRecordValue
            record["phoneNumber"] = item.phoneNumber as CKRecordValue
            record["cityNumber"] = item.cityNumber as CKRecordValue
            record["city"] = item.city as CKRecordValue
            record["municipalityNumber"] = item.municipalityNumber as CKRecordValue
            record["municipality"] = item.municipality as CKRecordValue
            record["dateOfBirth"] = item.dateOfBirth as CKRecordValue
            record["gender"] = item.gender as CKRecordValue
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
                    guard let firstName = record["firstName"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let lastName = record["lastName"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let personEmail = record["personEmail"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let address = record["address"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let phoneNumber = record["phoneNumber"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let cityNumber = record["cityNumber"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let city = record["city"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let municipalityNumber = record["municipalityNumber"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let municipality = record["municipality"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let dateOfBirth = record["dateOfBirth"] as? Date else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let gender = record["gender"] as? Int else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    let personElement = PersonElement(recordID: recordID,
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      personEmail: personEmail,
                                                      address: address,
                                                      phoneNumber: phoneNumber,
                                                      cityNumber: cityNumber,
                                                      city: city,
                                                      municipalityNumber: municipalityNumber,
                                                      municipality: municipality,
                                                      dateOfBirth: dateOfBirth,
                                                      gender: gender)

                    completion(.success(personElement))
                }
            }
        }
    }
}

