//
//  Route+Parsing.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Fetch

extension Route: Parsable {
    public static func parse(fromData data: NSData?, withStatus status: Int) -> Result<Route> {
        return .Failure(NSError(domain: "unimplemented", code: 1, userInfo: nil))
    }
}
