//
//  CPAHiddenService.h
//  CPAProxy
//
//  Created by Ivan Doroshenko on 11/7/13.
//  Copyright (c) 2013 CPAProxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPAHiddenService : NSObject

@property (nonatomic, copy, readonly) NSString *dirPath;
@property (nonatomic, assign, readonly) NSInteger virtualPort;
@property (nonatomic, assign, readonly) NSInteger targetPort;

- (id)initWithDirectoryPath:(NSString *)dirPath virtualPort:(NSInteger)virualPort targetPort:(NSInteger)targetPort;

@end
