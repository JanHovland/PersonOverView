//
//  SearchBar.swift
//  PersonOverView
//
//  Created by Jan Hovland on 12/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

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
        searchBar.placeholder = NSLocalizedString("Search...", comment: "FindPostalCode")
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}


