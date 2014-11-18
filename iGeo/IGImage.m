//
//  IGImage.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "IGImage.h"

@implementation IGImage

- (IGImage *) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.caption = [dict valueForKeyPath:@"caption.text"];
        self.imageURL = [NSURL URLWithString:[dict valueForKeyPath:@"images.standard_resolution.url"]];
        self.imageWidth = [[dict valueForKeyPath:@"images.standard_resolution.width"] integerValue];
        self.imageHeight = [[dict valueForKeyPath:@"images.standard_resolution.height"] integerValue];
        self.user = [[IGUser alloc] initWithDictionary:dict[@"user"]];
        self.createdTime = [dict[@"created_time"] integerValue];
    }
    return self;
}

+ (NSArray *) igImagesWithArray:(NSArray *)array {
    NSMutableArray *igImages = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [igImages addObject:[[IGImage alloc] initWithDictionary:dictionary]];
    }
    return igImages;
}


@end
