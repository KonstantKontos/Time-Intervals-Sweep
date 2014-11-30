//
//  IntervalObject.h
//
//  Created by Konstantinos Kontos on 29/11/14.
//  Copyright (c) 2014 Saturated Colors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+PriorityQueue.h"

@interface IntervalObject : NSObject <PriorityQueueComparable>

@property PointType intervalType;
@property NSUInteger index;

@property NSTimeInterval start;
@property NSTimeInterval end;

@end
