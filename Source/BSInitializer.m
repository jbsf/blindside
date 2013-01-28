#import "BSInitializer.h"
#import "BSNull.h"

#import <objc/runtime.h>

static NSString *const BSInvalidInitializerException = @"BSInvalidInitializerException";

@interface BSInitializer ()
@property (nonatomic, weak, readwrite) Class type;
@property (nonatomic) SEL selector;
@property (nonatomic) BOOL canAlloc;
@property (nonatomic, strong) NSMethodSignature *signature;
@property (nonatomic, strong, readwrite) NSArray *argumentKeys;

- (id)initWithClass:(Class)type selector:(SEL)selector argumentKeys:(NSArray *)argumentKeys;
- (id)nullify:(id)value;

@end

@implementation BSInitializer

@synthesize type = _type, selector = _selector, argumentKeys = _argumentKeys, signature = _signature;

+ (BSInitializer *)initializerWithClass:(Class)type selector:(SEL)selector argumentKeys:(id)firstKey, ... {
    NSMutableArray *argKeys = [NSMutableArray array];
    if (firstKey) {
        [argKeys addObject:firstKey];
        va_list argList;
        id argKey = nil;
        va_start(argList, firstKey);
        while ((argKey = va_arg(argList, id))) {
            [argKeys addObject:argKey];
        }
        va_end(argList);
    }

    return [[BSInitializer alloc] initWithClass:type selector:selector argumentKeys:argKeys];
}

- (id)initWithClass:(Class)type selector:(SEL)selector argumentKeys:(NSArray *)argumentKeys{
    if (self = [super init]) {
        self.type = type;
        self.selector = selector;
        self.argumentKeys = argumentKeys;
        self.canAlloc = YES;
        self.signature = [self.type instanceMethodSignatureForSelector:self.selector];
        if (self.signature == nil) {
            [NSException raise:BSInvalidInitializerException
                        format:@"selector %@ not found on class %@", NSStringFromSelector(self.selector), NSStringFromClass(self.type), nil];
        }
    }
    return self;
}

+ (BSInitializer *)initializerWithClass:(Class)type classSelector:(SEL)selector argumentKeys:(id)firstKey, ... {
    NSMutableArray *argKeys = [NSMutableArray array];
    if (firstKey) {
        [argKeys addObject:firstKey];
        va_list argList;
        id argKey = nil;
        va_start(argList, firstKey);
        while ((argKey = va_arg(argList, id))) {
            [argKeys addObject:argKey];
        }
        va_end(argList);
    }

    return [[BSInitializer alloc] initWithClass:type classSelector:selector argumentKeys:argKeys];
}

- (id)initWithClass:(Class)type classSelector:(SEL)selector argumentKeys:(NSArray *)argumentKeys {
    if (self = [super init]) {
        self.type = type;
        self.selector = selector;
        self.argumentKeys = argumentKeys;
        self.canAlloc = NO;
        self.signature = [self.type methodSignatureForSelector:self.selector];
        if (self.signature == nil) {
            [NSException raise:BSInvalidInitializerException
                        format:@"class selector %@ not found on class %@", NSStringFromSelector(self.selector), NSStringFromClass(self.type), nil];
        }

    }
    return self;
}

- (id)keyForArgumentAtIndex:(NSUInteger)index {
    return [self.argumentKeys objectAtIndex:index];
}

- (NSUInteger)numberOfArguments {
    return self.signature.numberOfArguments - 2;
}

- (id)target {
    if (self.canAlloc) {
        return [self.type alloc];
    }
    return self.type;
}

- (id)perform:(NSArray *)argValues {
    id obj = [self target];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:self.signature];
    [invocation setTarget:obj];
    [invocation setSelector:self.selector];

    for (int i = 0; i < self.numberOfArguments; i++) {
        id argValue = [self nullify:[argValues objectAtIndex:i]];
        [invocation setArgument:&argValue atIndex:(i + 2)];
    }

    [invocation invoke];

    if (!self.canAlloc) {
        __unsafe_unretained id instance;
        [invocation getReturnValue:&instance];
        obj = instance;
    }

    return obj;
}

- (id)nullify:(id)value {
    if (value == [BSNull null]) {
        return nil;
    }
    return value;
}

@end
