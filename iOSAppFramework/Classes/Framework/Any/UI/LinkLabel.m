//
//  LinkLabel.m
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/9/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "LinkLabel.h"

@interface LinkLabel ()
@property (strong, nonatomic) NSTextStorage *textStorage;
@end

@implementation LinkLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
    }
    return self;
}

#pragma mark - setter

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.textStorage = [[NSTextStorage alloc] initWithAttributedString:_attributedText];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textStorage = [[NSTextStorage alloc] initWithString:text];
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
    _textStorage = textStorage;
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [_textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    textContainer.lineFragmentPadding = 0.0f;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    [layoutManager addTextContainer:textContainer];
}

#pragma mark - self public

- (NSDictionary *)attributeAtPoint:(CGPoint)point {
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    textContainer.size = self.frame.size;
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:point
                                                       inTextContainer:textContainer
                              fractionOfDistanceBetweenInsertionPoints:nil];
    NSDictionary* textAttributes = [self.attributedText attributesAtIndex:indexOfCharacter effectiveRange:nil];
    return textAttributes;
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    __block CGRect textRect = CGRectZero;
    [layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        textRect = CGRectUnion(textRect, rect);
    }];
    return textRect.size;
}

- (void)sizeToFit {
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    __block CGRect textRect = CGRectZero;
    [layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        textRect = CGRectUnion(textRect, rect);
    }];
    CGRect frame = self.frame;
    frame.size = textRect.size;
    self.frame = frame;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, self.bounds);
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    textContainer.size = self.bounds.size;
    CGPoint textOffset = CGPointZero;
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

@end
