//
//  MapView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 19/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {

    }
}

