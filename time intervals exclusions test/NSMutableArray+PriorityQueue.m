//
//  NSMutableArray+PriorityQueue.m
//
//  Created by Konstantinos Kontos on 30/11/14.
//  Copyright (c) 2014 Saturated Colors. All rights reserved.
//

#import "NSMutableArray+PriorityQueue.h"

@implementation NSMutableArray (PriorityQueue)

-(void)enqueue:(id)object {
    [self addObject:object];
}


-(id)dequeue {
    id dequeuedObject=[self lastObject];
    [self removeLastObject];
    
    return dequeuedObject;
}


-(void)prioritySort {
    
    for (NSInteger i=0; i<self.count-1; i++) {
        id <PriorityQueueComparable> object1=[self objectAtIndex:i];
        
        for (NSInteger y=i+1; y<self.count; y++) {
            id <PriorityQueueComparable> object2=[self objectAtIndex:y];
            
            if ([object2 compareTo:object1]<0) {
                id<PriorityQueueComparable> relocatedObject=object2;
                [self removeObject:object2];
                
                relocatedObject.index=[self indexOfObject:object1];
                [self insertObject:relocatedObject atIndex:[self indexOfObject:object1]];
            }
        }
        
    }
    
}

@end
