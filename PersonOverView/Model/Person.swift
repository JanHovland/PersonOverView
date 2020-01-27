//
//  Person.swift
//  PersonOverView
//
//  Created by Jan Hovland on 26/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

class Person: ObservableObject {
    @Published var recordID: CKRecord.ID?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var personEmail: String = ""
    @Published var address: String = ""
    @Published var phoneNumber: String = ""
    @Published var cityNumber: String = ""
    @Published var city: String = ""
    @Published var municipalityNumber: String = ""
    @Published var municipality: String = ""
    @Published var dateOfBirth = Date()
    @Published var gender = 0
    @Published var image: UIImage?
}
