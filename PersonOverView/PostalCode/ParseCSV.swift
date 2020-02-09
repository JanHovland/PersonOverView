//
//  ParseCSV.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

/// postNummer    postSted    kommuneNummer    kommuneNavn    kategori

/// https://www.icloud.com/iclouddrive/0l_T8HqrwFmvfrXDGYX593SbA#Postnummerregister-ansi
/// Postnummerregister-ansi.txt
/// delimiter: "\t"

func parseCSV (contentsOfURL: URL,
               encoding: String.Encoding,
               delimiter: String) -> [(PostalCode)]? {

    /// Hvis denne feilmeldingen kommer : Swift Error: Struct 'XX' must be completely initialized before a member is stored to
    /// endre til : var postalCode: PostalCode! = PostalCode()

    var postalCode: PostalCode! = PostalCode()
    var postalCodes: [(PostalCode)]?

        do {
            let content = try String(contentsOf: contentsOfURL,
                                     encoding: encoding)
            postalCodes = []
            let lines: [String] = content.components(separatedBy: .newlines)
            for line in lines {
                var values:[String] = []
                if line != "" {
                    values = line.components(separatedBy: delimiter)
                    postalCode.postalCode = values[0]
                    postalCode.postalName = values[1]
                    postalCode.municipalityNumber = values[2]
                    postalCode.municipalityName = values[3]
                    postalCode.categori = values[4]
                    postalCodes?.append(postalCode)
                }
            }
        } catch {
            print(error)
        }
        return postalCodes
}

func preloadData() {

    /// Dette virker ikke
    ///  //let contentsOfURL = "https://www.icloud.com/iclouddrive/0EuNE7zTUHyLcnlb47t32s19g#Postnummerregister-ansi"
    ///
    ///  guard let contentsOfURL = URL(string: "https://www.icloud.com/iclouddrive/0EuNE7zTUHyLcnlb47t32s19g#Postnummerregister-ansi.txt") else {
    ///      return
    ///  }

    /// Ved å legge csv filen i prosjektet virker dekodingen
    guard let contentsOfURL = Bundle.main.url(forResource: "Postnummerregister-ansi", withExtension: "txt")
        else {
            return
    }

    /// Må bruke encoding == ascii (utf8 virker ikke)
    if let postalCodes = parseCSV (contentsOfURL: contentsOfURL,
                             encoding: String.Encoding.ascii,
                             delimiter: "\t") {
        for postalCode in postalCodes {
            print(postalCode.postalCode + " " + postalCode.postalName + " " + postalCode.municipalityNumber + " " + postalCode.municipalityName)
        }
    }
}

