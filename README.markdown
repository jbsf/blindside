# Blindside: dependency injection for Objective-C

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Why should I use this?

Blindside helps you write clean code. You can keep your objects loosely coupled and ignorant of the world outside. Your objects can create other objects without needing to know about the other objects' dependencies.


## What's with the name?

It's a play on the idea that objects should be blind to the origin of their dependencies. Mostly, however, it's fun to name classes "BSInjector", "BSProvider", etc.


## What, are we Java?

Sadly, yes. Objective-C and Java are identical with respect to the object-level dependency management  offered by the language: basically none. Global variables, "sharedInstance" singletons, and pass-through parameters are the common patterns used to access dependencies. None are good options. 

Guice brought elegant object dependency management to Java, obviating the need for static data, and fulfilling the promise of true OO programming. Blindside seeks to do the same for Objective-C.

## What features does it have?

* Injecting dependencies of UIViewController subclasses, including master/detail view controllers
* "Constructor injection" via initializers
* "Setter injection" via properties
* Injection of third-party classes using categories
* Binding to instances, blocks, Providers, or classes
* Scoped bindings, including Singletons
* Support for creation-time parameters not defined in bindings.

## Status

Blindside is alpha software. There's no documentation aside from this readme. My focus is now on building out the documentation, along with examples. I'm using it on my current iOS project and it's working nicely. I've published it as-is to see if it stirs any interest. If you've come across this readme and have some questions, or would like to learn more on how to use Blindside, please get in touch. 


## How does it work?

You describe your object's dependencies, define bindings to fill those dependencies, then ask the BSInjector to create your objects. Here's a "Hello, World" example:

```objectivec
/**
 * Our view controller. It needs to be created with an api instance.
 */
@interface MyViewController : UIViewController
- (id)initWithApi:(id<MyApi>)api;
@end

@implementation MyViewController

/**
 * Describing MyViewController's dependencies. We want instances initialized using initWithApi:, which takes one arg.
 */
+ (BSInitializer *)bsInitializer {
		return [BSInitializer initializerWithClass:self 
		                                  selector:@selector(initWithApi:) 
		                              argumentKeys:@"myApi", nil];
}

...

@end


@interface MyBlindsideModule : NSObject<BSModule>
@end

@implementation MyBlindsideModule

/**
 * Creating a binding for our MyApi dependency.
 */
- (void)configure:(id<BSBinder>) binder {
		id<MyApi> apiInstance = [[MyApiImpl alloc] initWithEndpoint:@"http://api.mycompany.com"];
		[binder bind:@"myApi" toInstance:apiInstance];
}
@end


@implementation AppDelegate
- (void)applicationDidFinishLaunching {
		...
		// Creating an injector configured with our BSModule. Asking the injector for an instance of our ViewController.
		MyBlindsideModule *module = [[MyBlindsideModule alloc] init];
		id<BSInjector> injector = [Blindside injectorWithModule:module];
		UIViewController *rootViewController = [injector getInstance:[MyViewController class]];
		
		...
}
@end
```

Obviously you don't need a framework to accomplish a task this trivial. Blindside really helps when MyViewController creates another view controller, which creates another, which has additional dependencies, and so on.



## Describing dependencies

Blindside provides dependencies to objects in two ways: via an initializer (e.g. initWithDelegate:), or using properties. You can mix and match the two.
 
Blindside relies on two class methods for describing dependencies. These methods are added to NSObject in the NSObject+Blindside category, and are meant to be overridden by classes injected with Blindside. The methods are:

+ (BSInitializer *)bsInitializer;
+ (BSPropertySet *)bsProperties;

bsInitializer describes the initialization method to be used when creating instances of a class, including the initializer's selector and arguments. Blindside can use a class' BSInitializer to create instances of the class, with dependencies injected.

bsProperties describes the properties to be injected into already-created objects.

Here's an example implementation of the two methods for a class named House. The House class takes an Address as an initializer arg, and has a property of type UIColor.

```objectivec
@implementation House

+ (BSInitializer *)bsInitializer {
		SEL selector = @selector(initWithAddress:)
		return [BSInitializer initializerWithClass:self selector:selector argumentKeys:[Address class]];
}

+ (BSPropertySet *)bsProperties {
		BSPropertySet *propertySet = [BSPropertySet propertySetWithClass:self propertyNames:@"color", nil];
		[propertySet bindProperty:@"color" toKey:@"myHouseColor"];
		return propertySet;
}
 ...

```


## Awaking from injection

When working with property injection, it is occationally desirable to have a hook that can be used to finish setting up an object after all dependencies have been injected. Blindside provides a mechanism for this:

```objectivec

@implementation House
- (void)bsAwakeFromPropertyInjection {
	// Finalize instantiation
}
 ...

```

Note that the use of this method is discouraged because it increases the coupling between your code and Blindside. First look for other appropriate lifecycle methods on your object (e.g. `-viewDidLoad` for a view controller) that could be used to perform this kind of work.

## Author

* [JB Steadman](mailto:jb@pivotallabs.com), Pivotal Labs

Copyright (c) 2012 JB Steadman. This software is licensed under the MIT License.
