//
//  OSRoutingError.h
//  Routing
//
//  Created by Dave Hardiman on 03/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Error domain for use with this framework
 */
extern NSString *const OSRoutingErrorDomain;

NS_ENUM(NSInteger){
    /**
     *  At least 2 points are required for routing
     */
    OSRoutingErrorTooFewPoints,
    /**
     *  No data was received from the server
     */
    OSRoutingErrorNoDataReceived,
    /**
     *  Parsing the JSON response failed
     */
    OSRoutingErrorFailedToParseJSON,
    /**
     *  The bounding box received is invalid
     */
    OSRoutingErrorInvalidBoundingBox,
    /**
     *  There are no instructions in the response
     */
    OSRoutingErrorMissingInstructions,
    /**
     *  There are no coordinates in the response
     */
    OSRoutingErrorMissingCoordinates,
    /**
     *  Request is unauthorised. Check your API key is correct
     */
    OSRoutingErrorUnauthorised,
    /**
     *  Invalid request made. See the localised description for the problem
     */
    OSRoutingErrorBadRequest,
    /**
     *  Server error. See the localised description for the problem
     */
    OSRoutingErrorServerError,
    /**
     *  Unknown error occurred
     */
    OSRoutingErrorUnknown,
};
