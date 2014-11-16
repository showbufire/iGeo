//
//  InstagramClient.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "InstagramClient.h"
#import "Location.h"

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

- (void)searchByCoordinate:(double)latitude longtitude:(double)longtitude completion:(void (^)(NSArray *, NSError *))completion {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?lat=%lf&lng=%lf&client_id=%@", latitude, longtitude, kClientID];
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

- (void)testCall {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?lat=48.858844&lng=2.294351&client_id=%@", kClientID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);

        } else {
            NSLog(@"error %@", connectionError);
        }
    }];
}

@end
