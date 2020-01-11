//
//  UserElements.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI

class UserElements: ObservableObject {
    @Published var users: [UserElement] = []
}

