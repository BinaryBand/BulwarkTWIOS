//
//  viewRouteMaps.m
//  BulwarkTW
//
//  Created by Terry Whipple on 2/18/16.
//
//

#import "viewRouteMaps.h"
#import "BulwarkTWAppDelegate.h"


@interface viewRouteMaps ()

@end

@implementation viewRouteMaps{
    
    BulwarkTWAppDelegate *delegate;
  
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD hide:YES];
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    webview.delegate = self;
    
    delegate.viewMap = self;
    delegate.mapinit = @"1";
    
    
    if(delegate.mapDate.length==0){
        [self todaysroute];
        
    }else{
        [seg setSelectedSegmentIndex:UISegmentedControlNoSegment];
        NSString *UrlString = @"https://fbf.bulwarkapp.com/routemapipad.aspx?t=0&hr=";
        
        UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
        UrlString = [UrlString stringByAppendingString:@"&dt="];
        UrlString = [UrlString stringByAppendingString:delegate.mapDate];
        
        NSURL *qurl = [NSURL URLWithString:UrlString];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [webview loadRequest:srequest];
        
        
    }
    
    
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


-(IBAction)indexChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
         
            [self todaysroute];
            break;
        case 1:
            [self tomorrowsroute];
            break;
        default: 
            break; 
    } 
}



-(void)todaysroute{
    
    

    
    
    NSString *UrlString = @"https://fbf.bulwarkapp.com/routemapipad.aspx?t=1&hr=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];

    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webview loadRequest:srequest];
    
}

-(void)tomorrowsroute{
    
    
 
    
    
    NSString *UrlString = @"https://fbf.bulwarkapp.com/routemapipad.aspx?t=2&hr=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webview loadRequest:srequest];
    
}

- (void)handleOpenURL:(NSURL *)url {
    
    NSString *URLString = [url absoluteString];
    
    NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
    
    NSString *urlParamater = [paramater objectAtIndex: 2];
    
    NSString *spage =[paramater objectAtIndex: 1];
    
    double dpage = [spage doubleValue];
    
    
    
    if(dpage==1){ //base64 encoded url to load into popup webviewDetails
        
         [self.tabBarController setSelectedIndex:4];
        [seg setSelectedSegmentIndex:UISegmentedControlNoSegment];
        NSString *dt = urlParamater;
       
        
        
        NSString *UrlString = @"https://fbf.bulwarkapp.com/routemapipad.aspx?t=0&hr=";
        
        UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
         UrlString = [UrlString stringByAppendingString:@"&dt="];
        UrlString = [UrlString stringByAppendingString:dt];
        
        NSURL *qurl = [NSURL URLWithString:UrlString];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [webview loadRequest:srequest];
        
        
        
        
        
    }
    
    if(dpage==2){ //add to todays route
        
        
        
    }
    
    
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
