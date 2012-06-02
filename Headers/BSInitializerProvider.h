#import <Foundation/Foundation.h>

#import "BSProvider.h"
@class BSInitializer;

/**
 * Implementation of BSProvider that wraps a BSInitializer. Instances of BSInitializerProvider are 
 * created and used by Blindside when it needs to create objects using BSInitializers. 
 * 
 * Users of Blindside are not expected to use this class.
 */
@interface BSInitializerProvider : NSObject<BSProvider> 

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer;

@end
