//
//  OSRoutingError.h
//  Routing
//
//  Created by Dave Hardiman on 03/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OSRoutingErrorDomain;

NS_ENUM(NSInteger){
    OSRoutingErrorTooFewPoints,
    OSRoutingErrorNoDataReceived,
    OSRoutingErrorFailedToParseJSON,
    OSRoutingErrorInvalidBoundingBox,
    OSRoutingErrorMissingInstructions,
    OSRoutingErrorMissingCoordinates,
    OSRoutingErrorUnauthorised,
    OSRoutingErrorBadRequest,
    OSRoutingErrorServerError,
    OSRoutingErrorUnknown,
};