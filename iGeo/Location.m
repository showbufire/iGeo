//
//  Location.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "Location.h"

@implementation Location

- (Location *) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.lid = [dict[@"id"] integerValue];
        self.latitude = [dict[@"latitude"] doubleValue];
        self.longtitude = [dict[@"longitude"] doubleValue];
        self.name = dict[@"name"];
    }
    return self;
}

+ (NSArray *) locationsWithArray:(NSArray *)array {
    NSMutableArray *locations = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [locations addObject:[[Location alloc] initWithDictionary:dictionary]];
    }
    return locations;
}

@end
