//
//  User.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

class User: ObservableObject {
    @Published var recordID: CKRecord.ID?
    @Published var name = "Jan Hovland"
    @Published var email = "jan.hovland@lyse.net"
    @Published var password = "qwerty"
    @Published var image: UIImage?
}
