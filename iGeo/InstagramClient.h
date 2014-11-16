//
//  InstagramClient.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramClient : NSObject

+ (InstagramClient *) sharedInstance;

- (void) searchLocationsByCoordinate:(double)latitude longtitude:(double)longtitude completion:(void (^)(NSArray *locations, NSError *error))completion;

- (void) recentMediaOfLocation:(NSInteger)lid completion:(void (^)(NSArray *medias, NSError *error))completion;

@end
