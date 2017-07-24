//
//  AppViewController.m
//  iOSAppFramework
//
//  Created by ItghostFan on 07/02/2016.
//  Copyright (c) 2016 ItghostFan. All rights reserved.
//

#import "AppViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "Masonry/Masonry.h"

#import "iOSAppFramework/UIImageView+Framework.h"

#import "UIColor+iOS.h"

#import "TestDatabase.h"

#import "JSONModel/JSONModel.h"
#import "UICustomView.h"

@interface TestJson
@property (strong, nonatomic) NSString<Optional> *data;
@end

@interface AppViewController ()

@property (strong, nonatomic) NSString *myName;

@property (strong, nonatomic) UIView *scaleView;
@property (assign, nonatomic) CGRect scaleFrame;
@property (strong, nonatomic) UIButton *largeButton;
@property (strong, nonatomic) UIButton *smallButton;
@property (strong, nonatomic) TestDatabase *database;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *clickButton;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UICustomView *customView;

@end

@implementation AppViewController

- (void)viewDidLoad
{
    TestJson *json;
    json.data = @"";
    @weakify(self);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    __block NSInteger colorIndex = 0;
    [[RACSignal interval:0.5f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        NSArray *bkgColors = @[UICOLOR_RGB(0x00FFFF), UICOLOR_RGBA(0x00FFFF7F),
                              UICOLOR_RGB(0xFFFF00), UICOLOR_RGBA(0xFFFF007F),
                              UICOLOR_RGB(0x00FF00), UICOLOR_RGBA(0x00FF007F)];
        colorIndex = colorIndex % bkgColors.count;
        self.view.backgroundColor = bkgColors[colorIndex];
        NSLog(@"%@", self.view.backgroundColor);
        ++colorIndex;
    }];
//    [[self.imageView loadCircleAvatarWith:@"http://www.rmzxb.com.cn/upload/resources/image/2017/07/24/1891820.jpg" placeHolder:nil] subscribeNext:^(id x) {
//    }];
//    [[self.imageView loadCircleGrayAvatarWith:@"http://www.rmzxb.com.cn/upload/resources/image/2017/07/24/1891820.jpg" placeHolder:nil] subscribeNext:^(id x) {
//    }];
//    [[self.imageView loadSquareAvatarWith:@"http://www.rmzxb.com.cn/upload/resources/image/2017/07/24/1891820.jpg" placeHolder:nil] subscribeNext:^(id x) {
//    }];
//    [[self.imageView loadCoverWith:@"http://www.rmzxb.com.cn/upload/resources/image/2017/07/24/1891820.jpg" placeHolder:nil] subscribeNext:^(id x) {
//    }];
//    [[self.imageView loadObliqueCoverWith:@"http://www.rmzxb.com.cn/upload/resources/image/2017/07/24/1891820.jpg" clipWidth:20.0f size:CGSizeMake(200.0f, 200.0f) side:UIIMAGE_OBLIQUE_TOP_LEFT placeHolder:nil] subscribeNext:^(id x) {
//    }];
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signalA concat:signalB] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[signalA then:^RACSignal *{
        return signalB;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[signalA merge:signalB] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[signalA combineLatestWith:signalB] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [[RACObserve(self, myName) flattenMap:^RACStream *(id value) {
        return [signalA concat:signalB];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
//    [[RACObserve(self, myName) flattenMap:^RACStream *(id value) {
//        return signalA;
//    } subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    self.myName = @"name";
    
    
    self.scaleView = [UIView new];
    self.scaleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scaleView];
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.0f, 100.0f));
    }];
    [self.view layoutIfNeeded];
    self.scaleFrame = self.scaleView.frame;
    
    self.largeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.largeButton setTitle:@"放大" forState:UIControlStateNormal];
    [self.view addSubview:self.largeButton];
    [self.largeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(50.0f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.0f, 20.0f));
    }];
    self.smallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.smallButton setTitle:@"缩小" forState:UIControlStateNormal];
    [self.view addSubview:self.smallButton];
    [self.smallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.largeButton.mas_bottom);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.0f, 20.0f));
    }];
    
    [[self.largeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self);
            self.scaleView.center = CGPointMake(CGRectGetMidX(self.scaleFrame), CGRectGetMidY(self.scaleFrame));
            CGAffineTransform transform = CGAffineTransformIdentity;
            self.scaleView.transform = transform;
        } completion:^(BOOL finished) {
        }];
    }];
    [[self.smallButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self);
            self.scaleView.center = CGPointMake(CGRectGetMaxX(self.scaleFrame), CGRectGetMaxY(self.scaleFrame));
            self.scaleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01f, 0.01f);
        }];
    }];
    
    for (int index = 0; index < 10; ++index) {
        [[self.database intoTable:[self rowBuilder]] subscribeNext:^(id x) {
            NSLog(@"Insert done!");
        }];
    }
    
    [[self.database queryTable] subscribeNext:^(NSArray<__kindof TestRow *> *result) {
        NSLog(@"%@", result);
    }];
    NSLog(@"Did!");
}

- (TestRow *)rowBuilder {
    TestRow *row = [TestRow new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss.sss";
    row.name = [formatter stringFromDate:[NSDate date]];
    row.columnDouble = @((double)random() / random());
    row.columnBool = @(YES);
    row.columnInt8 = @(random() % 0xFF);
    row.columnInt16 = @(random() % 0xFFFF);
    row.columnInt32 = @(random() % 0xFFFFFFFF);
    row.columnInt64 = @(random() % 0xFFFFFFFFFFFFFFFF);
    row.columnUInt8 = @(random() % 0xFF);
    row.columnUInt16 = @(random() % 0xFFFF);
    row.columnUInt32 = @(random() % 0xFFFFFFFF);
    row.columnUInt64 = @(random() % 0xFFFFFFFFFFFFFFFF);
    return row;
}

- (TestDatabase *)database {
    if (_database) {
        return _database;
    }
    _database = [TestDatabase new];
    return _database;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)nameLabel {
    if (_nameLabel) {
        return _nameLabel;
    }
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    _nameLabel.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _nameLabel.layer.cornerRadius = 10.0f;
    _nameLabel.layer.borderWidth = 0.5f;
    _nameLabel.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _nameLabel.text = @"测试一下看看";
    _nameLabel.textColor = UICOLOR_RGBA(0xFF000000);
    _nameLabel.shadowColor = UICOLOR_RGBA(0x00FF0000);
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = ({
        [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    });
    [self.view addSubview:_nameLabel];
    @weakify(self);
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(1, 1, 1, 1));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _nameLabel;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    _imageView.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _imageView.layer.cornerRadius = 10.0f;
    _imageView.layer.borderWidth = 0.5f;
    _imageView.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView.image = [UIImage imageNamed:@"bkg"];
    [self.view addSubview:_imageView];
    @weakify(self);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    }];
    return _imageView;
}

- (UIButton *)clickButton {
    if (_clickButton) {
        return _clickButton;
    }
    UIButton *clickButton = [[UIButton alloc] init];
    _clickButton = clickButton;
    _clickButton.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _clickButton.layer.cornerRadius = 10.0f;
    _clickButton.layer.borderWidth = 0.5f;
    _clickButton.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _clickButton.clipsToBounds = YES;
    _clickButton.contentEdgeInsets = ({
        UIEdgeInsetsMake(1, 1, 1, 1);
    });
    _clickButton.titleEdgeInsets = ({
        UIEdgeInsetsMake(1, 1, 1, 1);
    });
    _clickButton.imageEdgeInsets = ({
        UIEdgeInsetsMake(1, 1, 1, 1);
    });
    _clickButton.titleLabel.font = ({
        [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    });
    [_clickButton setTitle:@"测试" forState:UIControlStateNormal];
    [_clickButton setTitle:@"测试" forState:UIControlStateNormal];
    [_clickButton setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [_clickButton setTitleColor:UICOLOR_RGBA(0x00000000) forState:UIControlStateNormal];
    [_clickButton setTitleShadowColor:UICOLOR_RGBA(0x00000000) forState:UIControlStateNormal];
    [_clickButton setBackgroundImage:[UIImage imageNamed:@"bkg"] forState:UIControlStateNormal];
    [_clickButton setBackgroundImage:[UIImage imageNamed:@"bkg"] forState:UIControlStateNormal];
    [self.view addSubview:_clickButton];
    @weakify(self);
    [_clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(({
            UIEdgeInsetsMake(1, 1, 1, 1);
        }));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _clickButton;
}

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    _scrollView.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _scrollView.layer.cornerRadius = 10.0f;
    _scrollView.layer.borderWidth = 0.5f;
    _scrollView.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    @weakify(self);
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(({
            UIEdgeInsetsMake(1, 1, 1, 1);
        }));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _scrollView;
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:({	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout;
    })];
    _collectionView = collectionView;
    _collectionView.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _collectionView.layer.cornerRadius = 10.0f;
    _collectionView.layer.borderWidth = 0.5f;
    _collectionView.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _collectionView.clipsToBounds = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    [self.view addSubview:_collectionView];
    @weakify(self);
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(({
            UIEdgeInsetsMake(1, 1, 1, 1);
        }));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _collectionView;
}

- (UITextField *)textField {
    if (_textField) {
        return _textField;
    }
    UITextField *textField = [[UITextField alloc] init];
    _textField = textField;
    _textField.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _textField.layer.cornerRadius = 10.0f;
    _textField.layer.borderWidth = 0.5f;
    _textField.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _textField.clipsToBounds = YES;
    _textField.text = NSLocalizedString(@"测试一下看看", nil);
    _textField.textColor = UICOLOR_RGBA(0xFF000000);
    _textField.font = ({
        [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    });
    _textField.placeholder = NSLocalizedString(@"请输入XXX", nil);
    _textField.delegate = self;
    [self.view addSubview:_textField];
    @weakify(self);
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(({
            UIEdgeInsetsMake(1, 1, 1, 1);
        }));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _textField;
}

- (UICustomView *)customView {
    if (_customView) {
        return _customView;
    }
    UICustomView *customView = [[UICustomView alloc] init];
    _customView = customView;
    _customView.backgroundColor = UICOLOR_RGBA(0xFFFFFFFF);
    _customView.layer.cornerRadius = 10.0f;
    _customView.layer.borderWidth = 0.5f;
    _customView.layer.borderColor = UICOLOR_RGBA(0x00000000).CGColor;
    _customView.clipsToBounds = YES;
    [self.view addSubview:_customView];
    @weakify(self);
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(({
            UIEdgeInsetsMake(1, 1, 1, 1);
        }));
        make.width.mas_equalTo(100);
        make.height.equalTo(self.view).multipliedBy(1);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(-5);
    }];
    return _customView;
}


@end
