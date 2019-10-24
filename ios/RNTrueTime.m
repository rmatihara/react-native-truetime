#import "RNTrueTime.h"

@import TrueTime;

@implementation RNTrueTime

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initTrueTime:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject)
{
    // grab reference to shared true time singleton
    TrueTimeClient *client = [TrueTimeClient sharedInstance];
    // initialise
    [client startWithPool:@[@"time.apple.com"] port:123];
    // resolve
    resolve(@"");
}

RCT_EXPORT_METHOD(getTrueTime:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject)
{
    TrueTimeClient *client = [TrueTimeClient sharedInstance];
    // grab true time without fear of user messing with their system clock
    NSDate *now = [[client referenceTime] now];
    // milliseconds since epoch
    long ms = (floor([now timeIntervalSince1970] * 1000));
    // resolve as a string
    NSString *msString = [NSString stringWithFormat:@"%f", ms];
    // resolve the promise
    resolve(msString);
}

@end
