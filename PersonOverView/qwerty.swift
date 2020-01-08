//
//  qwerty.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct qwerty: View {
    @State private var vis: Bool = false

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .contextMenu {
          Button("Love it: 💕") {
            self.vis.toggle()
          }
        }
        .sheet(isPresented: $vis) {
            ToDoView()
        }
    }
}


struct qwerty_Previews: PreviewProvider {
    static var previews: some View {
        qwerty()
    }
}
