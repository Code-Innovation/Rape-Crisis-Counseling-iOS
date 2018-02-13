//
//  RCCTextDecorator.h
//  RCC Guide
//
//  Created by Alexandr Afonin on 2/13/18.
//  Copyright © 2018 Afonin Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCTextDecorator : NSObject

- (void)appendBoldText:(NSString *)text
              hexColor:(unsigned long)hexCode
                  size:(float)size;

- (void)appendText:(NSString *)text
          hexColor:(unsigned long)hexCode
              size:(float)size;

- (NSAttributedString *)decoratedText;

@end
