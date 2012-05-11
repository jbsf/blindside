#import <Foundation/Foundation.h>

#import "BSScope.h"
#import "BSProvider.h"

@class BSInstanceProvider;

@interface BSSingleton : NSObject<BSScope, BSProvider>

+ (BSSingleton *)scope;

@end
