//
//  PostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

//struct PostalCode: Identifiable {
//   var id = UUID()
//   var recordID: CKRecord.ID?
//   var postalCode: String = ""
//   var postalName: String = ""
//   var municipalityNumber: String = ""
//   var municipalityName: String = ""
//   var categori: String = ""
//}

struct PostalCode {
    var postalCode: String
    var postalName: String
    var municipalityNumber: String
    var municipalityName: String
    var categori: String

    init(postalCode: String,
         postalName: String,
         municipalityNumber: String,
         municipalityName: String,
         categori: String) {

        self.postalCode = postalCode
        self.postalName = postalName
        self.municipalityNumber = municipalityNumber
        self.municipalityName = municipalityName
        self.categori = categori
    }

    init() {
        self.init(postalCode: "",
                  postalName: "",
                  municipalityNumber: "",
                  municipalityName: "",
                  categori: "")
    }
}
