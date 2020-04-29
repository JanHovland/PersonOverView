//
//  PersonSendMail.swift
//  PersonOverView
//
//  Created by Jan Hovland on 26/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

func PersonSendMail(person: Person) {
    /// Dokumentasjon  Apple URL Scheme Reference
    /// https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899-CH1-SW1
    ///
    /// Dokumentasjon:
    /// You can also include a subject field, a message, and multiple recipients in the To, Cc, and Bcc fields. (In iOS, the from attribute is ignored.) The following example shows a mailto URL that includes several different attributes:
    /// Eksempel:
    /// mailto:foo@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!
    /// cc =         bar@example.com
    /// subject = Greetings%20from%20Cupertino!
    /// body =     Wish%20you%20were%20here!
    var mailSubject = ""
    var mailBody = ""
    if person.personEmail.count > 0 {
        /// 1: Eventuelle blanke tegn i telefonnummeret må fjernes
        /// 2: Det sendes en SMS  ved å kalle UIApplication.shared.open(url)
        let prefix = "mailto:"
        /// Må finne regionen, fordi localization ikke virker når en streng inneholder %20 (mellorom)
        let region = NSLocale.current.regionCode?.lowercased()
        if region == "no" {
            mailSubject = "Gratulerer!" // %20med%20fodselsdagen%20din%20"
            mailBody = "Gratulerer%20med%20fodselsdagen%20din,%20"
        } else {
            mailSubject = "Gratulerer!" // %20med%20fodselsdagen%20din%20"
            mailBody = "Happy%20birthday,%20"
        }
        let to = person.personEmail.replacingOccurrences(of: " ", with: "")
        let message = prefix + to + "?" + "&subject=" + mailSubject + "&body=" + mailBody + person.firstName + "%20"
        if let url = URL(string:  message) {
            UIApplication.shared.open(url, options: [:])
        }
    }

}

