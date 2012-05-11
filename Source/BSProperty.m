#import <objc/runtime.h>
#import "BSProperty.h"

static NSString *const BSInvalidPropertyException = @"BSInvalidPropertyException";

@interface BSProperty ()
@property (nonatomic, weak) Class owningClass;
@property (nonatomic, weak, readwrite) Class returnType;
@property (nonatomic, strong, readwrite) NSString *propertyName;

- (id)initWithClass:(Class)owningClass propertyName:(NSString *)propertyName;
- (void)determineReturnType;

@end

@implementation BSProperty

@synthesize
owningClass  = _owningClass,
propertyName = _propertyName,
returnType   = _returnType,
injectionKey = _injectionKey;

+ (BSProperty *)propertyWithClass:(Class)owningClass propertyName:(NSString *)propertyName {
    return [[BSProperty alloc] initWithClass:owningClass propertyName:propertyName];
}

- (id)initWithClass:(Class)owningClass propertyName:(NSString *)propertyName {
    if (self = [super init]) {
        self.owningClass = owningClass;
        self.propertyName = propertyName;
        self.injectionKey = nil;
        [self determineReturnType];
    }
    return self;
}

- (id)injectionKey {
    if (_injectionKey) {
        return _injectionKey;
    };
    return self.returnType;
}

- (void)determineReturnType {
    objc_property_t objc_property = class_getProperty(self.owningClass, [self.propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    if (objc_property == NULL) {
//        NSLog(@"================> %@", self.propertyName);
        [NSException raise:BSInvalidPropertyException
                    format:@"Property %@ not found on class %@", self.propertyName, self.owningClass, nil];
    }
    const char *attributes = property_getAttributes(objc_property);
    // a valid attributes string for an object property will look something like this: T@"Address",&,N,V_address
//    NSLog(@"================> %s", attributes);
    NSString *attrStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
    NSRange startRange = [attrStr rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound) {
        [NSException raise:BSInvalidPropertyException
                    format:@"Invalid property: %@ on class: %@. Return type is not an object.", self.propertyName, self.owningClass, nil];
    }
    NSUInteger startPos = startRange.location + startRange.length;
    NSRange endRange = [attrStr rangeOfString:@"\"" options:0 range:NSMakeRange(startPos, attrStr.length - startRange.location - startRange.length)];
    if (endRange.location == NSNotFound) {
        [NSException raise:BSInvalidPropertyException
                    format:@"Invalid property: %@ on class: %@. Return type is not an object.", self.propertyName, self.owningClass, nil];
    }
    NSString *className = [attrStr substringWithRange:NSMakeRange(startPos, endRange.location - startPos)];

    Class returnClass = NSClassFromString(className);
    self.returnType = returnClass;
}

@end