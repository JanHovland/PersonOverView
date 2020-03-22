//
//  MapView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 19/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

/// HackingWithSwift/SwiftUI/project14/Project14/

//struct MapView: UIViewRepresentable {
//
//    @Binding var locationOnMap: String 
//    var address: String = "Uelandsgata 2"
//    var subtitle: String = "4360 Varhaug"
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//
//        /// Convert address to coordinate and annotate it on map
//        let geoCoder = CLGeocoder()
//
//        /// locationOnMap = "Uelandsgata 2 4360 Varhaug"
//        geoCoder.geocodeAddressString(locationOnMap, completionHandler: { placemarks, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            if let placemarks = placemarks {
//                /// Get the first placemark
//                /// placemark = Uelandsgata 2, Uelandsgata 2, 4360 Varhaug, Norge @ <+58.61729080,+5.64474960> +/- 100.00m, region CLCircularRegion (identifier:'<+58.61729080,+5.64474960> radius 70.82', center:<+58.61729080,+5.64474960>, radius:70.82m)
//                let placemark = placemarks[0]
//
//                /// Add annotation
//                let annotation = MKPointAnnotation()
//                mapView.addAnnotation(annotation)
//
//                if let location = placemark.location {
//
//                    annotation.coordinate = location.coordinate
//                    annotation.title = self.address
//                    annotation.subtitle = self.subtitle
//
//                    /// Display the annotationn
//                    mapView.showAnnotations([annotation], animated: true)
//                    mapView.selectAnnotation(annotation, animated: true)
//
//                }
//            }
//
//        })
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}

