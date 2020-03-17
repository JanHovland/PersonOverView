//
//  MonthDay.swift
//  PersonOverView
//
//  Created by Jan Hovland on 05/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

/// Denne funksjonen tar en Date og returnerer en string med format MMMMdd f.eks 5. mars = 0305
/// - Parameter date: <#date description#>
/// - Returns: <#description#>
func MonthDay(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMMdd"
    let month = Calendar.current.component(.month, from: date)
    let day = Calendar.current.component(.day, from: date)
    return String(format: "%02d", month) + String(format: "%02d", day)
}

