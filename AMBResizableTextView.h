//
//  AMBResizableTextView.h
//  AMBResizableTextView
//
//  Created by amb on 17/03/14.
//  Copyright (c) 2014 AMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBTextView.h"

@interface AMBResizableTextView : UIView <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIFont *textViewFont;

@property (assign, nonatomic) CGFloat minHeight;

@end
