//
//  PostalCodeView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 08/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct PostalCodeView: View {
    var body: some View {
        Button(action: {
            /// Rutine for å friske opp personoversikten
            preloadData()
        }, label: {
            Text("Read from CSV file")
                .foregroundColor(.none)
        })
    }
}

struct PostalCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PostalCodeView()
    }
}
