//
// Created by Fedor Shubin on 6/11/14.
//

#import <Foundation/Foundation.h>

@interface DomainHelper : NSObject
+ (id)sharedDomainHelper;
- (id) getDomainsFromDictList: (NSArray *)dictList;
- (id) getDictListFromDomains: (NSArray *)domains;
@end