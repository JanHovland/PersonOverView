//
//  ToDoView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 30/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

var toDo =
"""
 E n d r i n g e r :

 1. Redusere meldinger i SignUpView.swift
 2. Flytte feltene opp slik at online keyboard ikke skjuler aktuelt felt
 3. Dersom det ligger et bilde og en logger inn en bruker uten bilde blir det gamle bildet liggende.
 4. Redusere størrelsen på det bildet som blir lagret på CloudKit.
    Nå benyttes CKAsset(url) hvor url'en peker til bilde i full størrelse

 S e n e r e (om mulig) :

 1. Kunne trykke på bildet istedet for på teksten i "SwiftUIImagePicker.swift"
 2. Oppgave 2

 F e r d i g :

 1. Redusere meldinger i SignInView.swift
 3. Ta bort "online keyboard"
    ... Lagt inn .modifier(DismissingKeyboard())

"""

struct ToDoView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("To be done")
                    .font(.title)
                    .padding()
                Text(toDo)
                    .font(.custom("courier", size: 16))
                    .foregroundColor(.none)
                    .multilineTextAlignment(.leading)
            }

        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}

/// Image Resizing Techniques
/// https://nshipster.com/image-resizing/#technique-1-drawing-to-a-uigraphicsimagerenderer
func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
    guard let image = UIImage(contentsOfFile: url.path) else {
        return nil
    }

    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
}

