//
//  User.swift
//  PersonOverView
//
//  Created by Jan Hovland on 09/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import Combine
import SwiftUI

class User: ObservableObject {
     @Published var name = "Ola"
     @Published var email = ""
     @Published var password = ""
}
