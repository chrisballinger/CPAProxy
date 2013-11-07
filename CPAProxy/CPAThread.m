//  CPAThread.m
//
//  Copyright (c) 2013 Claudiu-Vlad Ursache.
//  See LICENCE for licensing information
//

#import "CPAThread.h"
#import "CPAConfiguration.h"
#import "CPAHiddenService.h"
#import "tor_cpaproxy.h"

const char *kTorArgsKeyARG0 = "tor";
const char *kTorArgsKeyDataDirectory = "DataDirectory";
const char *kTorArgsKeyControlPort = "ControlPort";
const char *kTorArgsKeyKeySOCKSPort = "SocksPort";
const char *kTorArgsKeyGeoIPFile = "GeoIPFile";
const char *kTorArgsKeyTorrcFile = "-f";
const char *kTorArgsKeyLog = "Log";
const char *kTorArgsKeyHiddenServiceDir = "HiddenServiceDir";
const char *kTorArgsKeyHiddenServicePort = "HiddenServicePort";

#ifndef DEBUG
const char *kTorArgsValueLogLevel = "warn stderr";
#else
const char *kTorArgsValueLogLevel = "notice stderr";
#endif

@interface CPAThread ()
@property (nonatomic, strong, readwrite) CPAConfiguration *configuration;
@end

@implementation CPAThread

- (instancetype)init
{
    CPAConfiguration *datasource = [[CPAConfiguration alloc] init];
    return [self initWithConfiguration:datasource];
}

- (instancetype)initWithConfiguration:(CPAConfiguration *)configuration
{
    self = [super init];
    if(!self) return nil;
    
    self.configuration = configuration;
    
    return self;
}

- (void)main
{
    NSString *dataDir = self.configuration.torTempDirPath;
    NSString *torrcPath = self.configuration.torrcPath;
    NSString *geoipPath = self.configuration.geoipPath;
    NSString *controlPort = [NSString stringWithFormat:@"%lu", (unsigned long)self.configuration.controlPort];
    NSString *socksPort = [NSString stringWithFormat:@"%lu", (unsigned long)self.configuration.socksPort];
    
    __block NSInteger argc = 13;
    
    argc = argc + self.configuration.hiddenServices.count * 4;
    
    const char * argv[argc];
    
    argv[0] = kTorArgsKeyARG0;
    argv[1] = kTorArgsKeyDataDirectory; argv[2]  = [dataDir UTF8String];
    argv[3] = kTorArgsKeyControlPort; argv[4]  = [controlPort UTF8String];
    argv[5] = kTorArgsKeyKeySOCKSPort; argv[6]  = [socksPort UTF8String];
    argv[7] = kTorArgsKeyGeoIPFile; argv[8]  = [geoipPath UTF8String];
    argv[9] = kTorArgsKeyTorrcFile; argv[10] = [torrcPath UTF8String];
    argv[11] = kTorArgsKeyLog; argv[12] = kTorArgsValueLogLevel;
    
    for (int i = 0; i < self.configuration.hiddenServices.count; i++) {
        CPAHiddenService *service = self.configuration.hiddenServices[i];
        NSString *ports = [NSString stringWithFormat:@"%lu %lu", (unsigned long)service.virtualPort, (unsigned long)service.targetPort];
        
        argv[12 + i + 1] = kTorArgsKeyHiddenServiceDir; argv[12 + i + 2] = [service.dirPath UTF8String];
        argv[12 + i + 3] = kTorArgsKeyHiddenServicePort; argv[12 + i + 4] = [ports UTF8String];
    }
    
//    const char *argv[] = { 
//        kTorArgsKeyARG0, 
//        kTorArgsKeyDataDirectory, [dataDir UTF8String], 
//        kTorArgsKeyControlPort, [controlPort UTF8String],
//        kTorArgsKeyKeySOCKSPort, [socksPort UTF8String],
//        kTorArgsKeyGeoIPFile, [geoipPath UTF8String], 
//        kTorArgsKeyTorrcFile, [torrcPath UTF8String],
//        kTorArgsKeyLog, kTorArgsValueLogLevel, 
//        NULL 
//    };
    
    tor_main(argc, (const char **)&argv);
}

@end
