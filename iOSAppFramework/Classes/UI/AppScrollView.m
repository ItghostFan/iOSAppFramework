//
//  AppScrollView.m
//  pandafit
//
//  Created by FanChunxing on 16/2/21.
//  Copyright © 2016年 pandafit. All rights reserved.
//

#import "AppView.h"

#import "AppScrollView.h"

@implementation AppScrollView

@end

@implementation UIScrollView(AppScrollView)

- (void)setScrollsToEnd:(BOOL)scrollsToEnd
{
    if (self.contentSize.height > self.height && scrollsToEnd) {
        CGPoint contentOffset = self.contentOffset;
        contentOffset.y = self.contentSize.height - self.height;
        [self setContentOffset:contentOffset animated:YES];
    }
}

- (BOOL)scrollsToEnd
{
    return self.height == self.contentSize.height - self.contentOffset.y ||
    self.contentSize.height < self.height;
}

- (void)scrollsToEndAnimation:(BOOL)animation
{
    if (self.contentSize.height > self.height) {
        CGPoint contentOffset = self.contentOffset;
        contentOffset.y = self.contentSize.height - self.height;
        [self setContentOffset:contentOffset animated:animation];
    }
}

@end
