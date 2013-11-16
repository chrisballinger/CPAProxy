//  CPAProxyManager+TorControlAdditions.m
//
//  Copyright (c) 2013 Claudiu-Vlad Ursache.
//  See LICENCE for licensing information
//

#import "CPAProxyManager+TorCommands.h"
#import "CPAThread.h"
#import "CPAConfiguration.h"
#import "CPASocketManager.h"

@implementation CPAProxyManager (TorControlAdditions)

- (void)cpa_sendAuthenticate
{
    NSString *torCookieAsHex = self.configuration.torCookieDataAsHex;
    NSString *authMsg = [NSString stringWithFormat:@"AUTHENTICATE %@\n", torCookieAsHex];
    [self.socketManager writeString:authMsg encoding:NSUTF8StringEncoding];
}

- (void)cpa_sendGetBoostrapInfo
{
    NSString *msgBootstrapInfo = @"GETINFO status/bootstrap-phase\n"; 
    [self.socketManager writeString:msgBootstrapInfo encoding:NSUTF8StringEncoding];
}

- (NSInteger)cpa_boostrapProgressForResponse:(NSString *)response
{    
    NSString *progressString = @"BOOTSTRAP PROGRESS=";
    NSInteger progess = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:response];
    [scanner scanUpToString:progressString intoString:NULL];
    
    BOOL stringFound = [scanner scanString:progressString intoString:NULL];
    if (stringFound) {
        [scanner scanInteger:&progess];
    }
    
    return progess;
}

- (NSString *)cpa_HSStateForResponse:(NSString *)response
{
    NSString *progressString = @"HS_STATE=";
    NSString *hsState;
    
    NSScanner *scanner = [NSScanner scannerWithString:response];
    [scanner scanUpToString:progressString intoString:NULL];
    
    BOOL stringFound = [scanner scanString:progressString intoString:NULL];
    if (stringFound) {
        NSCharacterSet *endOfPairSet = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
        [scanner scanUpToCharactersFromSet:endOfPairSet intoString:&hsState];
    }
    
    return hsState;
}

- (NSString *)cpa_ReasonForResponse:(NSString *)response
{
    NSString *progressString = @"PURPOSE=";
    NSString *reason;
    
    NSScanner *scanner = [NSScanner scannerWithString:response];
    [scanner scanUpToString:progressString intoString:NULL];
    
    BOOL stringFound = [scanner scanString:progressString intoString:NULL];
    if (stringFound) {
        NSCharacterSet *endOfPairSet = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
        [scanner scanUpToCharactersFromSet:endOfPairSet intoString:&reason];
    }
    
    return reason;
}


- (BOOL)cpa_isAuthenticatedForResponse:(NSString *)response
{
    if ([response rangeOfString:@"250 OK"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)cpa_isSuccessForResponse:(NSString *)response
{
    if ([response hasPrefix:@"250 OK"]) {
        return YES;
    }
    return NO;
}

- (void)cpa_sendSetEventsRequest {
    NSString *msgBootstrapInfo = @"SETEVENTS EXTENDED CIRC\n";
    [self.socketManager writeString:msgBootstrapInfo encoding:NSUTF8StringEncoding];
}

- (void)cpa_sendSetEventsCancel {
    NSString *msgBootstrapInfo = @"SETEVENTS EXTENDED\n";
    [self.socketManager writeString:msgBootstrapInfo encoding:NSUTF8StringEncoding];
}

- (CPACircuit *)cpa_circuitForResponse:(NSString *)response {
    NSString *header = @"650 CIRC ";
    CPACircuit *circuit;
    
    
    if ([response hasPrefix:header]) {
        NSString *body = [response stringByReplacingOccurrencesOfString:@"650 CIRC " withString:@""];
        NSArray *params = [body componentsSeparatedByString:@" "];
        if (params.count >= 2) {
            circuit = [[CPACircuit alloc] init];
            circuit.circuitID = params[0];
            circuit.circStatus = params[1];
        }
    }
    
    return circuit;
}

@end
