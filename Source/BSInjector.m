#import "BSInjector.h"
#import "BSBinder.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInstanceProvider.h"
#import "BSInitializer.h"
#import "BSScope.h"

@interface BSInjector () {
    NSMutableDictionary *providers_;
    NSMutableDictionary *scopes_;
}

@property(nonatomic, retain) NSMutableDictionary *providers;
@property(nonatomic, retain) NSMutableDictionary *scopes;

@end

@implementation BSInjector

@synthesize providers = providers_, scopes = scopes_;

+ (BSInjector *)injectorWithModule:(id<BSModule>)module {
    BSInjector *injector = [[[BSInjector alloc] init] autorelease];
    [module configure:injector];
    [injector bind:@"bsInjector" toInstance:injector];
    return injector;
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

- (void)bind:(id)key toBlock:(BSBlock)block {
    BSBlockProvider *provider = [BSBlockProvider provider:block];
    [self.providers setObject:provider forKey:key];
}

- (void)bind:(id)key toClass:(Class)class {
    BSInitializer *initializer = [class performSelector:@selector(blindsideInitializer)];
    id<BSProvider> provider = [BSInitializerProvider providerWithInitializer:initializer injector:self];
    [self bind:key toProvider:provider];
}

- (void)bind:(id)key toClass:(Class)class withScope:(id<BSScope>)scope {
    [self bind:key toClass:class];
    [self bind:key withScope:scope];
}

- (void)bind:(id)key withScope:(id<BSScope>)scope {
    [self.scopes setObject:scope forKey:key];
}

- (id)getInstance:(id)key {
    id<BSProvider> provider = [self.providers objectForKey:key];
    id<BSScope> scope = [self.scopes objectForKey:key];
    
    if (provider == nil && [key respondsToSelector:@selector(blindsideInitializer)]) {
        BSInitializer *initializer = [key performSelector:@selector(blindsideInitializer)];
        provider = [BSInitializerProvider providerWithInitializer:initializer injector:self];
    }
    
    if (provider && scope) {
        provider = [scope scope:provider];
    }

    return [provider provide];
}


@end
