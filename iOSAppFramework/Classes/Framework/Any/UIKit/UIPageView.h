//
//  UIPageView.h
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPage.h"

@interface UIPageView : UIView

- (void)setPage:(UIPage *)page columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount selectedItems:(NSArray *)selectedItems;
- (void)registerItemView:(Class)itemViewClass;

#pragma mark - delegate

- (void)didSelected:(id)item;

@end
