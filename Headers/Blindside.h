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

@interface Blindside : NSObject
+ (BSInjector *)injector:(BSModule *)module;
@end