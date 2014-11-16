//
//  IGUser.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "IGUser.h"

@implementation IGUser

- (IGUser *) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.uid = [dict[@"id"] integerValue];
        self.username = dict[@"username"];
        self.fullname = dict[@"full_name"];
        self.profileImageURL = [NSURL URLWithString:dict[@"profile_picture"]];
    }
    return self;
}

@end
