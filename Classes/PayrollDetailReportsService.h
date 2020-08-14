//
//  CommissionReportsService.h
//  BulwarkTW
//
//  Created by Kole Pottorff on 8/10/20.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <UIKit/UIWebView.h>

@interface PayrollDetailReportsService : UIViewController <UIWebViewDelegate>{
    
    //IBOutlet UIWebView *webview;
    MBProgressHUD *HUD;
    IBOutlet UISegmentedControl *seg;
    
}
@property (nonatomic, strong) UIWebView *webView;
  //@property (atomic, strong)  UIAlertView *askOpenReport;
//- (UIAlertView *)askOpenReport;

 //@property (nonatomic, strong ) UIAlertView *askOpenReport;

-(void) openReport:(UIWindow *)window;
-  (void)  updatePushToken:(NSData *)pushToken: (NSString *) deviceIdUUID;
- (BOOL) techHasPendingCommisionReport;

@end
