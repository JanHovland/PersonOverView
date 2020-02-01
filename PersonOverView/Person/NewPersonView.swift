//
//  NewPersonView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 01/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct NewPersonView: View {

    @Environment(\.presentationMode) var presentationMode




    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .navigationBarTitle("New person")
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

