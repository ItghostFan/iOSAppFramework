//
//  NSAttributedString+Framework.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/9/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "NSAttributedString+Framework.h"

@implementation NSAttributedString (Framework)

- (CGRect)boundingRectWithSize:(CGSize)size
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
          maximumNumberOfLines:(NSUInteger)maximumNumberOfLines {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    textContainer.lineFragmentPadding = 0.0f;
    textContainer.lineBreakMode = lineBreakMode;
    textContainer.maximumNumberOfLines = maximumNumberOfLines;
    [layoutManager addTextContainer:textContainer];
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    __block CGRect textRect = CGRectZero;
    [layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        textRect = CGRectUnion(textRect, rect);
    }];
    return textRect;
}

@end
