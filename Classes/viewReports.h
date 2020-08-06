//
//  viewReports.h
//  BulwarkTW
//
//  Created by Terry Whipple on 1/25/16.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface viewReports : UIViewController <UIWebViewDelegate> {
    
    
    
    IBOutlet UITextField *txtSearch;
    IBOutlet UIWebView *webviewReports;
    IBOutlet UIWebView *webviewDetails;
    IBOutlet UIButton *closeButton;
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
