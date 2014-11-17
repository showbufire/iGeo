//
//  IGImageCellView.h
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGImage.h"

@interface IGImageCellView : UITableViewCell

@property (nonatomic, strong) IGImage *igImage;

- (void) updateImage:(IGImage *)igImage;

@end
