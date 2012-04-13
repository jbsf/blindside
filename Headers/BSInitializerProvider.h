#import <Foundation/Foundation.h>

#import "BSProvider.h"

@class BSInjector, BSInitializer;

@interface BSInitializerProvider : NSObject<BSProvider> {
    BSInitializer *_initializer;
    BSInjector    *_injector;
}

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(BSInjector *)injector;

@end
