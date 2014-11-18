//
//  IGImageCellView.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "IGImageCellView.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>

@interface IGImageCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation IGImageCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateImage:(IGImage *)igImage {
    self.igImage = igImage;
    
    [self.userProfileImageView setImageWithURL:[self.igImage.user profileImageURL]];
    CALayer * l = [self.userProfileImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:25.0];
    
    self.usernameLabel.text = self.igImage.user.username;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.igImage.createdTime];
    self.timestampLabel.text = date.timeAgoSinceNow;

    UIImage *placeholder = [self getPlaceholderImage];
    [self.imgView setImageWithURL:self.igImage.imageURL placeholderImage:placeholder];
}

- (UIImage *)getPlaceholderImage {
    UIImage *whiteImage = [UIImage imageNamed:@"white.png"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat newWidth = MIN(self.igImage.imageWidth, screenRect.size.width);
    CGFloat newHeight = self.igImage.imageHeight / self.igImage.imageWidth * newWidth;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [whiteImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
