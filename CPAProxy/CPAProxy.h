//  CPAProxy.h
//
//  Copyright (c) 2013 Claudiu-Vlad Ursache.
//  See LICENCE for licensing information
//

#import <Foundation/Foundation.h>

#ifndef _CEPPA_
#define _CEPPA_

extern NSString * const CPAProxyDidStartSetupNotification;
extern NSString * const CPAProxyDidFailSetupNotification;
extern NSString * const CPAProxyDidFinishSetupNotification;

#import "CPAProxyManager.h"
#import "CPAProxyManager+TorCommands.h"
#import "CPAThread.h"
#import "CPASocketManager.h"
#import "CPAConfiguration.h"
#import "CPAHiddenService.h"

#endif
