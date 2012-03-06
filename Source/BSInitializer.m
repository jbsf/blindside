#import "BSInitializer.h"

@interface BSInitializer ()
@property (nonatomic, assign) Class type;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) NSArray *argKeys;
@property (nonatomic, retain) NSMethodSignature *signature;
@end

@implementation BSInitializer

@synthesize type = type_, selector = selector_, argKeys = argKeys_, signature = signature_;

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
        self.argKeys = argumentKeys;    
        self.signature = [self.type instanceMethodSignatureForSelector:self.selector];
    }
    return self;
}
                          
- (void)dealloc {
    self.argKeys = nil;
    self.signature = nil;
    [super dealloc];
}

- (id)keyForArgumentAtIndex:(NSUInteger)index {
    return [self.argKeys objectAtIndex:index];
}

- (NSUInteger)numberOfArguments {
    return self.signature.numberOfArguments - 2;
}

- (id)perform {
    id instance = [self.type alloc];
    return [instance performSelector:self.selector];
}

- (id)performWithObject:(id)object {
    id instance = [self.type alloc];
    return [instance performSelector:self.selector withObject:object];    
}

@end
