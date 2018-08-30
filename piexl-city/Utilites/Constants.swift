//
//  Constants.swift
//  piexl-city
//
//  Created by Faisal Babkoor on 8/24/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import Foundation
let api_key = "55a00acd6d4053c67022069cc46a9a9d"

func getFlickerURL(forApiKey key: String, withAnnotation annotation: DroppablePin) -> String{
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(api_key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&format=json&nojsoncallback=1"
   
}
