#import <Foundation/Foundation.h>

@protocol BSProvider;

@interface BSModule : NSObject {
    NSMutableDictionary *providers_;
}

+ (BSModule *)module;

- (void)bind:(id)key toInstance:(id)instance;

- (id<BSProvider>)providerForKey:(id)key;

@end
