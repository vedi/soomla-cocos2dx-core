//
// Created by Fedor Shubin on 6/12/14.
//

#import "CoreService.h"
#import "NdkGlue.h"
#import "Reward.h"
#import "DomainFactory.h"
#import "SoomlaProfile.h"
#import "UserProfileEventHandling.h"
#import "ProviderNotFoundException.h"
#import "UserProfile.h"
#import "DomainHelper.h"
#import "UserProfileNotFoundException.h"
#import "SoomlaEventHandling.h"

@interface CoreService ()
@end

@implementation CoreService {

}

+ (id)sharedCoreService {
    static CoreService *sharedCoreService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoreService = [self alloc];
    });
    return sharedCoreService;
}

+ (void)initialize {
    [super initialize];
    [self initGlue];
}


- (id)init {
    self = [super init];
    if (self) {
        [SoomlaEventHandling observeAllEventsWithObserver:[NdkGlue sharedInstance]
                                                  withSelector:@selector(dispatchNdkCallback:)];
    }

    return self;
}

+ (void)initGlue {
    NdkGlue *ndkGlue = [NdkGlue sharedInstance];

    /* -= Call handlers =- */
    [ndkGlue registerCallHandlerForKey:@"CCCoreService::init" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        [[CoreService sharedCoreService] init];
    }];

    /* -= Callback handlers =- */
    [ndkGlue registerCallbackHandlerForKey:EVENT_REWARD_GIVEN withBlock:^(NSNotification *notification, NSMutableDictionary *parameters) {
        [parameters setObject:@"com.soomla.events.RewardGivenEvent" forKey:@"method"];
        Reward *reward = [notification.userInfo objectForKey:DICT_ELEMENT_REWARD];
        [parameters setObject:[reward toDictionary] forKey:@"reward"];
    }];
    [ndkGlue registerCallbackHandlerForKey:EVENT_REWARD_TAKEN withBlock:^(NSNotification *notification, NSMutableDictionary *parameters) {
        [parameters setObject:@"com.soomla.events.RewardTakenEvent" forKey:@"method"];
        Reward *reward = [notification.userInfo objectForKey:DICT_ELEMENT_REWARD];
        [parameters setObject:[reward toDictionary] forKey:@"reward"];
    }];

}

@end