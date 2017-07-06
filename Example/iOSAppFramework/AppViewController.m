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

#import "UIColor+iOS.h"

#import "TestDatabase.h"

#import "JSONModel/JSONModel.h"

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

@end
