//
//  viewSchedule.m
//  BulwarkTW
//
//  Created by Terry Whipple on 2/21/16.
//
//

#import "viewSchedule.h"
#import "BulwarkTWAppDelegate.h"


@interface viewSchedule ()

@end

@implementation viewSchedule{
    
    BulwarkTWAppDelegate *delegate;
    int refreshing;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD hide:YES];
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    webview.delegate = self;
    
    [self getSchedule];
    
    [webview.scrollView setScrollsToTop:YES];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webview.scrollView addSubview:refreshControl];
    
    
    
    // Do any additional setup after loading the view.
}


- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    
    if(refreshing==0){
       [HUD show:YES];
    }
    //[refreshControl beginRefreshing];
    //[webview setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
    if(refreshing==1){
   
    
        refreshing =0;
    [refreshControl endRefreshing];
    }else{
        
        [HUD hide:YES];
        
    }
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
   
    refreshing =1;
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptRouteSummary.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&build=41"];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webview loadRequest:srequest];
    
    
}

-(void)getSchedule{
    
    
    
    
    
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptRouteSummary.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&build=41"];
    
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webview loadRequest:srequest];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
