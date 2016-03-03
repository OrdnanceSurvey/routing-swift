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

    func testItDefaultsTo3857() {
        let service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: nil)
        guard let routingService = service.routingService as? RoutingService else {
            fail("Wrong type of routing service")
            return
        }
        expect(routingService.crs).to(equal(CoordinateReferenceSystem.EPSG_3857))
        expect(routingService.vehicleType).to(equal(VehicleType.Car))
        expect(routingService.apiKey).to(equal("test-key"))
    }

    class MockService: RoutingServiceType {
        var points: [Point]?
        var handler: (Result<Route> -> Void)?

        required init(apiKey: String, vehicleType: VehicleType, crs: CoordinateReferenceSystem) {
        }

        func routeBetween(points points: [Point], completion: (Result<Route> -> Void)) {
            self.points = points
            self.handler = completion
        }
    }

    func createMockService() -> MockService {
        let mockService = MockService(apiKey: "test-key", vehicleType: .Car, crs: .EPSG_27700)
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

    func testANSErrorIsReturned() {
        let error = NSError(domain: "test-domain", code: 123, userInfo: nil)
        let result = Result<Route>.Failure(error)
        let mockService = createMockService()
        var receivedError: NSError?
        os_service.routeBetweenPoints(testPoints) { (route, error) in
            receivedError = error
        }
        mockService.handler?(result)
        expect(receivedError).to(equal(error))
    }

}
