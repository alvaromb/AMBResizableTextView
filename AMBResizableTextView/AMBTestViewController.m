//
//  AMBTestViewController.m
//  AMBResizableTextView
//
//  Created by amb on 17/03/14.
//  Copyright (c) 2014 AMB. All rights reserved.
//

#import "AMBTestViewController.h"

@interface AMBTestViewController ()

@property (strong, nonatomic) AMBResizableTextView *resizableTextView;

@end

@implementation AMBTestViewController

#pragma mark - Lazy instantiation

- (AMBResizableTextView *)resizableTextView
{
    if (!_resizableTextView) {
        _resizableTextView = [[AMBResizableTextView alloc] initWithFrame:CGRectZero];
        
    }
    return _resizableTextView;
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrHideKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	[self.view addSubview:self.resizableTextView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat resizableTextViewHeight = 40.0;
    self.resizableTextView.frame = CGRectMake(0, self.view.frame.size.height - resizableTextViewHeight, self.view.frame.size.width, resizableTextViewHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard handling

- (void)showOrHideKeyboard:(NSNotification *)notification
{
    BOOL hidingKeyboard = [notification.name isEqualToString:UIKeyboardWillHideNotification];
    [self moveElementsHidingKeyboard:hidingKeyboard notification:notification];
}

- (void)moveElementsHidingKeyboard:(BOOL)hidingKeyboard
                      notification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSNumber *durationNumber = info[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationNumber.doubleValue;
    NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.integerValue;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self animateViewHidingKeyboard:hidingKeyboard keyboardFrame:kbFrame];
    [UIView commitAnimations];
}

- (void)animateViewHidingKeyboard:(BOOL)hidingKeyboard
                    keyboardFrame:(CGRect)keyboardFrame
{
    CGRect resizableFrame = self.resizableTextView.frame;
    if (hidingKeyboard) {
        resizableFrame.origin.y += keyboardFrame.size.height;
    }
    else {
        resizableFrame.origin.y -= keyboardFrame.size.height;
    }
    self.resizableTextView.frame = resizableFrame;
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
