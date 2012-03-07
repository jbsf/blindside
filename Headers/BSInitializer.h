#import <Foundation/Foundation.h>

@interface BSInitializer : NSObject {
    Class type_;
    SEL selector_;
    NSArray *argumentKeys_;
    NSMethodSignature *signature_;
}

@property (nonatomic, retain) NSArray *argumentKeys;

+ (BSInitializer *)initializerWithClass:(Class)type selector:(SEL)selector argumentKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithClass:(Class)type selector:(SEL)selector argumentKeys:(NSArray *)argumentKeys;

- (NSUInteger)numberOfArguments;
- (id)keyForArgumentAtIndex:(NSUInteger)index;

- (id)perform:(NSArray *)argValues;

@end
