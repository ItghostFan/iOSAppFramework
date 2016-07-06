//
//  AppScrollView.h
//  pandafit
//
//  Created by FanChunxing on 16/2/21.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppScrollView : NSObject

@end


@interface UIScrollView(AppScrollView)

@property (nonatomic) BOOL scrollsToEnd;

- (void)scrollsToEndAnimation:(BOOL)animation;

@end