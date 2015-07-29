//
//  Capital.swift
//  Project19
//
//  Created by Amar Idrizovic on 29/07/15.
//  Copyright (c) 2015 Amar Idrizovic. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
