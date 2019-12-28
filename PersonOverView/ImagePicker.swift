//
//  ImagePicker.swift
//  PersonOverView
//
//  Created by Jan Hovland on 27/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI
import Combine

// YouTube: iOS 13 Swift UI Tutorial: Use UIKit Components with Swift UI

class ImagePicker: ObservableObject {

    static let shared: ImagePicker = ImagePicker()
    private init() {}

    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()

    let willChange = PassthroughSubject<Image?, Never>()
    let willChangeURL = PassthroughSubject<URL?, Never>()

    @Published var image: Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }

    @Published var url: URL? = nil {
        didSet {
            if url != nil {
                willChangeURL.send(url)
            }
        }
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let url = info[UIImagePickerController.InfoKey.imageURL] as! URL

            ImagePicker.shared.image = Image(uiImage: image)
            ImagePicker.shared.url = url  
            picker.dismiss(animated: true)
        }

    }
}

extension ImagePicker {
    struct View: UIViewControllerRepresentable {

        func makeCoordinator() -> Coordinator {
            return ImagePicker.shared.coordinator
        }

        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) ->
            UIImagePickerController {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = context.coordinator
                return imagePickerController

        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker.View>) {
       }

    }
}

