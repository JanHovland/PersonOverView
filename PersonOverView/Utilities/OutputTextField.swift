//
//  OutputTextField.swift
//  PersonOverView
//
//  Created by Jan Hovland on 21/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI
import Foundation

struct OutputTextField: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var showPassword: Bool = false
    @State         var secureValue: String = ""

    var secure: Bool
    var heading: String
    @Binding var value: String

    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text(heading)
                    .padding(-4)
                    .font(Font.caption.weight(.semibold))
                    .foregroundColor(.accentColor)
                if secure {
                    if self.showPassword == false {
                        Text(secureValue)
                            .font(Font.system(size: 9, design: .default))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                    } else {
                         Text(secureValue)
                        .padding(.horizontal, 7)
                    }
                } else {
                    Text(value)
                        .padding(.horizontal, 7)
                }
            }
        }
        .onAppear {
            self.showPassword = UserDefaults.standard.bool(forKey: "showPassword")
            if self.showPassword == false {
                if self.secure {
                    self.secureValue = ""
                    if self.value.count > 0 {
                        for _ in 0..<self.value.count {
                            self.secureValue = self.secureValue + "●"
                        }
                    }
                }
            } else {
                self.secureValue = self.value
            }
        }
    }
}

