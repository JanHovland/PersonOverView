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
 O p p g a v e r :

 1. Oppgave 1

 S e n e r e (om mulig) :

 1. Kunne trykke på bildet istedet for på teksten i "SwiftUIImagePicker.swift"
 2. Oppgave 2

 F e r d i g

 Redusere meldinger i SignInView.swift
 Redusere meldinger i SignUpView.swift
 Ta bort "online keyboard"
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
