//
//  CVTwilioSMS.m
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVTwilioSMS.h"
#import <AFNetworking.h>

@implementation CVTwilioSMS

- (id) initWithServerUrl:(NSString *) url{
  self = [super init];
  if (self) {
    _apiServerUrl = url;
  }
  return self;
}

- (void) sendSMS:(NSString *) message {
  NSDictionary *parameters = @{@"message": message,
                               @"to": @"" };
  NSString *endpoint = [NSString stringWithFormat:@"%@sms", _apiServerUrl];
  
  NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:endpoint parameters:parameters];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  [[NSOperationQueue mainQueue] addOperation:operation];
}

@end
