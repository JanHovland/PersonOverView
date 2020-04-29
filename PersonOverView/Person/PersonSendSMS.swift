//
//  PersonSendSMS.swift
//  PersonOverView
//
//  Created by Jan Hovland on 29/04/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

func PersonSendSMS(person: Person) {
    /// Dokumentasjon  Apple URL Scheme Reference
    /// https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899-CH1-SW1

    var greeting = ""
    /// 1: Eventuelle blanke tegn i telefonnummeret må fjernes
    /// 2: Det sendes en SMS  ved å kalle UIApplication.shared.open(url)
    let prefix = "sms://"
    let phoneNumber = person.phoneNumber.replacingOccurrences(of: " ", with: "")
    /// Må finne regionen, fordi localization ikke virker når en streng inneholder %20 (mellorom)
    let region = NSLocale.current.regionCode?.lowercased()
    if region == "no" {
        greeting = "Gratulerer%20med%20fodselsdagen%20din%20"
    } else {
        greeting = "Happy%20birthday%20"
    }
    let message = prefix + phoneNumber + "&body=" + greeting + person.firstName + "%20" 
    if let url = URL(string:  message) {
        UIApplication.shared.open(url, options: [:])
    }
    
}
