#import <Foundation/Foundation.h>

#import "BSProvider.h"

@protocol BSInjector;
@class BSInitializer;

/**
 * Implementation of BSProvider that wraps a BSInitializer and uses a BSInjector to resolve dependencies.
 * Instances of BSInitializerProvider are created and used by Blindside when it needs to create objects
 * using BSInitializers. 
 * 
 * Users of Blindside are not expected to use this class.
 */
@interface BSInitializerProvider : NSObject<BSProvider> {
    BSInitializer *_initializer;
    id<BSInjector> _injector;
}

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(id<BSInjector>)injector;

@end
