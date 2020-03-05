//
//  PersonElement.swift
//  PersonOverView
//
//  Created by Jan Hovland on 27/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct PersonElement: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var firstName: String = ""
    var lastName: String = ""
    var personEmail: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var cityNumber: String = ""
    var city: String = ""
    var municipalityNumber: String = ""
    var municipality: String = ""
    var dateOfBirth = Date()
    var dateMonthDay: String = ""
    var gender: Int = 0
    var image: UIImage?
}

