#import <Foundation/Foundation.h>

#import "BSProvider.h"

@protocol BSInjector;

/**
 * Typedef for blocks used by Blindside. Such blocks take an NSArray * of args and return
 * an id. Blocks that don't need arguments may ignore the args array.
 *
 * @param args An array of dynamic args provided by the caller of the BSInjector method
 *        getInstance:withArgs. If a block does not need arguments, this param can be 
 *        ignored.
 *
 * @param injector The BSInjector invoking the block. Can be used by blocks that need
 *        it and ignored by blocks that don't.
 */
typedef id(^BSBlock)(NSArray *args, id<BSInjector> injector);

/**
 * Used internally by Blindside when a key is bound to a block. BSBlockProvider 
 * implements the BSProvider interface by acting as a wrapper around the block.
 */
@interface BSBlockProvider : NSObject<BSProvider> 

/**
 * Returns a BSBlockProvider that wraps the block
 */
+ (BSBlockProvider *)providerWithBlock:(BSBlock)block;

@end
