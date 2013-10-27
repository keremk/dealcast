//
//  CVDealsDataController.m
//  DealCast
//
//  Created by Kerem Karatal on 10/15/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVDealsDataController.h"
#import "CVSettings.h"

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
    NSDictionary *settings = [CVSettings loadSettings];
    if (settings) {
      _dealDB = [NSDictionary dictionary];
      _apiServerURL = [settings valueForKey:@"apiServerURL"];
      _beaconUUID = [[NSUUID alloc] initWithUUIDString:[settings valueForKey:@"beaconUUID"]];
      _currentActiveDeal = nil;
      
      _proximityRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID
                                                            identifier:@"com.codingventures.DealCast"];
      _locationManager = [[CLLocationManager alloc] init];
      _locationManager.delegate = self;
    }
  }
  return self;
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
  [self stopAdvertising];
}

- (void) startRangingBeacons {
  [_locationManager startRangingBeaconsInRegion:_proximityRegion];

}

- (void) stopRangingBeacons {
    // Stop ranging when the view goes away.
  [_locationManager stopRangingBeaconsInRegion:_proximityRegion];
}


- (void) startAdvertising:(CVDeal *)deal{
  if (_currentActiveDeal == nil){
    return;
  }
  if (![self checkBluetoothState]) {
    return;
  }
  
  CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_beaconUUID
                                                                   major:[deal.major shortValue]
                                                                   minor:[deal.minor shortValue]
                                                              identifier:@"com.codingventures.DealCast"];
  NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:deal.bluetoothPower];
  
  [_peripheralManager startAdvertising:peripheralData];
}

- (void) stopAdvertising {
  if (![self checkBluetoothState]) {
    return;
  }
  [_peripheralManager stopAdvertising];
}

- (BOOL) checkBluetoothState {
  if (_peripheralManager == nil){
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
  }
  
  BOOL isOn = YES;
  if (_peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    isOn = NO;
  }
  return isOn;
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
  
  if ([self.delegate respondsToSelector:@selector(regionHasDeals:)] && ([nearbyDeals count] > 0)) {
    [self.delegate regionHasDeals:nearbyDeals];
  }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  NSLog(@"Error monitoring failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
  NSLog(@"Ranging beacons failed: %@", error);
}

@end
