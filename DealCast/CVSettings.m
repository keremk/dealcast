//
//  CVSettings.m
//  DealCast
//
//  Created by Kerem Karatal on 10/20/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVSettings.h"

@implementation CVSettings

+ (NSDictionary *) loadSettings {
  NSString *filePath = [[NSBundle bundleForClass: [CVSettings class]] pathForResource:@"Settings" ofType:@"plist"];
  NSData *pListData = [NSData dataWithContentsOfFile:filePath];
  NSPropertyListFormat format;
  NSString *error;
  NSDictionary *settings = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:pListData
                                                                             mutabilityOption:NSPropertyListImmutable
                                                                                       format:&format
                                                                             errorDescription:&error];
  
  return settings;
}

@end
