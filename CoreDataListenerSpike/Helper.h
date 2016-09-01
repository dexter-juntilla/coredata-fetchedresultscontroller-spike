//
//  Helper.h
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (CGFloat) getScreenWidth;
+ (CGFloat) getScreenHeight;
+ (void) showLoader:(UIView *)view;
+ (void) hideLoader:(UIView *)view;

@end
