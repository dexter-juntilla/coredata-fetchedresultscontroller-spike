//
//  Helper.m
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//

#import "Helper.h"

@implementation Helper

+ (CGFloat) getScreenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat) getScreenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (void) showLoader:(UIView *)view {
    UIView *screen = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = [screen center];
    spinner.hidesWhenStopped = YES;
    [screen addSubview:spinner];
    [spinner startAnimating];
    
    [view addSubview:screen];
}

+ (void) hideLoader:(UIView *)view {
    
}

@end
