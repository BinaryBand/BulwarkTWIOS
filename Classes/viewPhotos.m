//
//  viewPhotos.m
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/20.
//

#import "viewPhotos.h"
#import "BulwarkTWAppDelegate.h"

@implementation viewPhotos{
    BulwarkTWAppDelegate *delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD hide:YES];
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    webview.delegate = self;
    

    
    
   
      
        NSString *UrlString = @"https://servicesnapshot.bulwarkapp.com?&hrempid=";
        
        UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];

        
        NSURL *qurl = [NSURL URLWithString:UrlString];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [webview loadRequest:srequest];
        
        
    
    
    
    // Do any additional setup after loading the view.
}


- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
    [HUD hide:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
