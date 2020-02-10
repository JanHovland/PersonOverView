//
//  AlertID.swift
//  PersonOverView
//
//  Created by Jan Hovland on 20/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct AlertID: Identifiable {
    enum Choice {
        case first, second, third
    }

    var id: Choice
}

