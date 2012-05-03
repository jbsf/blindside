#import <Foundation/Foundation.h>

#import "BSProvider.h"

typedef id(^BSBlock)(NSArray *args);

/**
 * Used internally by Blindside when a key is bound to a block. BSBlockProvider 
 * implements the BSProvider interface by acting as a wrapper around the block.
 */
@interface BSBlockProvider : NSObject<BSProvider> {
    BSBlock block_;
}

+ (BSBlockProvider *)provider:(BSBlock)block;

@end
