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
@testable import Routing

class RoutingServiceTests: XCTestCase {

    var service: RoutingService!

    override func setUp() {
        super.setUp()
        service = RoutingService(apiKey: "test-key", vehicleType: .Car, crs: .EPSG_27700)
    }
    
    override func tearDown() {
        service = nil
        OHHTTPStubs.removeAllStubs()
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
            expect(error).to(equal(RoutingError.TooFewPoints))
        default:
            fail("Unexpected result received")
        }
    }

}
