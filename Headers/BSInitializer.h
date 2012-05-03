#import <Foundation/Foundation.h>

/**
 * A BSInitializer describes an initializer method that Blindside will use when constructing
 * an object of a given class. 
 */
@interface BSInitializer : NSObject {
    Class type_;
    SEL selector_;
    NSArray *argumentKeys_;
    NSMethodSignature *signature_;
    
}

@property (nonatomic, retain) NSArray *argumentKeys;

/**
 * Creates a BSInitializer representing the given class and selector. This is an important method
 * for users of Blindside. Within their implementations of the blindsideInitializer, Blindside
 * users will create BSInitializers using this method. 
 *
 * @param type The class to which the initializer belongs. The BSInitializer returned by this method
 * will be used by Blindise to create instances of this class.
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
 * 
 *                    
 */
+ (BSInitializer *)initializerWithClass:(Class)type selector:(SEL)selector argumentKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

- (NSUInteger)numberOfArguments;
- (id)keyForArgumentAtIndex:(NSUInteger)index;

/**
 * Used internally by Blindside to create an object using the initializer described by 
 * this BSInitializer.
 */
- (id)perform:(NSArray *)argValues;

@end
