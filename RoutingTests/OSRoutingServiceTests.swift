//
//  OSRoutingServiceTests.swift
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
import Fetch
import CoreLocation
@testable import Routing

class OSRoutingServiceTests: XCTestCase {

    var os_service: OSRoutingService!

    override func setUp() {
        super.setUp()
        os_service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: OSRoutingService.epsg27700())
    }

    override func tearDown() {
        os_service = nil
        super.tearDown()
    }

    func testItHasABackingRoutingService() {
        os_service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: OSRoutingService.epsg27700())
        guard let routingService = os_service.routingService as? RoutingService else {
            fail("Wrong type of routing service")
            return
        }
        expect(routingService.crs).to(equal(CoordinateReferenceSystem.EPSG_27700))
        expect(routingService.vehicleType).to(equal(VehicleType.Car))
        expect(routingService.apiKey).to(equal("test-key"))
    }

    func testItDefaultsToWGS84() {
        let service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: nil)
        guard let routingService = service.routingService as? RoutingService else {
            fail("Wrong type of routing service")
            return
        }
        expect(routingService.crs).to(equal(CoordinateReferenceSystem.WGS_84))
        expect(routingService.vehicleType).to(equal(VehicleType.Car))
        expect(routingService.apiKey).to(equal("test-key"))
    }

    class MockService: Routable {
        var points: [Point]?
        var handler: (Result<Route> -> Void)?

        func routeBetween(points points: [Point], completion: (Result<Route> -> Void)) {
            self.points = points
            self.handler = completion
        }

        func routeBetween(coordinates coordinates: [CLLocationCoordinate2D], completion: (Result<Route> -> Void)) {
        }
    }

    func createMockService() -> MockService {
        let mockService = MockService()
        os_service.routingService = mockService
        return mockService
    }

    let testPoints = [
        Point(x: 437165, y: 115640),
        Point(x: 437387, y: 115174)
    ]

    func testTheServiceCallsItsUnderlyingService() {
        let mockService = createMockService()
        os_service.routeBetweenPoints(testPoints) { (route, error) in
        }
        expect(mockService.points).to(equal(testPoints))
        expect(mockService.handler).notTo(beNil())
    }

    func testASuccessfulResponseIsReturned() {
        let data = NSData(contentsOfURL: Bundle().URLForResource("canned-response", withExtension: "json")!)!
        let result = Route.parse(fromData: data, withStatus: 200)
        let mockService = createMockService()
        var receivedRoute: Route?
        os_service.routeBetweenPoints(testPoints) { (route, error) in
            receivedRoute = route
        }
        mockService.handler?(result)
        expect(receivedRoute).notTo(beNil())
    }

    func runErrorTest(result: Result<Route>, expectedError: NSError) {
        let mockService = createMockService()
        var receivedError: NSError?
        os_service.routeBetweenPoints(testPoints) { (route, error) in
            receivedError = error
        }
        mockService.handler?(result)
        expect(receivedError).to(equal(expectedError))
    }

    func testANSErrorIsReturned() {
        let error = NSError(domain: "test-domain", code: 123, userInfo: nil)
        let result = Result<Route>.Failure(error)
        runErrorTest(result, expectedError: error)
    }

    func testARoutingErrorWithNoMessageIsReturned() {
        let cases = [
            RoutingError.TooFewPoints,
            RoutingError.NoDataReceived,
            RoutingError.FailedToParseJSON,
            RoutingError.InvalidBoundingBox,
            RoutingError.MissingInstructions,
            RoutingError.MissingCoordinates,
            RoutingError.Unauthorised,
            RoutingError.UnknownError
        ]
        cases.forEach { error in
            let expectedError = NSError(domain: OSRoutingErrorDomain, code: error.rawValue(), userInfo: nil)
            let result = Result<Route>.Failure(error)
            runErrorTest(result, expectedError: expectedError)
        }
    }

    func testARoutingErrorWithAMessageIsReturned() {
        let cases = [
            RoutingError.BadRequest("Test Message"),
            RoutingError.ServerError("Test Message")
        ]
        cases.forEach { error in
            let expectedError = NSError(domain: OSRoutingErrorDomain, code: error.rawValue(), userInfo: [ NSLocalizedDescriptionKey: "Test Message"])
            let result = Result<Route>.Failure(error)
            runErrorTest(result, expectedError: expectedError)
        }
    }

}
