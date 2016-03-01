//
//  TestHelpers.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

private final class BundleHelper {}
func Bundle() -> NSBundle {
    return NSBundle(forClass: BundleHelper.self)
}