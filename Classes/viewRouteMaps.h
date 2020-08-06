//
//  viewRouteMaps.h
//  BulwarkTW
//
//  Created by Terry Whipple on 2/18/16.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface viewRouteMaps : UIViewController <UIWebViewDelegate>{
    
    
    IBOutlet UIWebView *webview;
       MBProgressHUD *HUD;
    IBOutlet UISegmentedControl *seg;
    
    
}

-(IBAction)indexChanged:(UISegmentedControl *)sender;

- (void)handleOpenURL:(NSURL *)url;


@end
