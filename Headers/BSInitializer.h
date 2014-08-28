#import <Foundation/Foundation.h>

/**
 * A BSInitializer describes an initializer method that Blindside will use when constructing
 * objects of a given class. 
 */
@interface BSInitializer : NSObject 

@property (nonatomic, weak, readonly) Class type;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, strong, readonly) NSArray *argumentKeys;

/**
 * Creates a BSInitializer representing the given class and selector. This is an important method
 * within Blindside, one that users will commonly use within their implementations of bsInitializer.
 *
 * @param type The class to which the initializer belongs. The BSInitializer returned by this method
 * will be used by Blindside to create instances of this class.
 *
 * @param selector The selector representing the initializer signature. The initializer will be invoked
 * by Blindside when creating instances of the class
 *
 * @param argumentKeys A nil-terminated list of keys that Blindside will use to resolve object dependencies.
 * The number of argumentKeys provided must match the number of arguments expected by the initializer. Argument
 * keys are commonly classes, representing the class of the needed dependency, or strings, representing an 
 * actual object instance configured elsewhere in Blindside.
 * 
 * Consider for example a class that has an initializer like:
 *
 * \code
 * - (id)initWithFoo:(Foo *)foo bar:(Bar *)bar;
 * \endcode
 * 
 * Depending on their needs, there are a number of ways a Blindside user could describe this initializer.
 * Here is the most basic:
 * 
 * \code
 * + (BSInitializer *)bsInitializer {
 *     SEL selector = @selector(initWithFoo:bar:);
 *     return [BSInitializer initializerWithClass:self selector:selector argumentKeys:[Foo class], [Bar class], nil];
 * }
 * \endcode
 * 
 * In the example above, our argumentKeys indicate that the initializer needs an instance of Foo and an instance of Bar.
 * If there are Blindside bindings for [Foo class] and [Bar class], those bindings will be used and the results
 * injected when this initializer is invoked. If there are no such bindings, Blindide will use the 
 * bsInitializer of Foo and Bar to create Foo and Bar instances.
 * 
 * argument keys can be any valid id - they need not represent the argument type. Suppose that our class needs 
 * the uberFoo - the most powerful Foo imaginable. We could describe the initializer like this:
 *
 * \code
 * + (BSInitializer *)bsInitializer {
 *     SEL selector = @selector(initWithFoo:bar:);
 *     return [BSInitializer initializerWithClass:self selector:selector argumentKeys:@"uberFoo", [Bar class], nil];
 * }
 * \endcode
 *
 * To support this initializer, we would need to have defined a binding to @"uberFoo" within our BSModule. Here's 
 * an example:
 * 
 * \code
 * - (void)configure:(BSBinder *)binder {
 *
 *     Foo *uberFoo = [[Foo alloc] init];
 *     [binder bind:@"uberFoo" toInstance:uberFoo];
 * 
 * }
 * \endcode
 * 
 */
+ (BSInitializer *)initializerWithClass:(Class)type selector:(SEL)selector argumentKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Creates a BSInitializer representing the given class and selector. This is an important method
 * within Blindside, one that users will commonly use within their implementations of bsInitializer.
 * Similar to -[initializerWithClass:selector:argumentKeys:], except a class method is used instead
 * of an initialize selector.
 *
 * @param type The class to which the initializer belongs. The BSInitializer returned by this method
 * will be used by Blindside to create instances of this class.
 *
 * @param selector The selector representing the class method signature. The initializer will be invoked
 * by Blindside when creating instances of the class
 *
 * @param argumentKeys A nil-terminated list of keys that Blindside will use to resolve object dependencies.
 * The number of argumentKeys provided must match the number of arguments expected by the initializer. Argument
 * keys are commonly classes, representing the class of the needed dependency, or strings, representing an
 * actual object instance configured elsewhere in Blindside.
 */
+ (BSInitializer *)initializerWithClass:(Class)type classSelector:(SEL)selector argumentKeys:(id)firstKey, ...
    NS_REQUIRES_NIL_TERMINATION;

/**
 * Creates an object using the initializer and the passed-in argument values. The number of argument values
 * must match the number of arguments expected by the initializer. Arguments are passed to the initializer 
 * in order.
 *
 * This method is used internally by Blindside when it needs to create instances of a class.
 */
- (id)bsPerform:(NSArray *)argumentValues;

@end
