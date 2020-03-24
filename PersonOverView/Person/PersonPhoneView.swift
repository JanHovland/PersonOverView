//
//  PersonPhoneView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 24/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct PersonPhoneView: View {

    var phoneNumber: String

    @Environment(\.presentationMode) var presentationMode

    @State private var makePhoneCall = NSLocalizedString("Make phone call", comment: "PersonPhoneView")

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    let prefix = "tel://"
                    let phoneNumber = prefix + self.phoneNumber
                    guard let url = URL(string: phoneNumber) else { return }
                    UIApplication.shared.open(url)
                }) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.gray)
                            Text("   Call  ")
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                            Text(phoneNumber)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                        }
                        .font(.custom("Andale Mono Normal", size: 25))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 47/255, green: 50/255, blue: 57/255))
                        .cornerRadius(40)

                        .padding(.top, 20)
                        .padding(.bottom, 20)

                        HStack {
                            Text("Abort")
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                        }
                        .font(.custom("Andale Mono Normal", size: 25))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 47/255, green: 50/255, blue: 57/255))
                        .cornerRadius(40)
                    }
                }
            }
            .navigationBarTitle(Text(makePhoneCall))  
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
        })
    }
}

