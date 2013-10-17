//
//  CVDealsDataController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/15/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealsDataController.h"

#import <AFNetworking.h>

@interface CVDealsDataController ()
@end

@implementation CVDealsDataController {
  CBPeripheralManager *_peripheralManager;
  CLBeaconRegion *_proximityRegion;
  CLLocationManager *_locationManager;
  NSDictionary *_dealDB;
}
@synthesize apiServerURL = _apiServerURL;
@synthesize currentActiveDeal = _currentActiveDeal;
@synthesize beaconUUID = _beaconUUID;

+ (id)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (NSArray *)deals {
  return [_dealDB allValues];
}

- (id)init {
  self = [super init];
  if (self) {
    NSDictionary *settings = [self loadSettings];
    if (settings) {
      _dealDB = [NSDictionary dictionary];
      _apiServerURL = [settings valueForKey:@"apiServerURL"];
      _beaconUUID = [[NSUUID alloc] initWithUUIDString:[settings valueForKey:@"beaconUUID"]];
      _currentActiveDeal = nil;
      
      _proximityRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID identifier:@"com.codingventures.DealCast"];
      _locationManager = [[CLLocationManager alloc] init];
      _locationManager.delegate = self;
    }
  }
  return self;
}

- (NSDictionary *) loadSettings {
  NSString *filePath = [[NSBundle bundleForClass: [CVDealsDataController class]] pathForResource:@"Settings" ofType:@"plist"];
  NSData *pListData = [NSData dataWithContentsOfFile:filePath];
  NSPropertyListFormat format;
  NSString *error;
  NSDictionary *settings = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:pListData
                                                                             mutabilityOption:NSPropertyListImmutable
                                                                                       format:&format
                                                                             errorDescription:&error];
  
  return settings;
}

- (void) loadDealsFromServerSuccess:(void (^)(CVDealsDataController *dealsController)) success
                            failure:(void (^)(NSError *error))failure {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  NSString *endpoint = [NSString stringWithFormat:@"%@/deals", _apiServerURL];
  [manager GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    _dealDB = [self dealsFromResponseObject:responseObject];
    success(self);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    failure(error);
  }];
}

- (NSDictionary *) dealsFromResponseObject:(id) responseObject {
  NSMutableDictionary *deals = [NSMutableDictionary dictionary];
  
  for (NSDictionary *item in responseObject) {
    CVDeal *deal = [[CVDeal alloc] initWithDictionary:item];
    
    NSString *key = [NSString stringWithFormat:@"%@-%@", deal.major, deal.minor];
    [deals setObject:deal forKey:key];
  }
  return deals;
}


- (void) activateDeal:(CVDeal *) deal {
  _currentActiveDeal.isActive = NO;
  deal.isActive = YES;
  _currentActiveDeal = deal;
  [self startAdvertising:deal];
}

- (void) deactivateDeal:(CVDeal *)deal {
  _currentActiveDeal.isActive = NO;
  deal.isActive = NO;
  [_peripheralManager stopAdvertising];
}

- (void) startRangingBeacons {
  [_locationManager startRangingBeaconsInRegion:_proximityRegion];

}

- (void) stopRanginingBeacons {
    // Stop ranging when the view goes away.
  [_locationManager stopRangingBeaconsInRegion:_proximityRegion];
}


- (void) startAdvertising:(CVDeal *)deal{
  if (_currentActiveDeal == nil){
    return;
  }
  if (_peripheralManager == nil){
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
  }
  if(_peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    return;
  }
  
  CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID
                                                                   major:[deal.major shortValue]
                                                                   minor:[deal.minor shortValue]
                                                              identifier:@"com.codingventures.DealCast"];
  NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:deal.bluetoothPower];
  
  [_peripheralManager startAdvertising:peripheralData];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
  
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
  NSMutableArray *nearbyDeals = [NSMutableArray array];
  [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CLBeacon *beacon = (CLBeacon *)obj;
    NSString *key = [NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor];
    CVDeal *deal = [_dealDB objectForKey:key];
    deal.proximity = beacon.proximity;
    [nearbyDeals addObject:deal];
  }];
  
  if ([self.delegate respondsToSelector:@selector(regionHasDeals:)]) {
    [self.delegate regionHasDeals:nearbyDeals];
  }
}
@end
