//
//  main.m
//
//  Created by Konstantinos Kontos on 29/11/14.
//  Copyright (c) 2014 Saturated Colors. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntervalObject.h"
#import "NSDate+Utils.h"
#import "NSMutableArray+PriorityQueue.h"

NSMutableArray* sweepQueue(NSMutableArray *queue);

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        //        NSString *timeZoneStr=@"America/Montreal";
        NSString *timeZoneStr=@"GMT";
        
        NSMutableArray *intervals=[NSMutableArray arrayWithCapacity:10];
        NSMutableArray *removals=[NSMutableArray arrayWithCapacity:10];
        
        // Sample data - Case 1
        /*
        NSArray *intervalTimeStrings=@[
                                       @"2014-11-29 09:15:00&2014-11-29 11:20:00",
                                       @"2014-11-29 13:05:00&2014-11-29 16:10:00"
                                       ];
        
        
        NSArray *removalTimeStrings=@[
                                       @"2014-11-29 08:00:00&2014-11-29 10:00:00"
                                       ];
         */
        
        // Sample data - Case 2
        NSArray *intervalTimeStrings=@[
                                       @"2014-11-29 10:00:00&2014-11-29 15:00:00",
                                       @"2014-11-29 18:00:00&2014-11-29 20:00:00"
                                       ];
        
        
        NSArray *removalTimeStrings=@[
                                      @"2014-11-29 11:00:00&2014-11-29 14:00:00",
                                      @"2014-11-29 19:00:00&2014-11-29 21:00:00"
                                      ];
        
        
        
        NSUInteger index=0;
        IntervalObject *newInterval;
        NSString *intervalStr;
        NSTimeInterval timestamp;
        
        // ----------------------------------------------------------------------------------------------------
        // Add Intervals
        // ----------------------------------------------------------------------------------------------------
        for (NSString *intervalsStr in intervalTimeStrings) {
            NSArray *components=[intervalsStr componentsSeparatedByString:@"&"];

            newInterval=[IntervalObject new];
            newInterval.index=index;
            
            intervalStr=components[0];
            timestamp=[NSDate timestampFromDateStr:intervalStr usingTimezone:timeZoneStr].doubleValue;
            newInterval.start=timestamp;
            
            intervalStr=components[1];
            timestamp=[NSDate timestampFromDateStr:intervalStr usingTimezone:timeZoneStr].doubleValue;
            newInterval.end=timestamp;
            
            
            [intervals enqueue:newInterval];
            index++;
        }
        
        
        // ----------------------------------------------------------------------------------------------------
        // Add Removals
        // ----------------------------------------------------------------------------------------------------
        index=0;
        
        
        for (NSString *intervalsStr in removalTimeStrings) {
            NSArray *components=[intervalsStr componentsSeparatedByString:@"&"];
            
            newInterval=[IntervalObject new];
            newInterval.index=index;
            
            intervalStr=components[0];
            timestamp=[NSDate timestampFromDateStr:intervalStr usingTimezone:timeZoneStr].doubleValue;
            newInterval.start=timestamp;
            
            intervalStr=components[1];
            timestamp=[NSDate timestampFromDateStr:intervalStr usingTimezone:timeZoneStr].doubleValue;
            newInterval.end=timestamp;
            
            
            [removals enqueue:newInterval];
            index++;
        }
        
        
        // ----------------------------------------------------------------------------------------------------
        // Create list of interval points
        // ----------------------------------------------------------------------------------------------------
        NSMutableArray *intervalPointsArr=[NSMutableArray arrayWithCapacity:intervalPointsArr.count+removals.count];
        
        for (IntervalObject *intervalObj in intervals) {
            // Add point for Beginning
            IntervalObject *pointObject=[IntervalObject new];
            
            pointObject.intervalType=IntervalPointTypeStart;
            pointObject.index=intervalObj.index;
            
            pointObject.start=intervalObj.start;
            pointObject.end=-1;
            
            [intervalPointsArr addObject:pointObject];
            
            // Add point for End
            pointObject=[IntervalObject new];
            
            pointObject.intervalType=IntervalPointTypeEnd;
            pointObject.index=intervalObj.index;
            
            pointObject.start=intervalObj.end;
            pointObject.end=-1;
            
            [intervalPointsArr addObject:pointObject];
        }
        
        
        for (IntervalObject *intervalObj in removals) {
            // Add point for Beginning
            IntervalObject *pointObject=[IntervalObject new];
            
            pointObject.intervalType=IntervalPointTypeGapStart;
            pointObject.index=intervalObj.index;
            
            pointObject.start=intervalObj.start;
            pointObject.end=-1;
            
            [intervalPointsArr addObject:pointObject];
            
            // Add point for End
            pointObject=[IntervalObject new];
            
            pointObject.intervalType=IntervalPointTypeGapEnd;
            pointObject.index=intervalObj.index;
            
            pointObject.start=intervalObj.end;
            pointObject.end=-1;
            
            [intervalPointsArr addObject:pointObject];
        }
        
        [intervalPointsArr prioritySort];
        
        NSMutableArray *finalIntervalsArr=sweepQueue(intervalPointsArr);
        
        for (IntervalObject *finalObject in finalIntervalsArr) {
            NSDate *fromDate=[NSDate dateWithTimeIntervalSince1970:finalObject.start];
            NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:finalObject.end];
            
            NSLog(@"(%lu) From: %@ TO: %@",(unsigned long)finalObject.index,fromDate,endDate);
        }
        
    } // autorelease
    
    return 0;
}


NSMutableArray* sweepQueue(NSMutableArray *queue) {
    NSMutableArray *resultArr=[NSMutableArray arrayWithCapacity:queue.count];
    
    BOOL isInterval=NO;
    BOOL isGap=NO;
    NSTimeInterval intervalStart=0;
    
    for (IntervalObject *point in queue) {
        
        switch (point.intervalType) {
            case IntervalPointTypeStart:
                if (!isGap) {
                    intervalStart = point.start;
                }
                isInterval = true;
                
                break;
            case IntervalPointTypeEnd:
                if (!isGap) {
                    IntervalObject *newInterval=[IntervalObject new];
                    newInterval.start=intervalStart;
                    newInterval.end=point.start;
                    newInterval.index=point.index;
                    
                    [resultArr addObject:newInterval];
                }
                isInterval = false;
                
                break;
            case IntervalPointTypeGapStart:
                if (isInterval) {
                    IntervalObject *newInterval=[IntervalObject new];
                    newInterval.start=intervalStart;
                    newInterval.end=point.start;
                    newInterval.index=point.index;
                    
                    [resultArr addObject:newInterval];
                }
                isGap = true;
                
                break;
            case IntervalPointTypeGapEnd:
                if (isInterval) {
                    intervalStart = point.start;
                }
                isGap = false;
                
                break;
            default:
                break;
        }
        
    }
    
    NSInteger reIndexCount=0;
    for (IntervalObject *obj in resultArr) {
        obj.index=reIndexCount;
        
        reIndexCount++;
    }
    
    return resultArr;
}
