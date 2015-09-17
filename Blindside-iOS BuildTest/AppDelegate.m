#import <UIKit/UIKit.h>
#import <Blindside/Blindside.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BSModule>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id<BSInjector> injector = [Blindside injectorWithModule:self];
    NSString *greeting = [injector getInstance:@"greeting"];
    NSLog(@"%@", greeting);
    return YES;
}

- (void)configure:(id<BSBinder>)binder {
    [binder bind:@"greeting" toInstance:@"Hello World"];
}

@end
