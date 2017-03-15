//
//  UIScrollPage.h
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPage.h"

@interface UIScrollPage : UICollectionViewCell

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger rowCount;

- (void)registerItemView:(Class)itemViewClass;
- (void)reloadPage:(UIPage *)page selectedItems:(NSArray *)selectedItems;

#pragma mark - delegate

- (void)didSelected:(id)item;

@end
