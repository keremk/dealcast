//
//  CVDealDetailsViewController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/17/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CVTwilioClient.h"

@interface CVDealDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UITextView *dealTitle;
@property (weak, nonatomic) IBOutlet UITextView *dealDescription;
@end

@implementation CVDealDetailsViewController {
 CVDealsDataController *_dealsDataController;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
        // Custom initialization
  }
  return self;
}

- (void) awakeFromNib {
  [self customInit];
}

- (void) customInit {
  _dealsDataController = [CVDealsDataController sharedInstance];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *imagePath = [NSString stringWithFormat:@"%@/%@", _dealsDataController.apiServerURL, self.selectedDeal.imagePath];
  NSURL *imageUrl = [NSURL URLWithString:imagePath];
  [self.dealImageView setImageWithURL:imageUrl];
  self.dealTitle.text = self.selectedDeal.title;
  self.dealDescription.text = self.selectedDeal.description;

}

- (IBAction)callAssistance:(id)sender {
  CVTwilioClient *client = [CVTwilioClient sharedInstance];
  if (client.twilioPhone == nil) {
    [client initiateConnectionSuccess:^(CVTwilioPhone *twilioPhone) {
      NSLog(@"Calling the contact");
      [twilioPhone connect];
    } failure:^(NSError *error) {
      NSLog(@"Error initating connection: %@", error);
    }];
  } else {
    [client.twilioPhone connect];
  }
  NSString *message = [NSString stringWithFormat:@"Please go to the %@, customer waiting for help.", self.selectedDeal.userFriendlyLocationName];
  [client.twilioSMS sendSMS:message];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
