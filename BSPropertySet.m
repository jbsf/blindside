#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSPropertySet ()
@property (nonatomic, retain) NSArray *properties;
@end

@implementation BSPropertySet

@synthesize properties = properties_;

+ (BSPropertySet *)propertySetWithClass:(Class)owningClass propertyNames:(NSString *)property1, ... {
    NSMutableArray *bsProperties = [NSMutableArray array];
    if (property1) {
        [bsProperties addObject:[BSProperty propertyWithClass:owningClass propertyName:property1]];
    }

    va_list argList;
    id propertyName = nil;
    va_start(argList, property1);
    while ((propertyName = va_arg(argList, id))) {
        [bsProperties addObject:[BSProperty propertyWithClass:owningClass propertyName:propertyName]];
    }
    va_end(argList);
    return [[[BSPropertySet alloc] initWithProperties:bsProperties] autorelease];
};

- (id)initWithProperties:(NSArray *)properties {
    if (self = [super init]) {
        self.properties = properties;
    }
    return self;
}

- (void)bindProperty:(NSString *)propertyName toKey:(id)key {
    for (BSProperty *property in self.properties) {
        if (property.propertyName == propertyName) {
            property.injectionKey = key;
        }
    }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    return [self.properties countByEnumeratingWithState:state objects:stackbuf count:len];
}

@end