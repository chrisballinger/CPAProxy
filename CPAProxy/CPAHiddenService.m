//
//  CPAHiddenService.m
//  CPAProxy
//
//  Created by Ivan Doroshenko on 11/7/13.
//  Copyright (c) 2013 CPAProxy. All rights reserved.
//

#import "CPAHiddenService.h"

@interface CPAHiddenService ()

@property (nonatomic, copy, readwrite) NSString *dirPath;
@property (nonatomic, assign, readwrite) NSInteger virtualPort;
@property (nonatomic, assign, readwrite) NSInteger targetPort;

@end

@implementation CPAHiddenService

- (id)initWithDirectoryPath:(NSString *)dirPath virtualPort:(NSInteger)virualPort targetPort:(NSInteger)targetPort {
    self = [super init];
    
    if (self) {
        self.dirPath = [dirPath copy];
        self.virtualPort = virualPort;
        self.targetPort = targetPort;
    }
    
    return self;
}

@end
