//
//  viewSchedule.h
//  BulwarkTW
//
//  Created by Terry Whipple on 2/21/16.
//
//

#import <UIKit/UIKit.h>
#import <Webkit/Webkit.h>
#import "MBProgressHUD.h"

@interface viewSchedule : UIViewController <UIWebViewDelegate,WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>{
    
    
    IBOutlet WKWebView *webview;
    MBProgressHUD *HUD;
    UIRefreshControl *refreshControl;
    IBOutlet WKWebView *mapWebView;
    IBOutlet UIButton *closeButton;
    
}

- (void)handleReload:(NSString *)url;

-(void) getSchedule;
- (IBAction)hideMap;
- (void)handleOpenURL:(NSURL *)url;

@end
