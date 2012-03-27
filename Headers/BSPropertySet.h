#import <Foundation/Foundation.h>

#import <Foundation/NSEnumerator.h>

@interface BSPropertySet : NSObject<NSFastEnumeration> {
    Class owningClass_;
    NSMutableArray *properties_;
}

+ (BSPropertySet *)propertySetWithClass:(Class)owningClass propertyNames:(NSString *)property1, ... NS_REQUIRES_NIL_TERMINATION;

- (void)bindProperty:(NSString *)propertyName toKey:(id)key;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

@end