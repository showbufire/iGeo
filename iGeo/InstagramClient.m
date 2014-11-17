//
//  InstagramClient.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "InstagramClient.h"
#import "Location.h"
#import "IGImage.h"

const NSString *kClientID = @"df74c8bb778b4799aceaf17d684bd30b";
const NSString *kClientSecret = @"aad6158d2bc147ecbdb5992f0050b41c";

@implementation InstagramClient

+ (InstagramClient *)sharedInstance {
    static InstagramClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[InstagramClient alloc] init];
        }
    });
    return instance;
}

- (void)searchLocationsByCoordinate:(double)latitude longtitude:(double)longtitude completion:(void (^)(NSArray *, NSError *))completion {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?lat=%lf&lng=%lf&distance=1000&client_id=%@", latitude, longtitude, kClientID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            completion(nil, connectionError);
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *locDict in dict[@"data"]) {
            Location *loc = [[Location alloc] initWithDictionary:locDict];
            [arr addObject:loc];
        }
        completion(arr, nil);
    }];
}

- (void) recentMediaOfLocation:(NSInteger)lid completion:(void (^)(NSArray *medias, NSError *error))completion {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%ld/media/recent?client_id=%@", lid, kClientID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            completion(nil, connectionError);
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *mediaDict in dict[@"data"]) {
            // only return images for now
            if ([mediaDict[@"type"]  isEqual: @"image"]) {
                IGImage *img = [[IGImage alloc] initWithDictionary:mediaDict];
                [arr addObject:img];
            }
        }
        completion(arr, nil);
    }];
}

@end
