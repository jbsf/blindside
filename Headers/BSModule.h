#import <Foundation/Foundation.h>

#import "BSScope.h"

@protocol BSProvider;

@interface BSModule : NSObject {
    NSMutableDictionary *providers_;
}

+ (BSModule *)module;

- (void)bind:(id)key toInstance:(id)instance;
- (void)bind:(id)key withScope:(BSScope)scope;

- (id<BSProvider>)providerForKey:(id)key;

- (void)configure;

@end
