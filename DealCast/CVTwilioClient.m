//
//  CVTwilioClient.m
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVTwilioClient.h"
#import "CVSettings.h"
#import <AFNetworking.h>

@implementation CVTwilioClient

+ (id)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    NSDictionary *settings = [CVSettings loadSettings];
    if (settings) {
      _apiServerUrl = [settings valueForKey:@"apiServerURL"];
      _twilioPhone = nil;
      _twilioSMS = [[CVTwilioSMS alloc] initWithServerUrl:_apiServerUrl];
    }
  }
  return self;
}

- (void) initiateConnectionSuccess:(void (^)(CVTwilioPhone *twilioPhone)) success
                           failure:(void (^)(NSError *error))failure {

  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

  NSString *endpoint = [NSString stringWithFormat:@"%@token", _apiServerUrl];
  [manager GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    _twilioPhone = [self phoneFromTokenData:responseObject];
    success(_twilioPhone);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    failure(error);
  }];
}

- (CVTwilioPhone *) phoneFromTokenData:(id) data {
  NSString *token = [data objectForKey:@"token"];
  TCDevice *device = [[TCDevice alloc] initWithCapabilityToken:token delegate:nil];
  CVTwilioPhone *phone = [[CVTwilioPhone alloc] initWithDevice:device];
  
  return phone;
}

@end
