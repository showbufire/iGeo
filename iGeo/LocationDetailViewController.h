//
//  LocationDetailViewController.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationDetailViewController : UIViewController<UITableViewDataSource>

@property (nonatomic, strong) NSArray *medias;
@property (nonatomic, strong) NSString *locationName;

@end
