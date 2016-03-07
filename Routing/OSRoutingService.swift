//
//  OSRoutingService.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/**
 *  Objective-C compatible wrapper for RoutingService
 */
@objc(OSRoutingService)
public class OSRoutingService: NSObject {
    var routingService: Routable

    /**
     Initialiser

     - parameter vehicleType: The vehicle type to use
     - parameter crs:         The Coordinate Reference System to use, or nil to use the default, WGS:84
     */
    public init(apiKey: String, vehicleType: String, crs: String?) {
        guard let vehicle = VehicleType(rawValue: vehicleType) else {
            fatalError("Invalid vehicle type")
        }
        if crs == nil {
            routingService = RoutingService(apiKey: apiKey, vehicleType: vehicle)
        } else {
            guard let coordSys = CoordinateReferenceSystem(rawValue: crs!) else {
                fatalError("Invalid coordinate reference system")
            }
            routingService = RoutingService(apiKey: apiKey, vehicleType: vehicle, crs: coordSys)
        }
        super.init()
    }

    /**
     Create route between the specified points

     - parameter points:     The points to route between
     - parameter completion: The completion handler to call
     */
    public func routeBetweenPoints(points: [Point], completion: (Route?, NSError?) -> Void) {
        routingService.routeBetween(points: points) { result in
            switch result {
            case .Success(let route):
                completion(route, nil)
            case .Failure(let error as RoutingError):
                completion(nil, returnErrorFromRoutingError(error))
            case .Failure(let error):
                completion(nil, error as NSError)
            }
        }
    }

    /**
     Create route between the specified coordinates

     - parameter coordinates:  The coordinates to route between, wrapped in `NSValue` objects
     - parameter completion: The completion handler to call
     */
    public func routeBetweenCoordinates(coordinates: [NSValue], completion: (Route?, NSError?) -> Void) {
        let points = coordinates.map({ Point(coordinate: $0.os_coordinateValue()) })
        routeBetweenPoints(points, completion: completion)
    }
}

private func returnErrorFromRoutingError(error: RoutingError) -> NSError {
    let userInfo: [String: String]?
    switch error {
    case .BadRequest(let msg):
        userInfo = [NSLocalizedDescriptionKey: msg]
    case .ServerError(let msg):
        userInfo = [NSLocalizedDescriptionKey: msg]
    default:
        userInfo = nil
    }
    return NSError(domain: OSRoutingErrorDomain, code: error.rawValue(), userInfo: userInfo)
}

// MARK: - Vehicle and CRS types
public extension OSRoutingService {
    /**
     Car vehicle type
     */
    public static func carVehicleType() -> String {
        return VehicleType.Car.rawValue
    }

    /**
     Emergency vehicle type
     */
    public static func emergencyVehicleType() -> String {
        return VehicleType.EmergencyVehicle.rawValue
    }

    /**
     Foot vehicle type
     */
    public static func footVehicleType() -> String {
        return VehicleType.Foot.rawValue
    }

    /**
     Mountain Bike vehicle type
     */
    public static func mountainBikeVehicleType() -> String {
        return VehicleType.MountainBike.rawValue
    }

    /**
     WGS84 CRS
     */
    public static func wgs84CRS() -> String {
        return CoordinateReferenceSystem.WGS_84.rawValue
    }

    /**
     BNG CRS
     */
    public static func bngCRS() -> String {
        return CoordinateReferenceSystem.BNG.rawValue
    }

    /**
     EPSG:27700
     */
    public static func epsg27700() -> String {
        return CoordinateReferenceSystem.EPSG_27700.rawValue
    }

    /**
     EPSG:3857
     */
    public static func epsg3857() -> String {
        return CoordinateReferenceSystem.EPSG_3857.rawValue
    }
}
