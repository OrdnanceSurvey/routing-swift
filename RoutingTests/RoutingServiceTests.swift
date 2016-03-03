//
//  RoutingServiceTests.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Fetch
import Nimble
import OHHTTPStubs
import CoreLocation
@testable import Routing

class RoutingServiceTests: XCTestCase {

    var service: RoutingService!

    override func setUp() {
        super.setUp()
        service = RoutingService(apiKey: "test-key", vehicleType: .Car, crs: .EPSG_27700)
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testItReturnsAnErrorIfFewerThan2PointsIsPassed() {
        var receivedResult: Result<Route>?
        service.routeBetween(points: []) { result in
            receivedResult = result
        }
        guard let result = receivedResult else {
            fail("No result received")
            return
        }
        switch result {
        case .Failure(let error as RoutingError):
            switch error {
            case .TooFewPoints:
                break
            default:
                fail("Unexpected result")
            }
        default:
            fail("Unexpected result received")
        }
    }

    func containsQueryItems(items: [NSURLQueryItem]) -> OHHTTPStubsTestBlock {
        return { req in
            guard let url = req.URL else {
                return false
            }
            let comps = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
            guard let queryItems = comps?.queryItems else {
                return false
            }
            for item in items {
                if queryItems.filter({ $0 == item}).count == 0 {
                    return false
                }
            }
            return true
        }
    }

    func stubTest(vehicle: VehicleType = .Car, srs: CoordinateReferenceSystem = .EPSG_27700) -> OHHTTPStubsTestBlock {
        return isScheme("https") &&
            isHost("api.ordnancesurvey.co.uk") &&
            isPath("/\(vehicle == .Car ? "routing_api" : "nonvehicle_routing_api")/route") &&
            containsQueryItems([
                NSURLQueryItem(name: "apikey", value: "test-key"),
                NSURLQueryItem(name: "point", value: "437165.0,115640.0"),
                NSURLQueryItem(name: "point", value: "437387.0,115174.0"),
                NSURLQueryItem(name: "srs", value: srs.rawValue),
                NSURLQueryItem(name: "points_encoded", value: "false"),
                NSURLQueryItem(name: "vehicle", value: vehicle.rawValue)
                ])
    }

    func testItSendsTheRequestCorrectlyForVehicleRouting() {
        let expectation = expectationWithDescription("Request Received")
        stub(stubTest()) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(error: NSError(domain: "", code: 0, userInfo: nil))
        }
        service.routeBetween(points: [Point(x: 437165, y: 115640), Point(x: 437387, y: 115174)]) { result in
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
        OHHTTPStubs.removeAllStubs()
    }

    func testItSendsTheRequestCorrectlyForNonVehicleRouting() {
        service = RoutingService(apiKey: "test-key", vehicleType: .Foot, crs: .EPSG_3857)
        let expectation = expectationWithDescription("Request Received")
        stub(stubTest(.Foot, srs: .EPSG_3857)) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(error: NSError(domain: "", code: 0, userInfo: nil))
        }
        service.routeBetween(points: [Point(x: 437165, y: 115640), Point(x: 437387, y: 115174)]) { result in
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
        OHHTTPStubs.removeAllStubs()
    }


    func testItSendsTheRequestCorrectlyForLocations() {
        let stubTest = isScheme("https") &&
            isHost("api.ordnancesurvey.co.uk") &&
            isPath("/routing_api/route") &&
            containsQueryItems([
                NSURLQueryItem(name: "apikey", value: "test-key"),
                NSURLQueryItem(name: "point", value: "10.0,11.0"),
                NSURLQueryItem(name: "point", value: "20.0,21.0"),
                NSURLQueryItem(name: "srs", value: CoordinateReferenceSystem.EPSG_27700.rawValue),
                NSURLQueryItem(name: "points_encoded", value: "false"),
                NSURLQueryItem(name: "vehicle", value: VehicleType.Car.rawValue)
                ])
        let expectation = expectationWithDescription("Request Received")
        stub(stubTest) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(error: NSError(domain: "", code: 0, userInfo: nil))
        }
        service.routeBetween(locations: [CLLocationCoordinate2D(latitude: 10.0, longitude: 11.0), CLLocationCoordinate2D(latitude: 20.0, longitude: 22.0)]) { result in
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1.0, handler: nil)
        OHHTTPStubs.removeAllStubs()
    }

    func testASuccessfulResponseIsReturned() {
        service = RoutingService(apiKey: "test-key", vehicleType: .Foot, crs: .EPSG_3857)
        let expectation = expectationWithDescription("Request Received")
        stub(stubTest(.Foot, srs: .EPSG_3857)) { (request) -> OHHTTPStubsResponse in
            return fixture(Bundle().pathForResource("canned-response", ofType: "json")!, headers: nil)
        }
        var receivedRoute: Route?
        service.routeBetween(points: [Point(x: 437165, y: 115640), Point(x: 437387, y: 115174)]) { result in
            switch result {
            case .Success(let route):
                receivedRoute = route
            default:
                break
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(2.0, handler: nil)
        OHHTTPStubs.removeAllStubs()
        expect(receivedRoute).notTo(beNil())
    }
}
