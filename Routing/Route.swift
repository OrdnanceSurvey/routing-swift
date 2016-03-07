//
//  Route.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import CoreLocation

/// Represents a parsed route returned from the routing API
@objc(OSRoute)
public final class Route: NSObject {
    /// The CRS for the route
    public let crs: CoordinateReferenceSystem
    public var crsString: String {
        return crs.rawValue
    }

    /// The distance of the route
    public let distance: Double

    /// Time taken to cover the route
    public let time: Double

    /// The instructions for the route
    public let instructions: [Instruction]

    /// The bounding box that covers the route
    public let bbox: BoundingBox

    /// The points making up the route
    public let points: [Point]

    /// The coordinates making up the route.
    /// Note, this value is nonsense if the crs for the route isn't WGS:84.
    public var coordinates: [CLLocationCoordinate2D] {
        return points.map { CLLocationCoordinate2D(os_point: $0) }
    }

    /// The coordinates making up the route, wrapped in NSValue so as to be accessible from Objective-C
    /// Note, this value is nonsense if the crs for the route isn't WGS:84.
    public var coordinateValues: [NSValue] {
        return points.map { NSValue.os_valueWithCoordinate(CLLocationCoordinate2D(os_point: $0)) }
    }

    init(crs: CoordinateReferenceSystem, distance: Double, time: Double, instructions: [Instruction], bbox: BoundingBox, points: [Point]) {
        self.crs = crs
        self.distance = distance
        self.time = time
        self.instructions = instructions
        self.bbox = bbox
        self.points = points
        super.init()
    }
}
