//
//  ViewController.m
//  iCancellableIndicator
//
//  Created by Rajesh Thangaraj on 20/04/17.
//  Copyright © 2017 Rajesh Thangaraj. All rights reserved.
//

#import "ViewController.h"
#import "iCancellableIndicator.h"

@interface ViewController ()

@property (nonatomic, strong) iCancellableIndicator *indicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startProcessAction:(id)sender {
    [self.indicator setState:kIndicatorRevolving];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_indicator.state == kIndicatorRevolving && sender) {
            [_indicator setState:kFailed];
        }
    });
}

- (iCancellableIndicator *)indicator {
    if (_indicator == nil) {
        _indicator = [iCancellableIndicator indicator];
        [self.view addSubview:_indicator];
        [_indicator setFrame:self.view.bounds];
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        __weak id weakself = self;
        [_indicator setFailedCallback:^(iCancellableIndicator *indicator){
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"You want the recent screenshot to be reported?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [weakself presentViewController:actionSheet animated:YES completion:nil];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Upload again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself startProcessAction:nil];
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [indicator setState:kHidden];
            }]];

        }];
    }
    return _indicator;
}

@end
