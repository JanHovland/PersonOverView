//
//  resizedImage.swift
//  PersonOverView
//
//  Created by Jan Hovland on 15/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

/// Image Resizing Techniques
/// https://nshipster.com/image-resizing/#technique-1-drawing-to-a-uigraphicsimagerenderer
func ResizedImage(at url: URL, for size: CGSize) -> UIImage? {
    guard let image = UIImage(contentsOfFile: url.path) else {
        return nil
    }
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
}

