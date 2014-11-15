#import "BSInjectorImpl.h"
#import "BSBinder.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInstanceProvider.h"
#import "BSInitializer.h"
#import "BSScope.h"
#import "BSProperty.h"
#import "BSPropertySet.h"
#import "BSClassProvider.h"
#import "BSNull.h"
#import "NSObject+Blindside.h"
#import <objc/runtime.h>

@interface BSInjectorImpl ()

@property(nonatomic, strong) NSMutableDictionary *providers;
@property(nonatomic, strong) NSMutableDictionary *scopes;

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

- (void)bind:(id)key toInstance:(id)instance {
    BSInstanceProvider *provider = [BSInstanceProvider provider:instance];
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toProvider:(id<BSProvider>)provider {
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toBlock:(BSBlock)block {
    BSBlockProvider *provider = [BSBlockProvider providerWithBlock:block];
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toClass:(Class)class {
    BSClassProvider *provider = [BSClassProvider providerWithClass:class];
    [self bind:key toProvider:provider];
}

- (void)bind:(id)key toClass:(Class)class withScope:(id<BSScope>)scope {
    [self bind:key toClass:class];
    [self bind:key withScope:scope];
}

- (void)bind:(id)key withScope:(id<BSScope>)scope {
    [self setScope:scope forKey:key];
}

- (void)injectInjector:(id)object {
    objc_property_t objc_property = class_getProperty([object class], "injector");
    if (objc_property == NULL) {
        return;
    }

    const char *attributes = property_getAttributes(objc_property);
    NSString *attrStr = [NSString stringWithUTF8String:attributes];
    NSRange startRange = [attrStr rangeOfString:@"<BSInjector>"];

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
    id<BSProvider> provider = [self providerForKey:key];
    id<BSScope> scope = [self scopeForKey:key];

    if (provider && scope) {
        provider = [scope scope:provider];
    }

    if (provider == nil && ![BS_DYNAMIC isEqual:key]) {
        [NSException raise:@"BSNoProvider" format:@"Injector could not getInstance for key (%@) with args %@", key, args];
    }

    id instance = [provider provide:args injector:self];
    [self injectInjector:instance];

    return instance;
}

- (void)injectProperties:(id)instance {
    if ([[instance class] respondsToSelector:@selector(bsProperties)]) {
        BSPropertySet *propertySet = [[instance class] performSelector:@selector(bsProperties)];
        for (BSProperty *property in propertySet) {
            id value = [self getInstance:property.injectionKey];
            [instance setValue:value forKey:property.propertyNameString];
        }
    }
    [self injectInjector:instance];
}

- (void)setProvider:(id<BSProvider>)provider forKey:(id)key {
    [self.providers setObject:provider forKey:[self internalKey:key]];
}

- (id<BSProvider>)providerForKey:(id)key {
    id<BSProvider> provider = [self.providers objectForKey:[self internalKey:key]];
    
    if (provider == nil && [key respondsToSelector:@selector(bsInitializer)]) {
        BSInitializer *initializer = [key performSelector:@selector(bsInitializer)];
        if (initializer != nil) {
            provider = [BSInitializerProvider providerWithInitializer:initializer];
        }
    }
    
    if (provider == nil && [key respondsToSelector:@selector(bsCreateWithArgs:injector:)]) {
        __weak id this = self;
        provider = [BSBlockProvider providerWithBlock:^id(NSArray *args, id<BSInjector> injector) {
            return [key performSelector:@selector(bsCreateWithArgs:injector:) withObject:args withObject:this];
        }];
    }
    
    return provider;
}

- (void)setScope:(id<BSScope>)scope forKey:(id)key {
    [self.scopes setObject:scope forKey:[self internalKey:key]];
}

- (id<BSScope>)scopeForKey:(id)key {
    return [self.scopes objectForKey:[self internalKey:key]];
}

- (id)internalKey:(id)key {
    if ([NSStringFromClass([key class]) isEqualToString:@"Protocol"]) {
        return [NSString stringWithFormat:@"@protocol(%@)", NSStringFromProtocol(key)];
    }
    return key;
}

@end
