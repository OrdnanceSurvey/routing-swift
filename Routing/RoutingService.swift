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
 Note `Foot` and `MountainBike` only provide routing within national parks
 */
public enum VehicleType: String {
    case Car = "car"
    case EmergencyVehicle = "emv"
    case Foot = "foot"
    case MountainBike = "mtb"

    private func path() -> String {
        switch self {
        case .Car, .EmergencyVehicle:
            return "routing_api"
        case .Foot, .MountainBike:
            return "nonvehicle_routing_api"
        }
    }
}

/**
 Possible errors emitted by the service

 - TooFewPoints:        At least 2 points are required for routing
 - NoDataReceived:      No data was received from the server
 - FailedToParseJSON:   Parsing the JSON response failed
 - InvalidBoundingBox:  The bounding box received is invalid
 - MissingInstructions: There are no instructions in the response
 - MissingCoordinates:  There are no coordinates in the response
 - Unauthorised:        Request is unauthorised. Check your API key is correct
 - BadRequest:          Invalid request made. See the payload parameter for the problem
 - ServerError:         Server error. See the payload parameter for the problem
 - UnknownError:        Unknown error occurred
 */
public enum RoutingError: ErrorType {
    case TooFewPoints
    case NoDataReceived
    case FailedToParseJSON
    case InvalidBoundingBox
    case MissingInstructions
    case MissingCoordinates
    case Unauthorised
    case BadRequest(String)
    case ServerError(String)
    case UnknownError

    public func rawValue() -> Int {
        switch self {
        case .TooFewPoints:
            return OSRoutingErrorTooFewPoints
        case .NoDataReceived:
            return OSRoutingErrorNoDataReceived
        case .FailedToParseJSON:
            return OSRoutingErrorFailedToParseJSON
        case .InvalidBoundingBox:
            return OSRoutingErrorInvalidBoundingBox
        case .MissingInstructions:
            return OSRoutingErrorMissingInstructions
        case .MissingCoordinates:
            return OSRoutingErrorMissingCoordinates
        case .Unauthorised:
            return OSRoutingErrorUnauthorised
        case .BadRequest:
            return OSRoutingErrorBadRequest
        case .ServerError:
            return OSRoutingErrorServerError
        case .UnknownError:
            return OSRoutingErrorUnknown
        }
    }
}

/**
 *  Routing service type protocol
 */
public protocol Routable {

    /**
     Provide a route between the points specified

     - parameter points:     The points to route between
     - parameter completion: The completion block to call
     */
    func routeBetween(points points: [Point], completion: (Result<Route> -> Void))
}

/// Class to use to fetch routing information
public class RoutingService: Routable {

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
        let request = Request(url: urlForPoints(points))
        get(request) { (result: Result<Route>) in
            completion(result)
        }
    }

    private func urlForPoints(points: [Point]) -> NSURL {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "api.ordnancesurvey.co.uk"
        components.path = "/\(vehicleType.path())/route"
        var queryItems = [
            NSURLQueryItem(name: "apikey", value: apiKey),
            NSURLQueryItem(name: "points_encoded", value: "false"),
            NSURLQueryItem(name: "srs", value: crs.rawValue),
            NSURLQueryItem(name: "vehicle", value: vehicleType.rawValue),
        ]
        queryItems.appendContentsOf(points.map({ NSURLQueryItem(name: "point", value: "\($0.x),\($0.y)") }))
        components.queryItems = queryItems
        return components.URL!
    }
}
