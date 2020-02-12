//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct FindPostalCode: View {

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    /// SearchBar er ikke er ikke en dekl av SWIFTUI
    struct SearchBar: UIViewRepresentable {
        @Binding var text: String
        class Coordinator: NSObject, UISearchBarDelegate {
            @Binding var text: String
            init(text: Binding<String>) {
                _text = text
            }
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                text = searchText
            }
        }
        func makeCoordinator() -> SearchBar.Coordinator {
            return Coordinator(text: $text)
        }
        func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
            let searchBar = UISearchBar(frame: .zero)
            searchBar.delegate = context.coordinator
            searchBar.placeholder = NSLocalizedString("Search for PostalCode...", comment: "FindPostalCode")
            searchBar.autocapitalizationType = .none
            return searchBar
        }
        func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
            uiView.text = text
        }
    }

    @State private var searchText: String = ""
    @State private var lookupPostalCode = NSLocalizedString("PostalCode", comment: "FindPostalCode")
    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List  {
                    // ForEach(postalCodes) {
                    ForEach(postalCodes.filter({ self.searchText.isEmpty ||
                        $0.postalName.localizedStandardContains(self.searchText) ||
                        $0.postalName.localizedStandardContains (self.searchText)    })) {
                            postalCode in
                            HStack {
                                Text(postalCode.postalNumber)
                                Text(postalCode.postalName)
                            }
                    }
                }
            }
            .navigationBarTitle(lookupPostalCode)
        }
        .onAppear {
            self.zoomPostalCode()
        }
    }

    /// Rutine for å friske opp bildet
    func zoomPostalCode() {

        /// Sletter alt tidligere innhold
        self.postalCodes.removeAll()
        /// Fetch actual postCodes from CloudKit
        
        // let predicate = NSPredicate(value: true)
        let predicate = NSPredicate(format: "postalName == %@", "BERGEN")

        CloudKitPostalCode.fetchPostalCode(predicate: predicate)  { (result) in
            switch result {
            case .success(let postalCode):
                self.postalCodes.append(postalCode)
                /// Sortering
                self.postalCodes.sort(by: {$0.postalName < $1.postalName})
                self.postalCodes.sort(by: {$0.postalNumber < $1.postalNumber})
            /// self.persons.sort(by: {$0.firstName < $1.firstName})
            case .failure(let err):
                print(err.localizedDescription)
                /// self.message = err.localizedDescription
                /// self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

}


