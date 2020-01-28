//
//  PersonElements.swift
//  PersonOverView
//
//  Created by Jan Hovland on 27/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

class PersonElements: ObservableObject {
    @Published var persons: [PersonElement] = []
}

