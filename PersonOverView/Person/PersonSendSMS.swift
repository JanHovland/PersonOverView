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
    print("phoneNumber = \(phoneNumber)")
    /// Må finne regionen, fordi localization ikke virker når en streng inneholder %20 (mellorom)
    let region = NSLocale.current.regionCode?.lowercased()
    if region == "no" {
        greeting = "Gratulerer%20med%20fodselsdagen%20din,%20"
    } else {
        greeting = "Happy%20birthday,%20"
    }
    let firstName1 = person.firstName.replacingOccurrences(of: " ", with: "%20")
    let firstName2 = firstName1.replacingOccurrences(of: "😀", with: "")            /// Dette på grunn av sorteringen der Å ikke kommer helt til slutt
    let firstName3 = firstName2.replacingOccurrences(of: "é", with: "e")
    let firstName4 = firstName3.replacingOccurrences(of: "æ", with: "a")
    let firstName5 = firstName4.replacingOccurrences(of: "ø", with: "o")
    let firstName6 = firstName5.replacingOccurrences(of: "å", with: "a")
    let firstName7 = firstName6.replacingOccurrences(of: "Æ", with: "A")
    let firstName8 = firstName7.replacingOccurrences(of: "Ø", with: "O")
    let firstName = firstName8.replacingOccurrences(of: "Å", with: "A")
    let message = prefix + phoneNumber + "&body=" + greeting + firstName + "%20"
    if let url = URL(string:  message) {
        UIApplication.shared.open(url, options: [:])
    }
    
}
