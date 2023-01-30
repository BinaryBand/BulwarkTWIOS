//
//  viewReports.h
//  BulwarkTW
//
//  Created by Terry Whipple on 1/25/16.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface viewReports : UIViewController <UIWebViewDelegate,WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate> {
    
    
    
    IBOutlet UITextField *txtSearch;
    IBOutlet WKWebView *webviewReports;
    IBOutlet WKWebView *webviewDetails;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIView *popView;
    
    
    
    //MBProgressHUD *HUD;
    
}

@property (nonatomic,strong) NSString *url;


- (IBAction)btnCloseWindow;
- (IBAction)btnBack;


-(void)loadWebViewDetails:(NSString *)UrlString;
- (void)handleOpenURL:(NSURL *)url;


@end
