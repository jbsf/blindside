#import <Foundation/Foundation.h>

#import "BSProvider.h"

@protocol BSInjector;
@class BSInitializer;

@interface BSInitializerProvider : NSObject<BSProvider> {
    BSInitializer *_initializer;
    id<BSInjector> _injector;
}

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(id<BSInjector>)injector;

@end
