#import "NSObject+Blindside.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSPropertySet.h"
#import <objc/runtime.h>

static NSString *const BSMissingInitializerSpecificationException = @"BSMissingInitializerSpecificationException";

@implementation NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    id instance;

    @try {
        instance = [[self alloc] init];
    } @catch (NSException *exception) {
        BOOL isUnrecognizedSelectorException = ([exception.name isEqualToString:NSInvalidArgumentException] &&
                                                [exception.reason rangeOfString:@"unrecognized selector"].location != NSNotFound);
        if (!isUnrecognizedSelectorException) {
            @throw;
        }
    }

    if (!instance) {
        [NSException raise:BSMissingInitializerSpecificationException
                    format:@"Unable to create an instance of class %@ using -init. Override +bsInitializer to tell Blindside which initializer to use.", NSStringFromClass(self)];
    }

    [injector injectProperties:instance];
    return instance;
}

+ (BSInitializer *)bsInitializer {
    // NOTE: this 'if' clause is a Lumos Lab addition
    if ([self conformsToProtocol:@protocol(BSDependencyInjectable)]) {
        return [BSInitializer initializerWithClass:self selector:@selector(initWithDependencies:) argumentKeysArray:@[[self dependencyProvidingClass]]];
    }
    
    return nil;
}

+ (BSPropertySet *)bsProperties {
    // NOTE: this 'if' clause is a Lumos Labs addition
    if ([self conformsToProtocol:@protocol(BSDependencyProviding)]) {
        NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
        
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
        for (int propertyIndex = 0; propertyIndex < propertyCount; ++propertyIndex) {
            NSString *propertyName;
            NSString *propertyType;
            
            unsigned int attributeCount;
            objc_property_attribute_t *attributes = property_copyAttributeList(properties[propertyIndex], &attributeCount);
            for (int attributeIndex = 0; attributeIndex < attributeCount; ++attributeIndex) {
                objc_property_attribute_t attribute = attributes[attributeIndex];
                if (*attribute.name == 'T') {
                    propertyType = [@(attribute.value) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
                }
                else if (*attribute.name == 'V') {
                    propertyName = [@(attribute.value) substringFromIndex:1]; // cut off leading "_"
                }
            }
            free(attributes);
            
            if (propertyName && propertyType) {
                propertiesDict[propertyName] = propertyType;
            }
        }
        free(properties);
        
        NSArray *propertyNames = [propertiesDict allKeys];
        BSPropertySet *propertySet = [BSPropertySet propertySetWithClass:self propertyNamesArray:propertyNames];
        for (NSString *name in propertyNames) {
            NSString *type = propertiesDict[name];
            if ([type UTF8String][0] == '<') {
                type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
                [propertySet bindProperty:name toKey:NSProtocolFromString(type)];
            } else {
                [propertySet bindProperty:name toKey:NSClassFromString(type)];
            }
        }
        
        return propertySet;
    }
    
    return nil;
}

- (void)bsAwakeFromPropertyInjection {
    
}

#pragma mark - Lumos Labs additions

#pragma mark - BSDependencyInjectable

+ (Class)dependencyProvidingClass
{
    NSString *className = NSStringFromClass(self);
    return NSClassFromString([className stringByAppendingString:@"_Dependencies"]);
}

@end
