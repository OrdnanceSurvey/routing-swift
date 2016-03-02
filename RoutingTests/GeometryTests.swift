//
//  GeometryTests.swift
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
@testable import Routing

class GeometryTests: XCTestCase {

    func testPointsCanBeEqual() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 1, y: 1)
        expect(point1).to(equal(point2))
    }

    func testPointsCanBeDifferent() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        expect(point1).notTo(equal(point2))
    }

    func testPointsArentEqualToOtherThings() {
        let point1 = Point(x: 1, y: 1)
        let randomObject = NSObject()
        expect(point1).notTo(equal(randomObject))
    }

    func testBoundingBoxesCanBeEqual() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        let bbox1 = BoundingBox(bottomLeft: point1, topRight: point2)
        let bbox2 = BoundingBox(bottomLeft: point1, topRight: point2)
        expect(bbox1).to(equal(bbox2))
    }

    func testBoundingBoxesCanBeDifferent() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        let point3 = Point(x: 3, y: 3)
        let bbox1 = BoundingBox(bottomLeft: point1, topRight: point2)
        let bbox2 = BoundingBox(bottomLeft: point2, topRight: point3)
        expect(bbox1).notTo(equal(bbox2))
    }

    func testBoundingBoxesArentEqualToOtherThings() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        let bbox1 = BoundingBox(bottomLeft: point1, topRight: point2)
        expect(bbox1).notTo(equal(point1))
    }

}
