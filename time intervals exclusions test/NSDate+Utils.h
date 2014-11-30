//
//  NSDate+Utils.h
//  firstnotice
//
//  Created by Konstantinos Kontos on 13/10/14.
//  Copyright (c) 2014 Futures primer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

+(NSNumber *)timestampFromDateStr:(NSString *)dateStr usingTimezone:(NSString *)timezoneStr;


@end
