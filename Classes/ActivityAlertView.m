//
//  ActivityAlertView.m
//  BulwarkTW
//
//  Created by Terry Whipple on 11/9/12.
//
//

#import "ActivityAlertView.h"

#import "ActivityAlertView.h"

@implementation ActivityAlertView

@synthesize activityView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[activityView startAnimating];
    }
	
    return self;
}

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}


@end