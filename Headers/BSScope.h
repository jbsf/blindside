#import <Foundation/Foundation.h>

#import "BSProvider.h"

/**
 * Implementations of BSScope determine when new object instances will be created or retrieved,
 * and when existing instances will instead be returned. Blindside provides one implementation
 * of BSScope - BSSingleton.
 *
 * Users of Blindside are only expected to implement this protocol if they have custom scoping
 * requirements for some of their bindings.
 */
@protocol BSScope <NSObject>

/**
 * Given a BSProvider, this method should return another BSProvider that implements the
 * policy represented by the BSScope implementation. For example, BSSingleton returns
 * a BSProvider that returns the same object instance every time its provide: method is called.
 */
- (id<BSProvider>)scope:(id<BSProvider>)source;
@end

