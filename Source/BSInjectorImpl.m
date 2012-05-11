#import "BSInjectorImpl.h"
#import "BSBinder.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInstanceProvider.h"
#import "BSInitializer.h"
#import "BSScope.h"
#import "BSProperty.h"
#import "BSClassProvider.h"

#import <objc/runtime.h>

@interface BSInjectorImpl () {
    NSMutableDictionary *providers_;
    NSMutableDictionary *scopes_;
}

@property(nonatomic, retain) NSMutableDictionary *providers;
@property(nonatomic, retain) NSMutableDictionary *scopes;
- (void)injectInjector:(id)object;
- (id)getInstance:(id)key withArgArray:(NSArray *)args;
@end

@implementation BSInjectorImpl

@synthesize providers = _providers, scopes = _scopes;


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
    BSBlockProvider *provider = [BSBlockProvider providerWithBlock:block injector:self];
    [self.providers setObject:provider forKey:key];
}

- (void)bind:(id)key toClass:(Class)class {
    BSClassProvider *provider = [BSClassProvider providerWithClass:class injector:self];
    [self bind:key toProvider:provider];
}

- (void)bind:(id)key toClass:(Class)class withScope:(id<BSScope>)scope {
    [self bind:key toClass:class];
    [self bind:key withScope:scope];
}

- (void)bind:(id)key withScope:(id<BSScope>)scope {
    [self.scopes setObject:scope forKey:key];
}

- (void)injectInjector:(id)object {
    objc_property_t objc_property = class_getProperty([object class], "injector");
    if (objc_property == NULL) {
        return;
    }

    const char *attributes = property_getAttributes(objc_property);
    NSString *attrStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
    NSRange startRange = [attrStr rangeOfString:@"T@\"<BSInjector>\""];

    if (startRange.location != NSNotFound) {
        [object setValue:self forKey:@"injector"];
    }
}

- (id)getInstance:(id)key {
    return [self getInstance:key withArgs:nil];
}

- (id)getInstance:(id)key withArgs:(id)arg1, ... {
    NSMutableArray *args = [NSMutableArray array];
    if (arg1) {
        [args addObject:arg1];

        va_list argList;
        id arg = nil;
        va_start(argList, arg1);
        while ((arg = va_arg(argList, id))) {
            [args addObject:arg];
        }
        va_end(argList);
    }

    return [self getInstance:key withArgArray:args];
}

- (id)getInstance:(id)key withArgArray:(NSArray *)args {
    id<BSProvider> provider = [self.providers objectForKey:key];
    id<BSScope> scope = [self.scopes objectForKey:key];
    
    if (provider == nil && [key respondsToSelector:@selector(blindsideInitializer)]) {
        BSInitializer *initializer = [key performSelector:@selector(blindsideInitializer)];
        provider = [BSInitializerProvider providerWithInitializer:initializer injector:self];
    }
    
    if (provider && scope) {
        provider = [scope scope:provider];
    }

    id instance = [provider provide:args];
    [self injectInjector:instance];

    return instance;
}
@end
