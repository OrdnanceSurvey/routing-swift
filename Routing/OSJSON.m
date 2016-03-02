//
//  OSJSONParser.m
//  Routing
//
//  Created by Dave Hardiman on 02/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSJSON.h"

@interface OSJSON ()
@property (nonatomic, strong) NSDictionary *root;
@end

@implementation OSJSON

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        _root = dictionary;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data initialKeyPath:(NSString *)initialKeyPath {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self initWithDictionary:[json valueForKeyPath:initialKeyPath]];
}

- (NSString *)stringValueForKey:(NSString *)key {
    return [self.root objectForKey:key];
}

- (double)doubleValueForKey:(NSString *)key {
    return [[self.root objectForKey:key] doubleValue];
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    return [self.root objectForKey:key];
}

- (OSJSON *)jsonForKey:(NSString *)key {
    NSDictionary *dict = [self.root objectForKey:key];
    return dict ? [[OSJSON alloc] initWithDictionary:dict] : nil;
}

@end
