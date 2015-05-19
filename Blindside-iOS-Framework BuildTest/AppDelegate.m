#import <Blindside/Blindside.h>

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) id<BSInjector> injector;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.injector = [Blindside injectorWithModules:@[]];
    return YES;
}

@end
