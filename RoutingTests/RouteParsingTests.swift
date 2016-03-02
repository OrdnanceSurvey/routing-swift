//
//  RouteParsingTests.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubs
@testable import Routing

class RouteParsingTests: XCTestCase {

    private func checkRoute(route: Route) {
        expect(route.crs).to(equal(CoordinateReferenceSystem.EPSG_27700))
        expect(route.distance).to(equal(980.831))
        expect(route.time).to(equal(79166))
        let topLeft = Point(x: 115047.774463, y: 437159.837797)
        let bottomRight = Point(x: 115640.012446, y: 437421.667735)
        expect(route.bbox).to(equal(BoundingBox(topLeft: topLeft, bottomRight: bottomRight)))
        expect(route.points).to(haveCount(62))
        expect(route.points.first).to(equal(Point(x: 115640.012446, y: 437165.490536)))
        expect(route.points.last).to(equal(Point(x: 115173.178376, y: 437388.106532)))
        expect(route.instructions).to(haveCount(4))
        let firstInstruction = route.instructions.first
        expect(firstInstruction?.sign).to(equal(0))
        expect(firstInstruction?.text).to(equal("Continue onto ADANAC DRIVE"))
        expect(firstInstruction?.time).to(equal(27196))
        expect(firstInstruction?.distance).to(equal(385.799))
        expect(firstInstruction?.startPoint).to(equal(0))
        expect(firstInstruction?.endPoint).to(equal(19))
        let secondInstruction = route.instructions[1]
        expect(secondInstruction.sign).to(equal(6))
        expect(secondInstruction.text).to(equal("At roundabout, take exit 3 onto ADANAC DRIVE"))
        expect(secondInstruction.time).to(equal(32653))
        expect(secondInstruction.distance).to(equal(355.701))
        expect(secondInstruction.startPoint).to(equal(19))
        expect(secondInstruction.endPoint).to(equal(42))
        expect(secondInstruction.turnAngle).to(equal(4.11))
        expect(secondInstruction.exitNumber).to(equal(3))
        let thirdInstruction = route.instructions[2]
        expect(thirdInstruction.sign).to(equal(6))
        expect(thirdInstruction.text).to(equal("At roundabout, take exit 4 onto ADANAC DRIVE"))
        expect(thirdInstruction.time).to(equal(19317))
        expect(thirdInstruction.distance).to(equal(239.331))
        expect(thirdInstruction.startPoint).to(equal(42))
        expect(thirdInstruction.endPoint).to(equal(61))
        expect(thirdInstruction.turnAngle).to(equal(0.57))
        expect(thirdInstruction.exitNumber).to(equal(4))
        expect(thirdInstruction.annotationText).to(equal("Annotation"))
        expect(thirdInstruction.annotationImportance).to(equal(7))
    }

    func testItIsPossibleToParseARoute() {
        let data = NSData(contentsOfURL: Bundle().URLForResource("canned-response", withExtension: "json")!)!
        let result = Route.parse(fromData: data, withStatus: 200)
        switch result {
        case .Success(let route):
            checkRoute(route)
        default:
            fail("Unexpected result")
        }
    }

    func testIfNoDataIsParsedASuitableErrorIsReceived() {
        let result = Route.parse(fromData: nil, withStatus: 200)
        switch result {
        case .Failure(let error as RoutingError):
            expect(error).to(equal(RoutingError.NoDataReceived))
        default:
            fail("Unexpected result")
        }
    }

    func testDodgyJSONReturnsASuitableError() {
        let result = Route.parse(fromData: "{]".dataUsingEncoding(NSUTF8StringEncoding), withStatus: 200)
        switch result {
        case .Failure(let error as RoutingError):
            expect(error).to(equal(RoutingError.FailedToParseJSON))
        default:
            fail("Unexpected result")
        }
    }
}