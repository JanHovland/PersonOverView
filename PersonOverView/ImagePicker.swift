//
//  ImagePicker.swift
//  PersonOverView
//
//  Created by Jan Hovland on 27/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI
import Combine
import CloudKit

// YouTube: iOS 13 Swift UI Tutorial: Use UIKit Components with Swift UI

class ImagePicker: ObservableObject {

    static let shared: ImagePicker = ImagePicker()
    init() {}

    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()

    let willChange = PassthroughSubject<Image?, Never>()
    let willChangeImageFileURL = PassthroughSubject<URL?, Never>()

    @Published var image: Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }

    @Published var imageFileURL: URL? = nil {
        didSet {
            if imageFileURL != nil {
                willChangeImageFileURL.send(imageFileURL)
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
            /// Velger ut et bilde med sin url
            let urlOld = info[UIImagePickerController.InfoKey.imageURL] as! URL

            /// Redusere det valgte bildet  vha. func resizedImage() og original url
            let size = CGSize(width: 30, height: 30)
            let image = resizedImage(at: urlOld, for: size)
            ImagePicker.shared.image = Image(uiImage: image!)

            /// Lage ny url
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let url = documentsPath?.appendingPathComponent("image.jpg")

            /// Lagre det reduserte bildet med ny url
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
                /// compressionQuality : 0 == max compression 1 == ingen compression)
                let imageData = image!.jpegData(compressionQuality: 0.5)
                try! imageData!.write(to: url!)
            }

            /// Bruker nå  ny url
            ImagePicker.shared.imageFileURL = url
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

