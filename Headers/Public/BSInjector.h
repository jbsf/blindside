#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BSInjector

/**
 * Asks the injector to retrieve an object for the given key. This is a convenience
 * method for @see -getInstance:withArgArray: when no args are needed.
 */
- (id)getInstance:(id)key;

/**
 * Asks the injector to retrieve an object for the given key. This is a varargs
 * version of @see -getInstance:withArgArray:
 */
- (id)getInstance:(id)key withArgs:(nullable id)arg1, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Asks the injector to retrieve an object for the given key. The args are made available
 * to the @see BSProvider associated with the key. If it is unable to create the object,
 * an exception will be thrown.
 *
 * @param key The injector key that identifies the requested object. This is commonly
 *            an instance of `Class` or `Protocol`, or a string.
 * @param args An array of argument objects to be given to the key's provider. This is
 *             commonly used with objects that have a @see +bsInitializer implementation
 *             with one or more BS_DYNAMIC argument keys.
 * @return An instantiated object with its dependencies already provided.
 */
- (id)getInstance:(id)key withArgArray:(NSArray *)args;

/**
 * Provide property-based dependencies to an object created without an injector. This
 * is useful when working with a framework that instantiates your objects for you.
 * (e.g. nibs or NSKeyedUnarchiver)
 */
- (void)injectProperties:(id)instance;

@end

NS_ASSUME_NONNULL_END
