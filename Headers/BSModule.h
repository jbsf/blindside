#import <Foundation/Foundation.h>

#import "BSScope.h"

@protocol BSProvider;

@interface BSModule : NSObject {
    NSMutableDictionary *providers_;
}

+ (BSModule *)module;

- (void)bind:(id)key toInstance:(id)instance;
- (void)bind:(id)key toProvider:(id<BSProvider>)provider;
- (void)bind:(id)key withScope:(id<BSScope>)scope;

- (id<BSProvider>)providerForKey:(id)key;
- (id<BSScope>)scopeForKey:(id)key;

- (void)configure;

@end
