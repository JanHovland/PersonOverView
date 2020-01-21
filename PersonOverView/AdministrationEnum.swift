//
//  AdministrationEnum.swift
//  PersonOverView
//
//  Created by Jan Hovland on 21/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

enum AdministrationEnum: Int, CaseIterable {
    case showNo = 0
    case showYes = 1

    init(type: Int) {
        switch type {
        case 0 : self = .showNo
        case 1 : self = .showYes
        default: self = .showNo
        }
    }

    var text: String {
        switch self {
        case .showNo:
            return NSLocalizedString("No", comment: "AdministrationEnum")
        case .showYes:
            return NSLocalizedString("Yes", comment: "AdministrationEnum")
        }
    }
}
