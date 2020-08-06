//
//  ActivityAlertView.h
//  BulwarkTW
//
//  Created by Terry Whipple on 11/9/12.
//
//

#import <Foundation/Foundation.h>

@interface ActivityAlertView : UIAlertView
{
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void) close;

@end
