//
//  AppScrollPageView.m
//  iOSAppFramework
//
//  Created by FanChunxing on 16/11/1.
//  Copyright © 2017年 ItghostFan. All rights reserved.
//

#import "AppScrollPageView.h"

#import "AppScrollPage.h"

@interface AppScrollPageView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) UICollectionView *contentCollectionView;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) Class itemViewClass;

@property (weak, nonatomic) RACDisposable *itemDidSelectedDisposable;
@end

@implementation AppScrollPageView

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
    [self initContentCollectionView];
}

- (void)initRAC {
    
}

#pragma mark - self private

- (void)selfInit {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self initSubviews];
    [self initRAC];
}


- (void)initContentCollectionView {
    @weakify(self);
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = self.scrollDirection;
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    contentCollectionView.backgroundColor = UICOLOR_HEX(0x00000000);
    contentCollectionView.delegate = self;
    contentCollectionView.dataSource = self;
    contentCollectionView.allowsSelection = NO;
    contentCollectionView.pagingEnabled = YES;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentCollectionView];
    [contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
    [contentCollectionView registerClass:[AppScrollPage class] forCellWithReuseIdentifier:[AppScrollPage className]];
    self.contentCollectionView = contentCollectionView;
}

- (void)registerItemView:(Class)itemViewClass {
    self.itemViewClass = itemViewClass;
}

- (void)reloadData {
    [self.contentCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    AppScrollPage *scrollPage = (AppScrollPage *)cell;
    [scrollPage registerItemView:self.itemViewClass];
    scrollPage.columnCount = [self.delegate pageColumnCount:self];
    scrollPage.rowCount = [self.delegate pageRowCount:self];
    [scrollPage reloadPage:[self.delegate pageAt:indexPath] selectedItems:[self.delegate selectedItems:self]] ;
    
    @weakify(self);
    self.itemDidSelectedDisposable = [self racObserveSelector:@selector(didSelected:) object:scrollPage next:^(RACTuple *tuple) {
        RACTupleUnpack(id item) = tuple;
        @strongify(self);
        [self.delegate scrollPageView:self didSelected:item];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.itemDidSelectedDisposable dispose];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate pageCount:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:[AppScrollPage className] forIndexPath:indexPath];
}

@end