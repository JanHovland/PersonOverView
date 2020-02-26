//
//  PersonSendMail.swift
//  PersonOverView
//
//  Created by Jan Hovland on 26/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct PersonSendMail: View {

    var person: Person

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Send eMail to: \(person.firstName + " " + person.lastName)")
            }
            .navigationBarTitle(NSLocalizedString("Send eMail", comment: "PersonSendMail")) 
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.none)
                    })
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                    Spacer()
                }
            }
        )
    }
}
