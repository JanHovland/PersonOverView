//
//  PersonMapView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 19/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

// Integrating Maps with SwiftUI
// SwiftUI - Maps Integration and Find Nearby Places
// azamsharp

import Foundation
import SwiftUI
import MapKit

struct PersonMapView: View {

//    var locationOnMap: String = "Uelandsgata 2 4360 Varhaug"
//    var address: String = "Uelandsgata 2"
//    var subtitle: String = "4360 Varhaug"

    var locationOnMap: String = "Sentrumsvegen 17 3539 Flå"
    var address: String = "Sentrumsvegen 17"
    var subtitle: String = "3539 Flå"

    var body: some View {
        /// Compilerer OK men under kjøring kommer denne feilmeldingen:
        /// Use of unresolved identifier 'MapView' når MapView ligger i MapView.swift
        /// OK når struct MapView ligger lokalt
        MapView(locationOnMap: locationOnMap,
                address: address,
                subtitle: subtitle)
    }
}

//struct MapView: UIViewRepresentable {
//
//    var locationOnMap: String
//    var address: String
//    var subtitle: String
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        /// Convert address to coordinate and annotate it on map
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(locationOnMap, completionHandler: { placemarks, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if let placemarks = placemarks {
//                /// Get the first placemark
//                let placemark = placemarks[0]
//                /// placemark = Uelandsgata 2, Uelandsgata 2, 4360 Varhaug, Norge @ <+58.61729080,+5.64474960> +/- 100.00m, region CLCircularRegion (identifier:'<+58.61729080,+5.64474960> radius 70.82', center:<+58.61729080,+5.64474960>, radius:70.82m)
//                /// Add annotation
//                let annotation = MKPointAnnotation()
//                mapView.addAnnotation(annotation)
//                if let location = placemark.location {
//                    annotation.coordinate = location.coordinate
//                    annotation.title = self.address
//                    annotation.subtitle = self.subtitle
//                    /// Display the annotationn
//                    mapView.showAnnotations([annotation], animated: true)
//                    mapView.selectAnnotation(annotation, animated: true)
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
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            print(mapView.centerCoordinate)
//        }
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//            view.canShowCallout = true
//            return view
//        }
//    }
//
//}

