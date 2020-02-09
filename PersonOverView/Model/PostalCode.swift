//
//  PostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct PostalCode: Identifiable {
   var id = UUID()
   var recordID: CKRecord.ID?
   var postalCode: String = ""
   var postalName: String = ""
   var municipalityNumber: String = ""
   var municipalityName: String = ""
   var categori: String = ""
}
