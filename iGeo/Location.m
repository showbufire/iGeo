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
        self.latitude = [dict[@"latitue"] doubleValue];
        self.longtitude = [dict[@"longtitude"] doubleValue];
        self.name = dict[@"name"];
    }
    return self;
}

@end
