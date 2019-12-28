//
//  UserElement.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI
import CloudKit

struct UserElement: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String
    var email: String
    var password: String
    var image: UIImage?
    var imageAsset: CKAsset?
}
