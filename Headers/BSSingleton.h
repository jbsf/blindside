#import <Foundation/Foundation.h>

#import "BSScope.h"
#import "BSProvider.h"

@class BSInstanceProvider;

/**
 * The BSSingelton scope is used to define bindings for which the same object instance
 * should be returned on every call to BSInjector getInstance:
 */
@interface BSSingleton : NSObject<BSScope, BSProvider>

/**
 * Returns an instance of BSSingleton that can be used to scope a Blindside binding.
 * Here's how the method might typically be used inside of a BSModule's configure:
 * method:
 *
 * \code
 * - (void)configure:(id<BSBinder>binder) {
 *
 *     // Ensures that only one instance of Foo will be created
 *     [binder bind:[Foo class] withScope:[BSSingleton scope]];
 *
 *     // Binds [MyApi class] to the key "api" and ensures that only one instance
 *     // of MyApi will be created
 *     [binder bind:@"api" toClass:[MyApi class] withScope:[BSSingleton scope]];
 *
 * }
 * \endcode
 */
+ (BSSingleton *)scope;

@end
