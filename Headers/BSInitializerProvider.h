#import <Foundation/Foundation.h>

#import "BSProvider.h"

@class BSInjector, BSInitializer;

@interface BSInitializerProvider : NSObject<BSProvider> {
    BSInitializer *initializer_;
    BSInjector    *injector_;
}

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(BSInjector *)injector;

- (id)initWithInitializer:(BSInitializer *)initializer injector:(BSInjector *)injector;
@end
