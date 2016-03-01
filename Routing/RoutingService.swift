//
//  RoutingService.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Fetch

/**
 The vehicle to use for routing. 
 Note `Foot` and `MTB` only provide routing within national parks
 */
public enum VehicleType: String {
    case Car = "car"
    case Emv = "emv"
    case Foot = "foot"
    case MountainBike = "mtb"
}

public enum RoutingError: ErrorType {
    case TooFewPoints
}

/// Class to use to fetch routing information
public class RoutingService {

    /// The API key to use
    let apiKey: String

    /// The vehicle type to use
    let vehicleType: VehicleType

    /// The CRS to use
    let crs: CoordinateReferenceSystem

    /**
     Initialiser

     - parameter apiKey:      The API key to use
     - parameter vehicleType: The vehicle type to use
     - parameter crs:         The CRS to use. Defaults to EPSG:3857
     */
    public init(apiKey: String, vehicleType: VehicleType, crs: CoordinateReferenceSystem = .EPSG_3857) {
        self.apiKey = apiKey
        self.vehicleType = vehicleType
        self.crs = crs
    }

    /**
     Provide a route between the points specified

     - parameter points:     The points to route between
     - parameter completion: The completion block to call
     */
    public func routeBetween(points points: [Point], completion: (Result<Route> -> Void)) {
        if points.count < 2 {
            completion(.Failure(RoutingError.TooFewPoints))
            return
        }
    }
}
