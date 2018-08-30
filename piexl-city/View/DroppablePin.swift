//
//  DroppablePin.swift
//  piexl-city
//
//  Created by Faisal Babkoor on 8/23/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit
class DroppablePin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    init(coordinate: CLLocationCoordinate2D, identifier: String ) {
        self.coordinate = coordinate
        self.identifier = identifier
    }

}
