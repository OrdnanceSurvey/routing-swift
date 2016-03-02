//
//  OSJSON.h
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSJSON : NSObject

- (instancetype)initWithData:(NSData *)data initialKeyPath:(NSString *)initialKeyPath;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *_Nullable)stringValueForKey:(NSString *)key;

- (NSInteger)integerValueForKey:(NSString *)key;

- (double)doubleValueForKey:(NSString *)key;

- (NSArray *_Nullable)arrayValueForKey:(NSString *)key;

- (OSJSON *_Nullable)jsonForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
