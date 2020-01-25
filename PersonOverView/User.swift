//
//  User.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import Combine
import SwiftUI
import CloudKit

class User: ObservableObject {
     @Published var name = ""
     @Published var email = "a"
     @Published var password = "a"
     @Published var image: UIImage?
     @Published var recordID: CKRecord.ID?
}
