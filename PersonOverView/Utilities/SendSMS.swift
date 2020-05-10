//
//  SendSMS.swift
//  PersonOverView
//
//  Created by Jan Hovland on 10/05/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

func SendSMS() -> Bool  {
    /// Dokumentasjon  Apple URL Scheme Reference
    /// https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899-CH1-SW1

    let prefix = "sms:"
    let message = prefix
    if UserDefaults.standard.string(forKey: "smsOptionSelected")! == "Aktivert" {
        if let url = URL(string:  message) {
            UIApplication.shared.open(url, options: [:])
        }
    } else {
        return false
    }
   
    return true

}

