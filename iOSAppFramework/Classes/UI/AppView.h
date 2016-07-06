//
//  AppView.h
//  IosStudy
//
//  Created by FanChunxing on 16/1/30.
//  Copyright © 2016年 tt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppViewPropertyDelegate<NSObject>

@optional
- (void)view:(id)view hiddenChanged:(BOOL)hidden;

@end

@interface AppView : UIView

@end

@interface UIView(AppView)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize size;

- (UIImage *)snapshotImage:(CGRect)snapshotFrame
               scaleFactor:(CGFloat)scaleFactor;

@end
