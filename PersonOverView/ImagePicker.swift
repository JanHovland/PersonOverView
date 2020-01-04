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
                // MARK: - Reduce the size of the image ??





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
            let url = info[UIImagePickerController.InfoKey.imageURL] as! URL

            /// Her reduseres det valgte iage vha. func resizedImage og dette vises på "Logg inn CloudKit
            /// Men bildet vil lagres i full størrelse fordi CKAsset knyttrd til valgt url som igjen peker til full billedstørrelse
            /// Her må det lages en endring
            let size = CGSize(width: 30, height: 30)
            let image = resizedImage(at: url, for: size)

            ImagePicker.shared.image = Image(uiImage: image!)
            /// ImagePicker.shared.imageFileURL = url

            ///obtaining saving path
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let imagePath = documentsPath?.appendingPathComponent("image.jpg")

            /// extract image from the picker and save it
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
                let imageData = image!.jpegData(compressionQuality: 1)
                try! imageData!.write(to: imagePath!)
            }

            ImagePicker.shared.imageFileURL = imagePath
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

