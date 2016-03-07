//
//  NSValue+Coordinate.h
//  Routing
//
//  Created by Dave Hardiman on 07/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import Foundation;
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Wrapper for storing and retrieving coordinate values from NSValue
 */
@interface NSValue (Coordinate)

+ (NSValue *)os_valueWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D)os_coordinateValue;

@end

NS_ASSUME_NONNULL_END
