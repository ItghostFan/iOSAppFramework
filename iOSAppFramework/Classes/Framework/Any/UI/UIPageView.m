//
//  UIPageView.m
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIPageView.h"

#import "UIPageItemView.h"

@interface UIPageView()
@property (assign, nonatomic) Class itemViewClass;
@end

@implementation UIPageView

#pragma mark - super

- (void)awakeFromNib {
    [super awakeFromNib];
    [self selfInit];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self selfInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self selfInit];
    }
    return self;
}

- (void)initRAC {
    
}

#pragma mark - self private

- (void)selfInit {
    [self initRAC];
}

#pragma mark - self public

#pragma mark - delegate

- (void)didSelected:(id)item {
}

#define COLUMN_SPACING 0
#define ROW_SPACING 0

- (void)setPage:(UIPage *)page columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount selectedItems:(NSArray *)selectedItems {
    [self layoutIfNeeded];
    for (NSInteger tag = 1; tag <= columnCount * rowCount; ++tag) {
        UIPageItemView *itemView = [self viewWithTag:tag];
        if (!itemView) {
            break;
        }
        itemView.hidden = YES;
    }
    
    for (NSInteger index = 0; index < page.source.count; ++index) {
        id item = [page.source objectAtIndex:index];
        CGFloat itemWidth = (CGRectGetWidth(self.frame) - ((columnCount + 1) * COLUMN_SPACING)) / columnCount;
        CGFloat itemHeight = (CGRectGetHeight(self.frame) - ((rowCount + 1) * ROW_SPACING)) / rowCount;
        NSUInteger row = index / columnCount;
        NSUInteger column = index % columnCount;
        UIPageItemView *itemView = [self viewWithTag:index + 1];
        if (!itemView) {
            itemView = [[self.itemViewClass alloc] init];
            [self addSubview:itemView];
            itemView.tag = index + 1;
            @weakify(self);
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self).offset((column + 1) * COLUMN_SPACING + (column * itemWidth));
                make.top.equalTo(self).offset((row + 1) * ROW_SPACING + (row * itemHeight));
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            @weakify(itemView);
            [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) {
                @strongify(self);
                @strongify(itemView);
                [self didSelected:itemView.item];
            }];
            [itemView addGestureRecognizer:tap];
        }
        [itemView setItem:item];
        itemView.hidden = NO;
    }
}

- (void)registerItemView:(Class)itemViewClass {
    if (!self.itemViewClass) {
        self.itemViewClass = itemViewClass;
    }
}

@end
