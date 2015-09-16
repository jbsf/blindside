#import "BSPropertySet.h"
#import "BSProperty.h"
#import "NSObject+Blindside.h"
#import "BSUtils.h"

#import <objc/runtime.h>

@interface BSPropertySet ()
@property (nonatomic, strong) Class owningClass;
@property (nonatomic, strong) NSMutableArray *properties;
@end

@implementation BSPropertySet

@synthesize owningClass = _owningClass, properties = _properties;

+ (BSPropertySet *)propertySetWithClass:(Class)owningClass propertyNamesArray:(NSArray *)propertyNames {
    NSMutableArray *bsProperties = [NSMutableArray array];
    for (NSString *propertyName in propertyNames) {
        [bsProperties addObject:[BSProperty propertyWithClass:owningClass propertyNameString:propertyName]];
    }

    BSPropertySet *propertySet = [[BSPropertySet alloc] initWithClass:owningClass properties:bsProperties];

    Class superclass = class_getSuperclass(owningClass);
    if (superclass != nil && [superclass respondsToSelector:@selector(bsProperties)]) {
        BSPropertySet *superclassPropertySet = [superclass performSelector:@selector(bsProperties)];
        [propertySet merge:superclassPropertySet];
    }

    return propertySet;
}

+ (BSPropertySet *)propertySetWithClass:(Class)owningClass propertyNames:(NSString *)property1, ... {
    NSMutableArray *propertyNames = [NSMutableArray array];
    AddVarArgsToNSMutableArray(property1, propertyNames);
    return [self propertySetWithClass:owningClass propertyNamesArray:propertyNames];
}

- (id)initWithClass:(Class)owningClass properties:(NSMutableArray *)properties {
    if (self = [super init]) {
        self.owningClass = owningClass;
        self.properties = properties;
    }
    return self;
}

- (void)bindProperty:(NSString *)propertyName toKey:(id)key {
    for (BSProperty *property in self.properties) {
        if ([property.propertyNameString isEqualToString:propertyName]) {
            property.injectionKey = key;
        }
    }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])stackbuf count:(NSUInteger)len {
    return [self.properties countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (BOOL)hasProperty:(BSProperty *)property {
    for (BSProperty *myProperty in self.properties) {
        if (myProperty.propertyNameString == property.propertyNameString) {
            return YES;
        }
    }
    return NO;
}

- (void)addProperty:(BSProperty *)property {
    [self.properties addObject:property];
}

- (void)merge:(BSPropertySet *)propertySet {
    for (BSProperty *property in propertySet.properties) {
        if (![self hasProperty:property]) {
            [self addProperty:property];
        }
    }
}

@end