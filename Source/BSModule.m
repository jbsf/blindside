#import <objc/runtime.h>

#import "BSModule.h"
#import "BSInstanceProvider.h"
#import "BSInitializerProvider.h"
#import "BSBlockProvider.h"
#import "BSInitializer.h"

@interface BSModule ()
@property (nonatomic, retain) NSMutableDictionary *providers;
@property (nonatomic, retain) NSMutableDictionary *scopes;
@end

@implementation BSModule

@synthesize providers = providers_, scopes = scopes_;

+ (BSModule *)module {
    return [[[BSModule alloc] init] autorelease];
}

- (id)init {
    if (self = [super init]) {
        self.providers = [NSMutableDictionary dictionary];
        self.scopes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.providers = nil;
    self.scopes = nil;
    [super dealloc];
}

- (void)bind:(id)key toInstance:(id)instance {
    BSInstanceProvider *provider = [BSInstanceProvider provider:instance];
    [self.providers setObject:provider forKey:key];
}

- (void)bind:(id)key toProvider:(id<BSProvider>)provider {
    [self.providers setObject:provider forKey:key];
}

- (void)bind:(id)key toBlock:(id(^)())block {
    BSBlockProvider *provider = [BSBlockProvider provider:block];
    [self.providers setObject:provider forKey:key];
}

- (void)bind:(id)key withScope:(id<BSScope>)scope {
    [self.scopes setObject:scope forKey:key];
}

- (id<BSProvider>)providerForKey:(id)key {
    return [self.providers objectForKey:key];
}

- (id<BSScope>)scopeForKey:(id)key {
    return [self.scopes objectForKey:key];    
}

- (void)configure {
}

@end
 