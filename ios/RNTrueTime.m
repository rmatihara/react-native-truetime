#import "RNTrueTime.h"

@import TrueTime;

@implementation RNTrueTime

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

TrueTimeClient *client;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initTrueTime:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject)
{
    // grab reference to shared true time singleton
    client = [TrueTimeClient sharedInstance];
    // initialise
    [client startWithPool:@[@"time.apple.com"] port:123];
    // resolve
    resolve(@"");
}

RCT_EXPORT_METHOD(getTrueTime:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject)
{
    // grab true time without fear of user messing with their system clock
    NSDate *now = [[client referenceTime] now];
    // milliseconds since epoch
    long ms = (floor([now timeIntervalSince1970] * 1000));
    // resolve as a string
    NSString *msString = [NSString stringWithFormat:@"%ld", ms];
    // resolve the promise
    resolve(msString);
}

@end
