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
Oppgaver:

1. Redusere meldinger i SignInView.swift etter "Logg inn"
2. Redusere meldinger i SignUpView.swift etter "Meld deg inn"
3. Ta bort "online keyboard" "etter "Logg inn" og "Meld deg inn"
4. Oppgave 4

Senere (om mulig):

1. Kunne trykke på bildet istedet for på teksten i "SwiftUIImagePicker.swift"
2. Oppgave 2

"""

struct ToDoView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("To be done")
                    .font(.title)
                    .padding()
                Text(toDo)
                    .font(.custom("courier", size: 15))
                    .foregroundColor(.none)
            }

        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
