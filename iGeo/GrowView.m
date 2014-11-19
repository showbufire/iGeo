//
//  GrowView.m
//  iGeo
//
//  Created by Xiao Jiang on 11/18/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "GrowView.h"
#import "IGImageCellView.h"
#import "Common.h"

@interface GrowView() <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *medias;

@end

@implementation GrowView

- (void) setLocationName:(NSString *)locationName {
    self.locationNameLabel.text = locationName;
}

- (void) updateMedia:(NSArray *)medias {
    self.medias = medias;
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.medias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IGImageCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"IGImageCellView"];
    [cell updateImage:self.medias[indexPath.row]];
    return cell;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    UINib *nib = [UINib nibWithNibName:@"GrowView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    
    self.titleView.backgroundColor = (UIColorFromRGB(0x517fa4));
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IGImageCellView" bundle:nil] forCellReuseIdentifier:@"IGImageCellView"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:self.view];
}

@end
