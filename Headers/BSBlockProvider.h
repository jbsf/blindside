#import <Foundation/Foundation.h>

#import "BSProvider.h"

/**
 * Typedef for blocks used by Blindside. Such blocks take an NSArray * of args and return
 * an id. Blocks that don't need arguments may ignore the args array.
 */
typedef id(^BSBlock)(NSArray *args);

/**
 * Used internally by Blindside when a key is bound to a block. BSBlockProvider 
 * implements the BSProvider interface by acting as a wrapper around the block.
 */
@interface BSBlockProvider : NSObject<BSProvider> {
    BSBlock block_;
}

/**
 * Returns a BSBlockProvider that wraps the block
 */
+ (BSBlockProvider *)provider:(BSBlock)block;

@end
