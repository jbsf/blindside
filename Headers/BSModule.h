#import <Foundation/Foundation.h>

#import "BSScope.h"

@class BSInjector;
@protocol BSProvider;

@interface BSModule : NSObject {
    BSInjector *injector_;
    NSMutableDictionary *providers_;
}

@property (nonatomic, assign) BSInjector *injector;

+ (BSModule *)module;

- (void)bind:(id)key toInstance:(id)instance;
- (void)bind:(id)key toProvider:(id<BSProvider>)provider;
- (void)bind:(id)key withScope:(id<BSScope>)scope;

- (id<BSProvider>)providerForKey:(id)key;

- (void)configure;

@end
