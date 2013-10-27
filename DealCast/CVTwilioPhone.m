//
//  CVTwilioPhone.m
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVTwilioPhone.h"

@implementation CVTwilioPhone

- (id)initWithDevice:(TCDevice *) device {
  self = [super init];
  if (self) {
    _device = device;
  }
  return self;
}

-(void) connect {
  _connection = [_device connect:nil delegate:nil];
}

- (void) disconnect {
  [_connection disconnect];
}

@end
