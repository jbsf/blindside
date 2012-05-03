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

@interface Blindside

/**
 * Creates and returns a BSInjector configured with the module.
 */
+ (id<BSInjector>)injectorWithModule:(id<BSModule>)module;

@end