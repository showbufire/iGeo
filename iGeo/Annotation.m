//
//  Annotation.m
//  iGeo
//
//  Created by Sumeet Ungratwar on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate, title, subtitle, location;

+ (Annotation *)initWithDictionary:(NSDictionary *)dictionary {
    Annotation *annotation = [[Annotation alloc] init];
    return annotation;
}

@end