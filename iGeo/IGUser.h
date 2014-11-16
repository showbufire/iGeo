//
//  IGUser.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGUser : NSObject

@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSURL *profileImageURL;

- (IGUser *) initWithDictionary:(NSDictionary *)dict;

@end
