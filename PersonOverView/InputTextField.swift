//
//  InputTextField.swift
//  PersonOverView
//
//  Created by Jan Hovland on 16/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//
import SwiftUI

struct InputTextField: View {
    var secure: Bool
    var heading: String
    var placeHolder: String
    @Binding var value: String

    var body: some View {

        ZStack {
            VStack (alignment: .leading) {
                Text(heading)
                    .padding(-5)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                if secure {
                    SecureField(placeHolder, text: $value)
                        .padding(-7)
                        .padding(.horizontal, 15)
                } else {
                    TextField(placeHolder, text: $value)
                        .padding(-7)
                        .padding(.horizontal, 15)
                }
            }
        }
    }
}

