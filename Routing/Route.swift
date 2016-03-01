//
//  Route.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/// Represents a parsed route returned from the routing API
@objc(OSRoute)
public class Route: NSObject {
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
