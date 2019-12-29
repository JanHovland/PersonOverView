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

// MARK: - Global variable must be altered !!!
var fileURL: URL? = nil

struct SwiftUIImagePicker: View {

    @State private var showingImagePicker = false
    @State private var image: Image? = nil
    @State private var imageFileURL: URL? = nil

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
                image?
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
        }.onReceive(ImagePicker.shared.$imageFileURL) { imageFileURL in
            self.imageFileURL = imageFileURL
            if imageFileURL != nil {
                print(imageFileURL! as Any)

                // MARK: - Global variable must be altered
                fileURL = imageFileURL!
            }
        }
    }
}
