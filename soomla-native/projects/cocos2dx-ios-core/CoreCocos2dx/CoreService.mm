//
// Created by Fedor Shubin on 6/12/14.
//

#import "CoreService.h"
#import "NdkGlue.h"
#import "Reward.h"
#import "DomainFactory.h"
#import "UserProfileEventHandling.h"
#import "SoomlaEventHandling.h"
#import "CommonConsts.h"
#import "BadgeReward.h"
#import "RandomReward.h"
#import "SequenceReward.h"
#import "DomainHelper.h"

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
    [self initCreators];
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

+ (void)initCreators {
    [[DomainHelper sharedDomainHelper] registerType:(NSString *) JSON_JSON_TYPE_BADGE
                                      withClassName:NSStringFromClass([BadgeReward class])];
    [[DomainHelper sharedDomainHelper] registerType:(NSString *) JSON_JSON_TYPE_RANDOM
                                      withClassName:NSStringFromClass([RandomReward class])];
    [[DomainHelper sharedDomainHelper] registerType:(NSString *) JSON_JSON_TYPE_SEQUENCE
                                      withClassName:NSStringFromClass([SequenceReward class])];
}

@end