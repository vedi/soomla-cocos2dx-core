//
// Created by Fedor Shubin on 6/15/14.
//

#import "ServiceManager.h"
#import "ProfileService.h"


@interface ServiceManager ()
@property(nonatomic, retain) NSMutableArray *services;
@end

@implementation ServiceManager {

}

+ (id)sharedServiceManager {
    static ServiceManager *sharedServiceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServiceManager = [[self alloc] init];
    });
    return sharedServiceManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _services = [NSMutableArray array];
    }

    return self;
}

- (void)registerService:(NSObject *)service {
    [self.services addObject:service];
}

- (void)dealloc {
    [_services release];
    [super dealloc];
}

@end