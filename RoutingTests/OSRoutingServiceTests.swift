//
//  OSRoutingServiceTests.swift
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
@testable import Routing

class OSRoutingServiceTests: XCTestCase {

    func testItHasABackingRoutingService() {
        let os_service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: OSRoutingService.epsg27700())
        expect(os_service.routingService.crs).to(equal(CoordinateReferenceSystem.EPSG_27700))
        expect(os_service.routingService.vehicleType).to(equal(VehicleType.Car))
        expect(os_service.routingService.apiKey).to(equal("test-key"))
    }

    func testItDefaultsTo3857() {
        let os_service = OSRoutingService(apiKey: "test-key", vehicleType: OSRoutingService.carVehicleType(), crs: nil)
        expect(os_service.routingService.crs).to(equal(CoordinateReferenceSystem.EPSG_3857))
        expect(os_service.routingService.vehicleType).to(equal(VehicleType.Car))
        expect(os_service.routingService.apiKey).to(equal("test-key"))
    }

}
