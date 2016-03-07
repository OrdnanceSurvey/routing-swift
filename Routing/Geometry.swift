//
//  Geometry.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import CoreLocation

/**
 *  Class representing a point
 */
@objc(OSPoint)
public class Point: NSObject {
    public let x: Double
    public let y: Double

    public var coordinateValue: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(os_point: self)
    }

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
        super.init()
    }

    public convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(x: coordinate.latitude, y: coordinate.longitude)
    }
}

extension CLLocationCoordinate2D {
    public init(os_point: Point) {
        self.init(latitude: os_point.x, longitude: os_point.y)
    }
}

/**
 *  Class representing a bounding box
 */
@objc(OSBoundingBox)
public class BoundingBox: NSObject {
    public let bottomLeft: Point
    public let topRight: Point

    init(bottomLeft: Point, topRight: Point) {
        self.bottomLeft = bottomLeft
        self.topRight = topRight
        super.init()
    }
}

extension Point {
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let otherObject = object as? Point else {
            return false
        }
        return self == otherObject
    }
}

extension BoundingBox {
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let otherObject = object as? BoundingBox else {
            return false
        }
        return self == otherObject
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return fabs(lhs.x.distanceTo(rhs.x)) <= DBL_EPSILON
        && fabs(lhs.y.distanceTo(rhs.y)) <= DBL_EPSILON
}

func ==(lhs: BoundingBox, rhs: BoundingBox) -> Bool {
    return lhs.bottomLeft == rhs.bottomLeft && lhs.topRight == rhs.topRight
}
