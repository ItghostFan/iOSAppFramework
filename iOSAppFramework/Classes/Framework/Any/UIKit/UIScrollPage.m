//
//  UIScrollPage.m
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "UIScrollPage.h"

#import "Masonry/Masonry.h"
#import "NSObject+ReactiveCocoa.h"

#import "UIPageView.h"

@interface UIScrollPage()
@property (weak, nonatomic) UIPageView *pageView;
//@property (weak, nonatomic) UIPage *page;
@end

@implementation UIScrollPage

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

- (void)initSubviews {
    [self initPageView];
}

- (void)initRAC {
    @weakify(self);
    [self racObserveSelector:@selector(didSelected:) object:self.pageView next:^(RACTuple *tuple) {
        RACTupleUnpack(id item) = tuple;
        @strongify(self);
        [self didSelected:item];
    }];
}

- (void)selfInit {
    [self initSubviews];
    [self initRAC];
}

- (void)initPageView {
    @weakify(self);
    UIPageView *pageView = [UIPageView new];
    [self.contentView addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.contentView);
    }];
    self.pageView = pageView;
}

- (void)reloadPage:(UIPage *)page selectedItems:(NSArray *)selectedItems {
//    self.page = page;
    [self.pageView setPage:page columnCount:self.columnCount rowCount:self.rowCount selectedItems:selectedItems];
}

#pragma mark - self public

- (void)registerItemView:(Class)itemViewClass {
    [self.pageView registerItemView:itemViewClass];
}

#pragma mark - delegate

- (void)didSelected:(id)item {
}

@end
