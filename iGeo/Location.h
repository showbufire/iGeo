//
//  Location.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property NSInteger lid;
@property double latitude;
@property double longtitude;
@property NSString *name;

- (Location *) initWithDictionary:(NSDictionary *)dict;

@end
