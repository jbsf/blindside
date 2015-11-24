#import <objc/runtime.h>
#import "BSProperty.h"

static NSString *const BSInvalidPropertyException = @"BSInvalidPropertyException";

@interface BSProperty ()
@property (nonatomic, strong) Class owningClass;
@property (nonatomic, strong, readwrite) id returnType;
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

- (_Nullable id)injectionKey {
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
    
    id returnType;
    NSString *typeName;
    if ([self isProtocolAttributeString:attrStr]) {
        NSArray *protocols = [self protocolsFromAttributeString:attrStr];
        for (NSString *protocolName in protocols) {
            id validProtocol = NSProtocolFromString(protocolName) ? : [self swiftProtocolForProtocolName:protocolName];
            if (!validProtocol) {
                [NSException raise:BSInvalidPropertyException
                            format:@"Invalid property: %@ on class: %@. Return type conforms to non-existent protocol: %@", self.propertyNameString, self.owningClass, protocolName];
            }
        }
        if (protocols.count == 1) {
            NSString *protocolName = [protocols firstObject];
            returnType = NSProtocolFromString(protocolName) ? : [self swiftProtocolForProtocolName:protocolName];
        }
    } else {
        typeName = [attrStr substringWithRange:NSMakeRange(startPos, endRange.location - startPos)];
        returnType = NSClassFromString(typeName) ? : [self swiftClassForClassName:typeName];
        if (!returnType) {
            [NSException raise:BSInvalidPropertyException
                        format:@"Invalid property: %@ on class: %@. Unable to find return type class: %@", self.propertyNameString, self.owningClass, typeName];
        }
    }

    self.returnType = returnType;
}


#pragma mark - Protocol Attrribute Parsing

- (NSArray *)protocolsFromAttributeString:(NSString *)attributesString {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^<]*>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        return nil;
    }
    NSArray *matches = [regex matchesInString:attributesString
                                      options:0
                                        range:NSMakeRange(0, attributesString.length)];
    NSMutableArray *protocols = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *result = [attributesString substringWithRange:match.range];
        NSArray *protocol = [[result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        if (protocol.count == 1 && [protocol firstObject] != nil) {
            [protocols addObject:[protocol firstObject]];
        }
    }
    return protocols;
}

- (BOOL)isProtocolAttributeString:(NSString *)attributeString {
    // a valid attributes string for an object property will look something like this: T@"<Protocol>",&,N,V_protocolsObject
    NSRange protocolRange = [attributeString rangeOfString:@"<"];
    return protocolRange.location != NSNotFound;
}


#pragma mark - Swift Support

- (Class)swiftClassForClassName:(NSString *)className {
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSString *bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"] ?: bundle.executablePath.lastPathComponent;
        Class swiftClass = NSClassFromString([NSString stringWithFormat:@"%@.%@", bundleName, className]);
        if (swiftClass) {
            return swiftClass;
        }
    }
    return nil;
}

- (id)swiftProtocolForProtocolName:(NSString *)protocolName {
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSString *bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"] ?: bundle.executablePath.lastPathComponent;
        id swiftProtocol = NSProtocolFromString([NSString stringWithFormat:@"%@.%@", bundleName, protocolName]);
        if (swiftProtocol) {
            return swiftProtocol;
        }
    }
    return nil;
}

@end