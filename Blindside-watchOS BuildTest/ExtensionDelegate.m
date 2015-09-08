#import <WatchKit/WatchKit.h>
#import <Blindside/Blindside.h>

@interface ExtensionDelegate : NSObject <WKExtensionDelegate, BSModule>
@end

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    id<BSInjector> injector = [Blindside injectorWithModule:self];
    NSString *greeting = [injector getInstance:@"greeting"];
    NSLog(@"%@", greeting);
}

- (void)configure:(id<BSBinder>)binder {
    [binder bind:@"greeting" toInstance:@"Hello World"];
}

@end
