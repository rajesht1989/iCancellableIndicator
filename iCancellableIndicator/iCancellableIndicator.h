//
//  CancellableIndicator.h
//  iCancellableIndicator
//
//  Created by Rajesh Thangaraj on 20/04/17.
//  Copyright © 2017 Rajesh Thangaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kIndicatorRevolving,
    kReupload,
    kFailed,
    kHidden
} IndicatorState;

@interface iCancellableIndicator : UIView

+ (iCancellableIndicator *)indicator;

@property (nonatomic, assign) IndicatorState state;
@property (copy) void (^failedCallback)(iCancellableIndicator *);


@end
