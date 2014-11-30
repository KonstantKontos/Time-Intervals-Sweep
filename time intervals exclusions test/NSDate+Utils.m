//
//  NSDate+Utils.m
//  firstnotice
//
//  Created by Konstantinos Kontos on 13/10/14.
//  Copyright (c) 2014 Futures primer. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+(NSNumber *)timestampFromDateStr:(NSString *)dateStr usingTimezone:(NSString *)timezoneStr {
    // e.g.: 2014-10-10 15:25:34 EEST (provided in Athens time by First Notice App server)
    // or: 2013-01-21
    
    NSString *sourceDateTemplateStr=@"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *targetTimezone=[NSTimeZone timeZoneWithName:timezoneStr];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:sourceDateTemplateStr options:0 locale:nil]];
    [dateFormatter setTimeZone:targetTimezone];
    
    NSDate *serverDate=[dateFormatter dateFromString:dateStr];
    
    return [NSNumber numberWithDouble:[serverDate timeIntervalSince1970]];
}

@end
