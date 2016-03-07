//
//  NSValue+Coordinate.m
//  Routing
//
//  Created by Dave Hardiman on 07/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "NSValue+Coordinate.h"

@implementation NSValue (Coordinate)

+ (NSValue *)os_valueWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSValue value:&coordinate withObjCType:@encode(CLLocationCoordinate2D)];
}

- (CLLocationCoordinate2D)os_coordinateValue {
    CLLocationCoordinate2D coordinate;
    [self getValue:&coordinate];
    return coordinate;
}

@end
