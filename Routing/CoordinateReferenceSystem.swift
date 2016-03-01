//
//  CoordinateReferenceSystem.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/**
 Available coordinate reference systems
 */
public enum CoordinateReferenceSystem: String {
    case BNG = "bng"
    case EPSG_27700 = "EPSG:27700"
    case WGS_84 = "WGS:84"
    case EPSG_4326 = "EPSG:4386"
    case EPSG_3857 = "EPSG:3857"
    case EPSG_4258 = "EPSG:4258"
}
