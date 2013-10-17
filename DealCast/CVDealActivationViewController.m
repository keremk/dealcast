//
//  CVDealActivationViewController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/15/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealActivationViewController.h"
#import "CVDealsDataController.h"
#import <UIImageView+AFNetworking.h>

@interface CVDealActivationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UITextView *dealTitle;
@property (weak, nonatomic) IBOutlet UITextView *dealDescription;
@property (weak, nonatomic) IBOutlet UISwitch *activateSwitch;
@end

@implementation CVDealActivationViewController {
  CVDealsDataController *_dealsDataController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
    [self customInit];
  }
  return self;
}

- (void) awakeFromNib {
  [self customInit];
}

- (void) customInit {
  _dealsDataController = [CVDealsDataController sharedInstance];
}

- (IBAction)activateDeal:(id)sender {
  BOOL isActive = ((UISwitch *) sender).on;
  if (isActive) {
    [_dealsDataController activateDeal:self.selectedDeal];
  } else {
    [_dealsDataController deactivateDeal: self.selectedDeal];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  NSString *imagePath = [NSString stringWithFormat:@"%@/%@", _dealsDataController.apiServerURL, self.selectedDeal.imagePath];
  NSURL *imageUrl = [NSURL URLWithString:imagePath];
  [self.dealImageView setImageWithURL:imageUrl];
  self.dealTitle.text = self.selectedDeal.title;
  self.dealDescription.text = self.selectedDeal.description;
  self.activateSwitch.on = self.selectedDeal.isActive;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
