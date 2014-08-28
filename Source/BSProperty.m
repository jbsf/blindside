#import <objc/runtime.h>
#import "BSProperty.h"

static NSString *const BSInvalidPropertyException = @"BSInvalidPropertyException";

@interface BSProperty ()
@property (nonatomic, weak) Class owningClass;
@property (nonatomic, weak, readwrite) Class returnType;
@property (nonatomic, strong, readwrite) NSString *propertyNameString;

- (id)initWithClass:(Class)owningClass propertyName:(NSString *)propertyName;
- (void)determineReturnType;

@end

@implementation BSProperty

@synthesize
owningClass  = _owningClass,
propertyNameString = _propertyNameString,
returnType   = _returnType,
injectionKey = _injectionKey;

+ (BSProperty *)propertyWithClass:(Class)owningClass propertyNameString:(NSString *)propertyNameString {
    return [[BSProperty alloc] initWithClass:owningClass propertyName:propertyNameString];
}

- (id)initWithClass:(Class)owningClass propertyName:(NSString *)propertyName {
    if (self = [super init]) {
        self.owningClass = owningClass;
        self.propertyNameString = propertyName;
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
    objc_property_t objc_property = class_getProperty(self.owningClass, [self.propertyNameString cStringUsingEncoding:NSUTF8StringEncoding]);
    if (objc_property == NULL) {
//        NSLog(@"================> %@", self.propertyNameString);
        [NSException raise:BSInvalidPropertyException
                    format:@"Property %@ not found on class %@", self.propertyNameString, self.owningClass, nil];
    }
    const char *attributes = property_getAttributes(objc_property);
    // a valid attributes string for an object property will look something like this: T@"Address",&,N,V_address
//    NSLog(@"================> %s", attributes);
    NSString *attrStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
    NSRange startRange = [attrStr rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound) {
        [NSException raise:BSInvalidPropertyException
                    format:@"Invalid property: %@ on class: %@. Return type is not an object.", self.propertyNameString,
                           self.owningClass, nil];
    }
    NSUInteger startPos = startRange.location + startRange.length;
    NSRange endRange = [attrStr rangeOfString:@"\"" options:0 range:NSMakeRange(startPos, attrStr.length - startRange.location - startRange.length)];
    if (endRange.location == NSNotFound) {
        [NSException raise:BSInvalidPropertyException
                    format:@"Invalid property: %@ on class: %@. Return type is not an object.", self.propertyNameString,
                           self.owningClass, nil];
    }
    NSString *className = [attrStr substringWithRange:NSMakeRange(startPos, endRange.location - startPos)];

    Class returnClass = NSClassFromString(className);
    self.returnType = returnClass;
}

@end