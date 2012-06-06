#import <Foundation/Foundation.h>

#import "BSBlockProvider.h"

@protocol BSProvider, BSScope;

/**
 * The BSBinder interface is used in configuration of Blindside. Using BSBinder,
 * you tell Blindside how to resolve dependencies.
 *
 * BSModules are passed a BSBinder during Blindside configuration. Your module will
 * invoke one or more bind: methods to describe how object dependencies should be
 * resolved. Here's an example of a configure: method on a simple BSModule,
 * adding one binding.
 *
 * \code
 * @implementation MyModule
 *
 * - (void)configure:(id<BSBinder>) binder {
 *
 *    NSString *endpoint = @"http://productionapi.example.com/";
 *    MyApi *api = [[MyApi alloc] initWithEndpoint:endpoint token:@"djhie7d3jvgnaluFH987dk"];
 *
 *    // binds the key [MyApi class] to the instance of MyApi we just created.
 *    // Any injected objects that need a MyApi will have this one given to them
 *    // by Blindside.
 *
 *    [binder bind:[MyApi class] toInstance:api];
 * }
 *
 * @end
 * \endcode
 *
 * All of the bind: methods take an id key as the first parameter. While the key can be any id,
 * they will commonly be strings, classes, or protocol identifiers. A class my be used as a key
 * when you want to bind to a specific instance/subclass. A protocol identifier can be used
 * to bind to a specific object or class implementing the protocol.
 *
 * When an injector is asked to retrieve an object, it examines the object's dependencies and
 * then looks at the bindings defined as above to figure out how to fill the
 * dependencies. This happens recursively, so the if one object depends on two more objects
 * that also have dependencies, everything is resolved by the injector.
 *
 */
@protocol BSBinder

  /**
   * Binds the key to the instance. Requests for an instance given the key, whether made
   * directly to the injector or made internally by the injector, will always return this
   * instance.
   */
- (void)bind:(id)key toInstance:(id)instance;

  /**
   * Binds the key to the provider. Requests for an instance given the key will forward
   * the request to the provider. The object returned by the provider will be the object
   * returned to the original request.
   *
   * If any arguments are passed to [injector getInstance:], these arguments will be passed
   * to the provider.
   */
- (void)bind:(id)key toProvider:(id<BSProvider>)provider;

  /**
   * Binds the key to a block. Requests for an instance given the key will execute the block
   * and return the block's return value.
   *
   * If any arguments are passed to [injector getInstance:], these arguments will be passed
   * to the block.
   *
   * This trivial example shows how block binding with dynamic args works:
   *
   * \code
   * @implementation MyModule
   * - (void)configure(id<BSBinder>binder {
   *   __block NSString *lastName = @"Thompson";
   *
   *   [binder bind:@"fullName" toBlock:^id()(NSArray *args, id<BSInjector>injector){
   *        NSString *firstName = args[0];
   *        return [NSString stringWithFormat:@"%@ %@", firstName, lastName, nil];
   *   }];
   * }
   *
   *  ... elsewhere:
   *
   *  NSString *fullName = [injector getInstance:@"fullName" withArgs:@"Jenny", nil];
   *  // Jenny Thompson
   * \endcode
   *
   */
- (void)bind:(id)key toBlock:(BSBlock)block;

  /**
   * Binds the key to the class. A request for an instance given the key will return an
   * an instance of the class. How this happens will depend on other configurations.
   *
   * For example, imagine a call to [injector getInstance:[Foo class]];
   *
   * If no bindings have been created using [Foo class] as a key, then Blindside will try to
   * create a Foo instance using the Foo class' bsInitializer.
   *
   * If [Foo class] had been bound to a block, then the block would be invoked and its
   * return value would be passed to the caller of getInstance:
   *
   * If [Foo class] had been bound to a BSProvider, then the provider's provide: method
   * would be called and the return value would be passed to the caller of getInstance:
   */
- (void)bind:(id)key toClass:(Class)type;

  /**
   * Same as above, with the additional introduction of scoping. Within a
   * call to [injector getInstance:[Foo class]], the scope will decide whether
   * a new Foo should be created, or whether an existing instance should be returned.
   */
- (void)bind:(id)key toClass:(Class)type withScope:(id<BSScope>)scope;

  /**
   * Defines the scope to be used with the key. The scoping applies to existing bindings
   * for the key, and will apply to future bindings as well. To remove a scope, call
   *
   * [binder bind:key withScope:nil];
   *
   */
- (void)bind:(id)key withScope:(id<BSScope>)scope;

@end
