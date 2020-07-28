//
//  Account.swift
//  PersonOverView
//
//  Created by Jan Hovland on 28/07/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct Account: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var image: UIImage?
}
