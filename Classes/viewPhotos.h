//
//  viewPhotos.h
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/20.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"



NS_ASSUME_NONNULL_BEGIN

@interface viewPhotos : UIViewController <UIWebViewDelegate>{
    
    
    IBOutlet UIWebView *webview;
    MBProgressHUD *HUD;
    IBOutlet UISegmentedControl *seg;
    
    
}

@end

NS_ASSUME_NONNULL_END
