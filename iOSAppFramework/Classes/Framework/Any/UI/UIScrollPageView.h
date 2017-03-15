//
//  AppScrollPageView.h
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPage;
@class AppScrollPageView;

@protocol AppScroAppScrollPageViewDelegate <NSObject>
- (NSInteger)pageCount:(AppScrollPageView *)scrollPageView;
- (NSInteger)pageColumnCount:(AppScrollPageView *)scrollPageView;
- (NSInteger)pageRowCount:(AppScrollPageView *)scrollPageView;
- (UIPage *)pageAt:(NSIndexPath *)indexPath;
- (void)scrollPageView:(AppScrollPageView *)scrollPageView didSelected:(id)item;
- (NSArray *)selectedItems:(AppScrollPageView *)scrollPageView;
@end

@interface AppScrollPageView : UIView

@property (weak, nonatomic) id<AppScroAppScrollPageViewDelegate> delegate;

- (void)registerItemView:(Class)itemViewClass;
- (void)reloadData;

@end
