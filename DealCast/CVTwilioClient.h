//
//  CVTwilioClient.h
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVTwilioPhone.h"
#import "CVTwilioSMS.h"

@interface CVTwilioClient : NSObject

@property(nonatomic, strong) NSString *apiServerUrl;
@property(nonatomic, strong) CVTwilioPhone *twilioPhone;
@property(nonatomic, strong) CVTwilioSMS *twilioSMS;

+ (id)sharedInstance;
- (void) initiateConnectionSuccess:(void (^)(CVTwilioPhone *twilioPhone)) success
                           failure:(void (^)(NSError *error))failure;
@end
