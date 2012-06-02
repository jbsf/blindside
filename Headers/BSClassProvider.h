#import <Foundation/Foundation.h>

#import "BSProvider.h"

@protocol BSInjector;

@interface BSClassProvider : NSObject<BSProvider> 

+ (BSClassProvider *)providerWithClass:(Class)class;

@end
