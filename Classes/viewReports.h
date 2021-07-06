//
//  viewReports.h
//  BulwarkTW
//
//  Created by Terry Whipple on 1/25/16.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>


@interface viewReports : UIViewController <UIWebViewDelegate,WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate> {
    
    
    
    IBOutlet UITextField *txtSearch;
    IBOutlet UIWebView *webviewReports;
    IBOutlet WKWebView *webviewDetails;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIView *popView;
    
    
    MBProgressHUD *HUD;
    
}


- (IBAction)btnSearch;
- (IBAction)btnDailyZone;
- (IBAction)btnProDormancy;
- (IBAction)btnProDelenquency;
- (IBAction)btnDormantAccounts;
- (IBAction)btnRecentCancels;
- (IBAction)btnRecentMoves;
- (IBAction)btnPool;
- (IBAction)btnNearMe;
- (IBAction)btnCancelBucket;
- (IBAction)btnCloseWindow;
- (IBAction)btnBack;
- (IBAction)btnGateCodes;
- (IBAction)btnCompletion;
- (IBAction)btnTMLeaderboard;
- (IBAction)btnTermiteFup;
- (IBAction)btnontime;

-(void)loadWebViewDetails:(NSString *)UrlString;
- (void)handleOpenURL:(NSURL *)url;


@end
