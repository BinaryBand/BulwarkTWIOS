//
//  viewSchedule.h
//  BulwarkTW
//
//  Created by Terry Whipple on 2/21/16.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface viewSchedule : UIViewController <UIWebViewDelegate>{
    
    
    IBOutlet UIWebView *webview;
    MBProgressHUD *HUD;
    UIRefreshControl *refreshControl;
    
}


@end
