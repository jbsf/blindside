#import <Foundation/Foundation.h>

#import <Foundation/NSEnumerator.h>

/**
 * A BSPropertySet represents the set of a Class' properties that will be injected into class instances after
 * the instances are created.
 *
 * If a
 */
@interface BSPropertySet : NSObject<NSFastEnumeration>

/**
 * Returns a BSPropertySet for the given class, representing the properties named in the argument list. This
 * method is for use by classes within their implementation of bsProperties.
 *
 * For example, suppose there is a class that has a property called "eventLogger" of type EventLogger *.
 *
 * Suppose we want to inject two of the properties - address and color. We could implement bsProperties
 * like this:
 *
 * \code
 *
 * + (BSPropertySet *)bsProperties {
 *      BSPropertySet *propertySet = [BSPropertySet propertySetWithClass:self propertyNames:@"address" @"color", nil];
 *      [propertySet bind:@"address" toKey:@"my home address"
 *
 * }
 *
 * \endcode
 */
+ (BSPropertySet *)propertySetWithClass:(Class)owningClass propertyNames:(NSString *)property1, ... NS_REQUIRES_NIL_TERMINATION;

- (void)bindProperty:(NSString *)propertyName toKey:(id)key;

@end
