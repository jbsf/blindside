#import <Foundation/Foundation.h>

@interface BSProperty : NSObject {
    Class     owningClass_;
    NSString *propertyName_;
    Class     returnType;
    id        injectionKey_;
}

@property (nonatomic, retain) NSString *propertyName;
@property (nonatomic, assign) Class returnType;
@property (nonatomic, retain) id injectionKey;

+ (BSProperty *)propertyWithClass:(Class)owningClass propertyName:(NSString *)propertyName;

- (id)initWithClass:(Class)owningClass propertyName:(NSString *)propertyName;
- (id)injectionKey;
@end