//
//  SwiftUIImagePicker.swift
//  PersonOverView
//
//  Created by Jan Hovland on 18/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit
import Combine

struct SwiftUIImagePicker: View {

    @State private var showingImagePicker = false
    @State private var image: UIImage? = nil
    
    @EnvironmentObject var imagePicker:  ImagePicker

    var body: some View {
        VStack {
            if image == nil {
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .overlay(Circle()
                        .stroke(Color.gray, lineWidth: 4))
                    .padding(.bottom)
            } else{
                Image(uiImage: image!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .overlay(Circle()
                        .stroke(Color.gray, lineWidth: 4))
                    .padding(.bottom)

            }

            Button("Choose Profile Image") {
                self.showingImagePicker.toggle()
            }
        }.sheet(isPresented: $showingImagePicker, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.image = image
           }
    }
}
