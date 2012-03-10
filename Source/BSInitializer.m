#import "BSInitializer.h"
#import "BSNull.h"

#import <objc/runtime.h>

@interface BSInitializer ()
@property (nonatomic, assign) Class type;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSMethodSignature *signature;

- (id)nullify:(id)value;

@end

@implementation BSInitializer

@synthesize type = type_, selector = selector_, argumentKeys = argumentKeys_, signature = signature_;

+ (BSInitializer *)initializerWithClass:(Class)type selector:(SEL)selector argumentKeys:(id)firstKey, ... {
    NSMutableArray *argKeys = [NSMutableArray array];
    if (firstKey) {
        [argKeys addObject:firstKey];
    }
    
    va_list argList;
    id argKey = nil;
    va_start(argList, firstKey);
    while ((argKey = va_arg(argList, id))) {
        [argKeys addObject:argKey];
    }
    va_end(argList);
    
    return [[[BSInitializer alloc] initWithClass:type selector:selector argumentKeys:argKeys] autorelease]; 
}

- (id)initWithClass:(Class)type selector:(SEL)selector argumentKeys:(NSArray *)argumentKeys{
    if (self = [super init]) {
        self.type = type;
        self.selector = selector;
        self.argumentKeys = argumentKeys;    
        self.signature = [self.type instanceMethodSignatureForSelector:self.selector];
    }
    return self;
}
                          
- (void)dealloc {
    self.argumentKeys = nil;
    self.signature = nil;
    [super dealloc];
}

- (id)keyForArgumentAtIndex:(NSUInteger)index {
    return [self.argumentKeys objectAtIndex:index];
}

- (NSUInteger)numberOfArguments {
    return self.signature.numberOfArguments - 2;
}

- (id)perform:(NSArray *)argValues {
    id instance = [self.type alloc];
    
    if (self.numberOfArguments == 0) {
        [instance performSelector:self.selector];        
    } else if (self.numberOfArguments == 1) {
        id argValue = [self nullify:[argValues objectAtIndex:0]];
        [instance performSelector:self.selector withObject:argValue];        
    } else if (self.numberOfArguments == 2) {
        id arg0Value = [self nullify:[argValues objectAtIndex:0]];
        id arg1Value = [self nullify:[argValues objectAtIndex:1]];
        [instance performSelector:self.selector withObject:arg0Value withObject:arg1Value];                
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:self.signature];
        [invocation setTarget:instance];
        [invocation setSelector:self.selector];

        for (int i = 0; i < self.numberOfArguments; i++) {
            id argValue = [self nullify:[argValues objectAtIndex:i]];
            [invocation setArgument:&argValue atIndex:(i + 2)];
        }
        
        [invocation invoke];
    }
    
    return instance;
}

- (id)nullify:(id)value {
    if (value == [BSNull null]) {
        return nil;
    }
    return value;
}

@end
