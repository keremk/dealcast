//
//  CVFirstViewController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/4/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealListController.h"
#import "CVDealActivationViewController.h"
#import "CVDealsDataController.h"

@interface CVDealListController ()

@end

@implementation CVDealListController {
  CVDealsDataController *_dealsDataController;
}

- (void) viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:animated];
  [self startGettingDealList];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startGettingDealList {
  _dealsDataController = [CVDealsDataController sharedInstance];

  [_dealsDataController loadDealsFromServerSuccess: ^(CVDealsDataController *sender) {
      [self.tableView reloadData];
    }
    failure:^(NSError *error) {
  
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_dealsDataController.deals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"AvailableDealCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
  
  CVDeal *deal = [_dealsDataController.deals objectAtIndex:indexPath.row];
  cell.textLabel.text = deal.title;
  cell.detailTextLabel.text = deal.description;
  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"DealActivateDetails"]) {
    
    CVDealActivationViewController *destVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    destVC.selectedDeal = [_dealsDataController.deals objectAtIndex:indexPath.row];
  }
}
@end
