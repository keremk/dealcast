//
//  CVDeal.m
//  DealCast
//
//  Created by Kerem Karatal on 10/13/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDeal.h"

@implementation CVDeal

- (id) initWithDictionary:(NSDictionary *) dict {
  self = [super init];
  if (self) {
    self.title = [dict objectForKey:@"title"];
    self.imageName = [dict objectForKey:@"image"];
    self.imagePath = [NSString stringWithFormat:@"images/%@", self.imageName];
    self.description = [dict objectForKey:@"description"];
    self.major = [dict objectForKey:@"major"];
    self.minor = [dict objectForKey:@"minor"];

    self.bluetoothPower = @-59;
    self.isActive = NO;
  }
  return self;
}

@end
