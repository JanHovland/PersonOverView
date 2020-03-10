//
//  InputTextField.swift
//  PersonOverView
//
//  Created by Jan Hovland on 16/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//
import SwiftUI

struct InputTextField: View {

    @State private var showPassword: Bool = false

    var checkPhone: Bool
    var secure: Bool
    var heading: String
    var placeHolder: String
    @Binding var value: String
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text(heading)
                    .padding(-5)
                    .font(Font.caption.weight(.semibold))
                    .foregroundColor(.accentColor)
                if secure {
                    if showPassword == false {
                        SecureField(placeHolder, text: $value)
                            .padding(-7)
                            .padding(.horizontal, 15)
                    } else {
                        TextField(placeHolder, text: $value)
                            .padding(-7)
                            .padding(.horizontal, 15)
                    }
                } else {
                    if checkPhone {
                        TextField(NSLocalizedString("Enter your phone number", comment: "NewPersonView"),
                                  text: $value,
                                  onEditingChanged: { _ in self.formatPhone(phone: self.value) } /// Kommer når en går inn i et felt eller forlater det
                            /// onCommit: { self.formatPhone(phone: self.value) }                                                   /// Kommer når en trykker "retur" på tastatur
                        )
                            .padding(-7)
                            .padding(.horizontal, 15)
                            .keyboardType(.phonePad)
                    } else {
                        TextField(placeHolder,
                                  text: $value
                        )
                            .padding(-7)
                            .padding(.horizontal, 15)
                    }
                }
            }
        }
        .onAppear {
            self.showPassword = UserDefaults.standard.bool(forKey: "showPassword")
        }
    }

    func formatPhone(phone: String) {
        /// Fjerne eventuelle "+47" og mellomrom
        let phone1 = phone.replacingOccurrences(of: "+47", with: "")
        let phone2 = phone1.replacingOccurrences(of: " ", with: "")
        /// Dersom lengden er 8 tegn --->  +47 123 45 6789
        if phone2.count == 8, phone2.isNumber() {
            let index2 = phone2.index(phone2.startIndex, offsetBy: 2)
            let index3 = phone2.index(phone2.startIndex, offsetBy: 3)
            let index4 = phone2.index(phone2.startIndex, offsetBy: 4)
            let index5 = phone2.index(phone2.startIndex, offsetBy: 5)
            /// phoneNumer er delklarert slik: @State private var phoneNumber: String = ""
            value = "+47 " + String(phone2[...index2]) + " " + String(phone2[index3...index4]) + " " + String(phone2[index5...])
        } else {
            value = phone
        }
    }

}

extension NSString  {
    func isNumber() -> Bool {
        let str: String = self as String
        return Int(str) != nil || Double(str) != nil
    }
}

