#import "NSObject+Blindside.h"
#import "BSInitializer.h"

@implementation NSObject(Blindside)

+ (BSInitializer *)blindsideInitializer {
    SEL selector = @selector(init);
    return [BSInitializer initializerWithClass:self selector:selector argumentKeys:nil];
}

@end
