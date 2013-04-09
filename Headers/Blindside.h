#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

#import "BSScope.h"

#import "BSInitializer.h"
#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSInstanceProvider.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "NSObject+Blindside.h"
#import "BSSingleton.h"
#import "BSPropertySet.h"
#import "BSProperty.h"
#import "BSBinder.h"
#import "BSNull.h"

@interface Blindside : NSObject 

/**
 * Returns a BSInjector configured with the module.
 */
+ (id<BSInjector>)injectorWithModule:(id<BSModule>)module;

/**
 * Returns a BSInjector configured with the modules. Starting at index 0, each module
 * will in turn have it configure: method called. Thus, if two modules bind to the same
 * key, the second binding will win.
 */
+ (id<BSInjector>)injectorWithModules:(NSArray *)modules;

@end
