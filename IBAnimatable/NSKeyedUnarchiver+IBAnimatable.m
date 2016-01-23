//
//  Created by Lex on 1/21/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation NSKeyedUnarchiver (IBAnimatable)

- (void)iba_setValue:(id)value forUndefinedKey:(NSString *)key {
  if ([key isEqualToString:@"animationType"]) {
    [self setValue:value forKey:@"animationTypeRaw"];
  }
}

+ (void) load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL originalMethod = @selector( setValue:forUndefinedKey: );
    SEL swizzledMethod = @selector( iba_setValue:forUndefinedKey: );
    method_exchangeImplementations(
                                   class_getInstanceMethod( self, originalMethod ),
                                   class_getInstanceMethod( self, swizzledMethod )
                                   );
  });
}
@end
