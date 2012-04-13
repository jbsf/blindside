#import <Foundation/Foundation.h>

#import "BSScope.h"
#import "BSProvider.h"

@class BSInstanceProvider;

@interface BSSingleton : NSObject<BSScope, BSProvider> {
    BSInstanceProvider *_instanceProvider;
}

+ (BSSingleton *)scope;

@end
