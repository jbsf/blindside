#import <Foundation/Foundation.h>

#import "BSProvider.h"

@class BSModule, BSInitializer;

@interface BSInitializerProvider : NSObject<BSProvider> {
    BSInitializer *initializer_;
    BSModule *module_;
}

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer module:(BSModule *)module;

- (id)initWithInitializer:(BSInitializer *)initializer module:(BSModule *)module;
@end
