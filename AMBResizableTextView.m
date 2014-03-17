//
//  AMBResizableTextView.m
//  AMBResizableTextView
//
//  Created by amb on 17/03/14.
//  Copyright (c) 2014 AMB. All rights reserved.
//

#import "AMBResizableTextView.h"

@implementation AMBResizableTextView

#pragma mark - Lazy instantiation

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.font = self.textViewFont;
        _textView.delegate = self;
        _textView.contentInset = UIEdgeInsetsZero;
        
        _textView.backgroundColor = [UIColor cyanColor];
    }
    return _textView;
}

- (UIFont *)textViewFont
{
    if (!_textViewFont) {
        _textViewFont = [UIFont systemFontOfSize:15];
    }
    return _textViewFont;
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    self.minHeight = 40.0;
    [self addSubview:self.textView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self calculateHeightWithTextView:textView];
}

- (void)calculateHeightWithTextView:(UITextView *)textView
{
    CGFloat height;
    // Hack to calculate the size under iOS 7
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        height = ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else {
        height = textView.contentSize.height;
    }
    [self resizeViewsWithHeight:height];
}

- (void)resizeViewsWithHeight:(CGFloat)height
{
    height = ceilf(height);
    CGFloat viewDiff = self.textView.frame.size.height - height;
    CGRect replyFrame = self.textView.frame;
    CGRect containerFrame = self.frame;
    if (height > self.minHeight && self.textView.hasText) {
        containerFrame.size.height -= viewDiff;
        containerFrame.origin.y += viewDiff;
        replyFrame.size.height = height;
    }
    else {
        containerFrame.size.height = self.minHeight;
        containerFrame.origin.y += (replyFrame.size.height - self.minHeight);
        replyFrame.size.height = self.minHeight;
    }
    
    self.textView.frame = replyFrame;
    self.frame = containerFrame;
}

@end
