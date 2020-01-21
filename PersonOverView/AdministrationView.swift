//
//  AdministrationView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct AdministrationView: View {

    @EnvironmentObject var administration: Administration

    @State private var selectionPassword = AdministrationEnum.showNo

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Password", comment: "AdministrationView"))) {
                    Picker(selection: $selectionPassword,
                           label: Text(NSLocalizedString("Show password", comment: "AdministrationView"))) {
                        ForEach(AdministrationEnum.allCases, id: \.self) {
                            orderType in
                            Text(orderType.text)

                        }

                    }
                }
            }
            .navigationBarTitle(NSLocalizedString("Administration", comment: "AdministrationView"))
        }
    }
}
