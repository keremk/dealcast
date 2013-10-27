//
//  CVTwilioPhone.h
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCDevice.h"
#import "TCConnection.h"

@interface CVTwilioPhone : NSObject {
  TCDevice* _device;
  TCConnection* _connection;
}

- (id)initWithDevice:(TCDevice *) device;

- (void) connect;
- (void) disconnect;

@end
