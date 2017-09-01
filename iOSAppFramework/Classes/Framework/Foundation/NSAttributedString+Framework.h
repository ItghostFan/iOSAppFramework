//
//  NSAttributedString+Framework.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/9/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Framework)

- (CGRect)boundingRectWithSize:(CGSize)size
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
          maximumNumberOfLines:(NSUInteger)maximumNumberOfLines;

@end
