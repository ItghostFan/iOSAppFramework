//
//  AppViewController.m
//  iOSAppFramework
//
//  Created by ItghostFan on 07/02/2016.
//  Copyright (c) 2016 ItghostFan. All rights reserved.
//

#import "AppViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"

#import "UIColor+iOS.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad
{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
