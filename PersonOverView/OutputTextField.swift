//
//  OutputTextField.swift
//  PersonOverView
//
//  Created by Jan Hovland on 21/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

struct OutputTextField: View {
    var secure: Bool
    var heading: String
    @Binding var value: String

    var body: some View {
        
        ZStack {
            VStack (alignment: .leading) {
                Text(heading)
                    .padding(-4)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Text(value)
                    .padding(.horizontal, 7)
            }
        }
    }
}


