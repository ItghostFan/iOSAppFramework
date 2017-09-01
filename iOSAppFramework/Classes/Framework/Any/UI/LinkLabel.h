//
//  LinkLabel.h
//  iOSAppFramework
//
//  Created by FanChunxing on 2017/9/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkLabel : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) NSInteger numberOfLines;

- (NSDictionary *)attributeAtPoint:(CGPoint)point;

@end
