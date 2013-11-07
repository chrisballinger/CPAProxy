//  CPAConfiguration.m
//
//  Copyright (c) 2013 Claudiu-Vlad Ursache.
//  See LICENCE for licensing information
//

#import "CPAConfiguration.h"

@interface CPAConfiguration ()
@property (nonatomic, readwrite) NSUInteger controlPort;
@property (nonatomic, readwrite) NSUInteger socksPort;
@property (nonatomic, copy, readwrite) NSString *torTempDirPath;
@end

@implementation CPAConfiguration

+ (instancetype)configurationWithTorrcPath:(NSString *)torrcPath
                                 geoipPath:(NSString *)geoipPath
{
    return [[CPAConfiguration alloc] initWithTorrcPath:torrcPath geoipPath:geoipPath];
}

- (instancetype)init
{
    return [self initWithTorrcPath:nil geoipPath:nil];
}

- (instancetype)initWithTorrcPath:(NSString *)torrcPath
                        geoipPath:(NSString *)geoipPath
{
    self = [super init];
    if(!self) return nil;
    
    self.socksPort = [self randomSOCKSPort];
    self.controlPort = self.socksPort + 1;
    
    self.torrcPath = torrcPath;
    self.geoipPath = geoipPath;
    
    return self;
}

- (NSString *)torTempDirPath 
{
    if (_torTempDirPath != nil) {
        return _torTempDirPath;
    }
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"tor"];
    
    /*
    // Create a new temporary directory
    NSError *error = nil;
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    
     
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    if (error == nil) {
        _torTempDirPath = path;
    }
    */
    
    _torTempDirPath = path;
    return _torTempDirPath;
}

- (NSData *)torCookieData
{
    NSString *control_auth_cookie = [self.torTempDirPath stringByAppendingPathComponent:@"control_auth_cookie"];
    NSData *cookie = [[NSData alloc] initWithContentsOfFile:control_auth_cookie];
    return cookie;
}

- (NSString *)torCookieDataAsHex
{
    NSData *cookieData = self.torCookieData;
    
    const unsigned char *chars = (const unsigned char*)cookieData.bytes;
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (int i = 0; i < cookieData.length; i++) {
        [hexString appendFormat:@"%02lx", (unsigned long)chars[i]];
    }
    
    return [NSString stringWithString:hexString];
}

- (NSString *)socksHost
{
    return @"127.0.0.1";
}

- (NSInteger)randomSOCKSPort 
{
    NSInteger port = (arc4random() % 1000) + 60000;
    return port;
}

@end
