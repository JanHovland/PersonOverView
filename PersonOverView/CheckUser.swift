//
//  CheckUser.swift
//  PersonOverView
//
//  Created by Jan Hovland on 12/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)

import SwiftUI

func CheckUser(eMail: String, password: String) -> Bool {

    if eMail != "", password != "" {
        return true
    }
    
    return false
}

