//
//  PersonCoordinator.swift
//  PersonOverView
//
//  Created by Jan Hovland on 19/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import Foundation
import MapKit

final class Coordinator: NSObject, MKMapViewDelegate {

    var control: MapView

    init(_ control: MapView) {
        self.control = control
    }

}
