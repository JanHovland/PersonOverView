//
//  DismissingKeyboard.swift
//  PersonOverView
//
//  Created by Jan Hovland on 15/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

/// Dismiss the keyboard
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}

