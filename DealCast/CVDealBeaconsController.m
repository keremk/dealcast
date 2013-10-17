//
//  CVSecondViewController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/4/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealBeaconsController.h"

@interface CVDealBeaconsController ()

@end

@implementation CVDealBeaconsController {
  CLLocationManager *_locationManager;
  CVDealsDataController *_dealsDataController;
  NSArray *_dealsInRegion;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  [self customInit];
}

- (void) customInit {
  _dealsInRegion = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self startGettingDealList];
}

- (void) startGettingDealList {
  _dealsDataController = [CVDealsDataController sharedInstance];
  
  [_dealsDataController loadDealsFromServerSuccess: ^(CVDealsDataController *sender) {
    [_dealsDataController startRangingBeacons];
  }
  failure:^(NSError *error) {
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_dealsDataController startRangingBeacons];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_dealsDataController stopRangingBeacons];
}


- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_dealsInRegion count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"AvailableDealCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
  
  CVDeal *deal = [_dealsInRegion objectAtIndex:indexPath.row];
  cell.textLabel.text = deal.title;
  cell.detailTextLabel.text = deal.description;
  return cell;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) regionHasDeals:(NSArray *) deals {
  _dealsInRegion = deals;
  [self.tableView reloadData];
}

@end
