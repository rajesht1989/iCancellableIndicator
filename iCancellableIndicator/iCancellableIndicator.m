//
//  CancellableIndicator.m
//  iCancellableIndicator
//
//  Created by Rajesh Thangaraj on 20/04/17.
//  Copyright © 2017 Rajesh Thangaraj. All rights reserved.
//

#import "iCancellableIndicator.h"

@interface iCancellableIndicator ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end


@implementation iCancellableIndicator

+ (iCancellableIndicator *)indicator {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([iCancellableIndicator class]) owner:nil options:nil] firstObject];
}

- (void)setState:(IndicatorState)state {
    _state = state;
    [_imageView setHidden:YES];
    [self setHidden:NO];
    switch (_state) {
        case kIndicatorRevolving :
            [_imageView setHidden:NO];
            [_button setImage:[UIImage imageNamed:@"stop.tiff"] forState:UIControlStateNormal];
            [self spinWithOptions: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction];
            break;
        case kReupload :
            [_button setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
            break;
        case kFailed :
            [_button setImage:[UIImage imageNamed:@"failed"] forState:UIControlStateNormal];
            break;
        case kHidden :
            [self setHidden:YES];
            break;
        default:
            break;
    }
}

- (void)spinWithOptions:(UIViewAnimationOptions) options {
    if ([_imageView isHidden] == NO) {
        [UIView animateWithDuration: 0.5f delay: 0.0f options: options animations: ^{
            _imageView.transform = CGAffineTransformRotate(_imageView.transform, M_PI / 2);
        } completion:^(BOOL finished) {
            if (finished) {
                [self spinWithOptions: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction];
            }
        }];
    }
}


- (IBAction)buttonAction:(id)sender {
    switch (_state) {
        case kIndicatorRevolving :
            [self setState:kReupload];
            break;
        case kReupload :
            [self setState:kIndicatorRevolving];
            break;
        case kFailed :
            if (_failedCallback) _failedCallback(self);
            break;
        default:
            break;
    }
}

@end
