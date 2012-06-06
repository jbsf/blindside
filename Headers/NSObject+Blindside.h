#import <Foundation/Foundation.h>

@class BSInitializer, BSPropertySet;
@protocol BSInjector;

@interface NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector;

+ (BSInitializer *)bsInitializer;

+ (BSPropertySet *)bsProperties;

@end
