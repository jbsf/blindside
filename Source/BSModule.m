#import <objc/runtime.h>

#import "BSModule.h"
#import "BSInstanceProvider.h"
#import "BSInitializerProvider.h"
#import "BSInitializer.h"

@interface BSModule ()
@property (nonatomic, retain) NSMutableDictionary *providers;
@end

@implementation BSModule

@synthesize providers = providers_;

+ (BSModule *)module {
    return [[[BSModule alloc] init] autorelease];
}

- (id)init {
    if (self = [super init]) {
        self.providers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.providers = nil;
    [super dealloc];
}

- (void)bind:(id)key toInstance:(id)instance {
    BSInstanceProvider *provider = [BSInstanceProvider provider:instance];
    [self.providers setObject:provider forKey:key];
}

- (id<BSProvider>)providerForKey:(id)key {
    return [self.providers objectForKey:key];
}

@end
 