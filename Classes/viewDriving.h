//
//  viewDriving.h
//  BulwarkTW
//
//  Created by Terry Whipple on 4/11/16.
//
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface viewDriving : UIViewController <UIWebViewDelegate>{
    
    
    IBOutlet UIWebView *webview;
    MBProgressHUD *HUD;
    UIRefreshControl *refreshControl;
    IBOutlet UILabel *currSpeed;
    
}

-(void)UpdateSpeed:(NSString *)Speed;


@end
