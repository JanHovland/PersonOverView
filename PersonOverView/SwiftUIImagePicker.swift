//
//  SwiftUIImagePicker.swift
//  PersonOverView
//
//  Created by Jan Hovland on 18/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

struct SwiftUIImagePicker: View {

    @State var isShowingImagePicker = false
    @State var imageInBlackBox = UIImage()

    var body: some View {
        VStack {
            Image(uiImage: imageInBlackBox )
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFit()
                .border(Color.white, width: 2)
                .clipShape(Circle())

            Button(action: {
                self.isShowingImagePicker.toggle()
            }, label: {
                Text("Select Image")
                    .font(.system(size: 32))
            })
                .sheet(isPresented: $isShowingImagePicker, content: {
                    ImagePickerView(isPresented: self.$isShowingImagePicker,
                                    selectedImage: self.$imageInBlackBox)
                })

        }

    }
}

struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }

    // This is the TRICKY Part

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
               print(selectedImageFromPicker)
               self.parent.selectedImage = selectedImageFromPicker
            }
            self.parent.isPresented = false
        }
    }

    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }
}
