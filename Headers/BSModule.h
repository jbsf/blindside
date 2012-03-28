#import <Foundation/Foundation.h>

#import "BSBlockProvider.h"

@protocol BSProvider, BSScope;

@interface BSModule : NSObject {
    NSMutableDictionary *providers_;
}

+ (BSModule *)module;

- (void)bind:(id)key toInstance:(id)instance;
- (void)bind:(id)key toProvider:(id<BSProvider>)provider;
- (void)bind:(id)key toBlock:(BSBlock)block;
- (void)bind:(id)key withScope:(id<BSScope>)scope;

- (id<BSProvider>)providerForKey:(id)key;
- (id<BSScope>)scopeForKey:(id)key;

- (void)configure;

@end
