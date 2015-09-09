#import <Foundation/Foundation.h>

#import "BSBinder.h"
#import "BSBlockProvider.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSNull.h"
#import "BSNullabilityCompat.h"
#import "BSPropertySet.h"
#import "BSProvider.h"
#import "BSScope.h"
#import "BSSingleton.h"
#import "NSObject+Blindside.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
