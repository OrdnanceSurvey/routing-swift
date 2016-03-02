//
//  OSJSON.h
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Objective-C interface for parsing JSON in Swift.
 Intention here is to minimise the amount of `guard`s and
 casting required to handle JSON in Swift without the need
 for a 3rd Party framework. Not intended to be used as part
 of the public API for framework.
 */
@interface OSJSON : NSObject

/**
 *  Initialiser
 *
 *  @param data           The data to parse
 *  @param initialKeyPath The key path to use for the root object
 */
- (instancetype)initWithData:(NSData *)data initialKeyPath:(NSString *)initialKeyPath;
/**
 *  Initialiser
 *
 *  @param dictionary The dictionary to use for the root object
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Get a string from the root dictionary
 *
 *  @param key The key for the string
 */
- (NSString *_Nullable)stringValueForKey:(NSString *)key;

/**
 *  Get an integer value from the root dictionary
 *
 *  @param key The key for the value
 */
- (NSInteger)integerValueForKey:(NSString *)key;

/**
 *  Get a double value from the root dictionary
 *
 *  @param key The key for the value
 */
- (double)doubleValueForKey:(NSString *)key;

/**
 *  Get an array from the root dictionary
 *
 *  @param key The key for the value
 */
- (NSArray *_Nullable)arrayValueForKey:(NSString *)key;

/**
 *  Get a child dictionary as an `OSJSON` object from the root dictionary
 *
 *  @param key The key for the value
 */
- (OSJSON *_Nullable)jsonForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
