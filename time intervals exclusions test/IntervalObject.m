//
//  IntervalObject.m
//  algorithm test
//
//  Created by Konstantinos Kontos on 29/11/14.
//  Copyright (c) 2014 Saturated Colors. All rights reserved.
//

#import "IntervalObject.h"

@implementation IntervalObject

-(NSInteger)compareTo:(id)otherObject {
    IntervalObject *other=(IntervalObject *)otherObject;
    
    if (other.start == self.start) {
        return self.intervalType < other.intervalType ? -1 : 1;
    } else {
        return self.start < other.start ? -1 : 1;
    }
    
}

@end
