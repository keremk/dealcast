//
//  CVTwilioSMS.h
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVTwilioSMS : NSObject {
  NSString *_apiServerUrl;
}

- (id) initWithServerUrl:(NSString *) url;
- (void) sendSMS:(NSString *) message;

@end
