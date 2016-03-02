//
//  Geometry.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/**
 *  Class representing a point
 */
@objc(OSPoint)
public class Point: NSObject {
    public let x: Double
    public let y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
        super.init()
    }
}

/**
 *  Class representing a bounding box
 */
@objc(OSBoundingBox)
public class BoundingBox: NSObject {
    public let topLeft: Point
    public let bottomRight: Point

    init(topLeft: Point, bottomRight: Point) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
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
    return lhs.bottomRight == rhs.bottomRight && lhs.topLeft == rhs.topLeft
}
