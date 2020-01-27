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
     @Published var name = ""
     @Published var email = "a"
     @Published var password = "a"
     @Published var image: UIImage?
}
