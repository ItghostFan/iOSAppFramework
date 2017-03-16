//
//  UIScrollPageView.h
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPage;
@class UIScrollPageView;

@protocol UIScrollPageViewDelegate <NSObject>
- (NSInteger)pageCount:(UIScrollPageView *)scrollPageView;
- (NSInteger)pageColumnCount:(UIScrollPageView *)scrollPageView;
- (NSInteger)pageRowCount:(UIScrollPageView *)scrollPageView;
- (UIPage *)pageAt:(NSIndexPath *)indexPath;
- (void)scrollPageView:(UIScrollPageView *)scrollPageView didSelected:(id)item;
- (NSArray *)selectedItems:(UIScrollPageView *)scrollPageView;
@end

@interface UIScrollPageView : UIView

@property (weak, nonatomic) id<UIScrollPageViewDelegate> delegate;

- (void)registerItemView:(Class)itemViewClass;
- (void)reloadData;

@end
