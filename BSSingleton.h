#import <Foundation/Foundation.h>

#import "BSScope.h"

@class BSInstanceProvider;

@interface BSSingleton : NSObject<BSScope> {
    BSInstanceProvider *instanceProvider_;
}

+ (BSSingleton *)scope;

@end
