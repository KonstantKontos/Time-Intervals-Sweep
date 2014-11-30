//
//  NSMutableArray+PriorityQueue.h
//  algorithm test
//
//  Created by Konstantinos Kontos on 30/11/14.
//  Copyright (c) 2014 Saturated Colors. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PointType) {
    IntervalPointTypeEnd,
    IntervalPointTypeGapEnd,
    IntervalPointTypeGapStart,
    IntervalPointTypeStart
};

@protocol PriorityQueueComparable <NSObject>

@required
@property NSUInteger index;
@property NSTimeInterval start;
-(NSInteger)compareTo:(id)otherObject;

@end


@interface NSMutableArray (PriorityQueue)

-(void)enqueue:(id<PriorityQueueComparable>)object;
-(id<PriorityQueueComparable>)dequeue;
-(void)prioritySort;

@end
