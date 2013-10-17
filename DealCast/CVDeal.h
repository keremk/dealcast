//
//  CVDeal.h
//  DealCast
//
//  Created by Kerem Karatal on 10/13/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CVDeal : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *imagePath;
@property(nonatomic, strong) NSNumber *major;
@property(nonatomic, strong) NSNumber *minor;
@property(nonatomic, strong) NSNumber *bluetoothPower;
@property(nonatomic) BOOL isActive;
@property(nonatomic) CLProximity proximity;

- (CVDeal *) initWithDictionary:(NSDictionary *) dict;

@end
