//
//  Location.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic) NSInteger lid;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic, strong) NSString *name;

- (Location *) initWithDictionary:(NSDictionary *)dict;

+ (NSArray *) locationsWithArray:(NSArray *)array;

@end
