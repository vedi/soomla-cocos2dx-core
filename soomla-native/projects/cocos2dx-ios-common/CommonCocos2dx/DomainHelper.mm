//
// Created by Fedor Shubin on 6/11/14.
//

#import "DomainHelper.h"
#import "DomainFactory.h"


@implementation DomainHelper {

}

+ (id)sharedDomainHelper {
    static DomainHelper *sharedDomainHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDomainHelper = [[self alloc] init];
    });
    return sharedDomainHelper;
}

- (id)getDomainsFromDictList:(NSArray *)dictList {
    if (dictList == nil) {
        return nil;
    }

    NSMutableArray *domains = [NSMutableArray arrayWithCapacity:[dictList count]];

    for (NSDictionary *dict in dictList) {
        [domains addObject:[[DomainFactory sharedDomainFactory] createWithDict:dict]];
    }

    return domains;
}

- (id)getDictListFromDomains:(NSArray *)domains {
    if (domains == nil) {
        return nil;
    }

    NSMutableArray *dictList = [NSMutableArray arrayWithCapacity:[domains count]];

    for (id domain in domains) {
        [dictList addObject: [domain performSelector: @selector(toDictionary)]];
    }

    return domains;
}


@end

