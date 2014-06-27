//
// Created by Fedor Shubin on 6/11/14.
//

#import <MacTypes.h>
#import "DomainHelper.h"
#import "DomainFactory.h"
#import "CommonJsonConsts.h"


@interface DomainHelper ()
@property(nonatomic, retain) NSMutableDictionary *typeClass;
@property(nonatomic, retain) NSMutableDictionary *classType;
@end

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

- (id)init {
    self = [super init];
    if (self) {
        self.typeClass = [NSMutableDictionary dictionary];
        self.classType = [NSMutableDictionary dictionary];
    }

    return self;
}


- (void)registerType:(NSString *)type withClassName:(NSString *)className {
    [self.classType setObject:type forKey:className];
    [self.typeClass setObject:className forKey:type];
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
        [dictList addObject:[self domainToDict:domain]];
    }

    return dictList;
}

- (NSDictionary *)domainToDict:(NSObject *)domain {
    NSDictionary *dict = [domain performSelector:@selector(toDictionary)];
    NSString *type = [dict objectForKey:JSON_JSON_TYPE];
    if (type != nil) {
        return dict;
    }
    else {
        type = [self.classType objectForKey:NSStringFromClass([domain class])];
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mutableDictionary setObject:type forKey:JSON_JSON_TYPE];
        return mutableDictionary;
    }
}

- (void)dealloc {
    [_typeClass release];
    [_classType release];
    [super dealloc];
}


@end

