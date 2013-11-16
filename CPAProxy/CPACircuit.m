//
//  CPACircuit.m
//  CPAProxy
//
//  Created by Ivan Doroshenko on 11/16/13.
//  Copyright (c) 2013 CPAProxy. All rights reserved.
//

#import "CPACircuit.h"

@implementation CPACircuit

- (NSString *)description {
    return [NSString stringWithFormat:@"CPACircuit<id:%@, status:%@>",self.circuitID,self.circStatus];
}

@end
