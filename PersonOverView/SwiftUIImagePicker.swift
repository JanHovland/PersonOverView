//
//  SwiftUIImagePicker.swift
//  PersonOverView
//
//  Created by Jan Hovland on 18/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct SwiftUIImagePicker: View {

    @State var isShowingImagePicker = false
    @State var imageInBlackBox = UIImage()

    @EnvironmentObject var userElements: UserElements

    var body: some View {
        VStack {
            Image(uiImage: imageInBlackBox )
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFit()
                // .border(Color.white, width: 1)
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

    @EnvironmentObject var userElements: UserElements


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

                // let imageAsset = CKAsset(fileURL: imageFileURL!)  //                         (fileURL: imageFileURL)

               // print(imageAsset)
               print("q")



//                let documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//
//                let imageData:Data = selectedImageFromPicker.pngData()!
//                let path:String = documentsDirectoryPath.appendingPathComponent("CloudKit")
//
//                let imageURL = URL(fileURLWithPath: path)
//
//                print("q")



            }
            self.parent.isPresented = false
        }
    }

    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }
}

func saveImage(_ image: UIImage?) {

    let documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    var imageURL: URL!
    let tempImageName = "Image2.jpg"


    // Create a CKRecord
    let newRecord:CKRecord = CKRecord(recordType: "<INSERT_RECORD_NAME")

    if let image = image {

        let imageData:Data = image.jpegData(compressionQuality: 1.0)!
        let path:String = documentsDirectoryPath.appendingPathComponent(tempImageName)
        try? image.jpegData(compressionQuality: 1.0)!.write(to: URL(fileURLWithPath: path), options: [.atomic])
        imageURL = URL(fileURLWithPath: path)
        try? imageData.write(to: imageURL, options: [.atomic])

        let File:CKAsset?  = CKAsset(fileURL: URL(fileURLWithPath: path))
        newRecord.setObject(File, forKey: "<INSERT_RECORD_ASSET_FIELD_NAME")
    }

    /*
    if let database = publicDatabase {

        database.save(newRecord, completionHandler: { (record:CKRecord?, error:Error?) in

            // Check if there was an error
            if error != nil {
                NSLog((error?.localizedDescription)!)
            }
            else if let record = record {

                // Do whatever you want with the record, but image record was saved, asset should be saved.

            }


        })


    }
    */

}

