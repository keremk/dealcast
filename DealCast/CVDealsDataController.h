//
//  CVDealsDataController.h
//  DealCast
//
//  Created by Kerem Karatal on 10/15/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#import "CVDeal.h"

@protocol CVDealsInRegionDelegate <NSObject>
- (void) regionHasDeals:(NSArray *) deals;
@end

@interface CVDealsDataController : NSObject <CBPeripheralManagerDelegate, CLLocationManagerDelegate>
@property(nonatomic, strong) NSString *apiServerURL;
@property(nonatomic, readonly) NSArray *deals;
@property(nonatomic, strong) CVDeal *currentActiveDeal;
@property(nonatomic, strong) NSUUID *beaconUUID;
@property(nonatomic, weak) id<CVDealsInRegionDelegate> delegate;

+ (id)sharedInstance;
- (void) loadDealsFromServerSuccess:(void (^)(CVDealsDataController *dealsController)) success
                            failure:(void (^)(NSError *error))failure;
- (void) activateDeal:(CVDeal *) deal;
- (void) deactivateDeal:(CVDeal *) deal;
- (void) startRangingBeacons;
- (void) stopRangingBeacons;

@end
