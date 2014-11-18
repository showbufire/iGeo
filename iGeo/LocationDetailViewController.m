//
//  LocationDetailViewController.m
//  iGeo
//
//  Created by Xiao Jiang on 11/16/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "IGImageCellView.h"

@interface LocationDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IGImageCellView" bundle:nil] forCellReuseIdentifier:@"IGImageCellView"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) onBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.medias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IGImageCellView *cell = [self.tableView dequeueReusableCellWithIdentifier:@"IGImageCellView"];
    [cell updateImage:self.medias[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
