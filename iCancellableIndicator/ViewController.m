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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_indicator.state == kIndicatorRevolving) {
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
        [_indicator setFailedCallback:^(iCancellableIndicator *indicator){
            [indicator setState:kIndicatorRevolving];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (indicator.state == kIndicatorRevolving) {
                    [indicator setState:kHidden];
                }
            });
        }];
    }
    return _indicator;
}

@end
