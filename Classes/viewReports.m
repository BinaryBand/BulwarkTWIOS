//
//  viewReports.m
//  BulwarkTW
//
//  Created by Terry Whipple on 1/25/16.
//
//

#import "viewReports.h"
#import "BulwarkTWAppDelegate.h"

@interface viewReports ()

@end

@implementation viewReports{
    BulwarkTWAppDelegate *delegate;
    //NSString *hrEmpId;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.viewRpt = self;
    
    
    [[popView layer] setCornerRadius:10];
    [popView  setClipsToBounds:YES];
    [[popView  layer] setBorderColor:
     [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor]];
    [[popView  layer] setBorderWidth:2.75];

    webviewDetails.hidden = YES;
    closeButton.hidden = YES;
    popView.hidden = YES;
    webviewDetails.delegate = self;
    webviewReports.delegate = self;
   
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD hide:YES];
    
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
    [HUD hide:YES];
}





-(void)loadWebViewDetails:(NSString *)UrlString{
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewDetails loadRequest:srequest];
    webviewDetails.hidden = NO;
    closeButton.hidden = NO;
    popView.hidden = NO;
}



- (void)handleOpenURL:(NSURL *)url {
    
    NSString *URLString = [url absoluteString];
    
    NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
    
    NSString *urlParamater = [paramater objectAtIndex: 2];
    
    NSString *spage =[paramater objectAtIndex: 1];
    
    double dpage = [spage doubleValue];
    
    
    
    if(dpage==1){ //base64 encoded url to load into popup webviewDetails
        
        
        NSString *site = urlParamater;
        [self loadWebViewDetails:site];
        
        
    }
    
    if(dpage==2){ //add to todays route
       
        NSString *UrlStr = @"https://www.bulwarktechnician.com/hh/retention/rptaddtoroute.aspx?customer_id=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        NSError *err = nil;
        
        NSString *html = [NSString stringWithContentsOfURL:qurl encoding:NSUTF8StringEncoding error:&err];
        
        if(err)
        {
            
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error Loading" message: @"Error Adding to route please contact support"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
            [someError show];
            
            
        }else{
            
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Done" message: html  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
            [someError show];
            
        }
        

        
    }
    
    
    
    
    
}



- (IBAction)btnSearch{
    
    NSString *txtbox =[txtSearch.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptsearch.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    UrlString = [UrlString stringByAppendingString:@"&t="];
    UrlString = [UrlString stringByAppendingString:txtbox];
    
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];

}
- (IBAction)btnDailyZone{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptdailyzone.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnProDormancy{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptproactivedormancy.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnProDelenquency{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptproactivedelinquency.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnDormantAccounts{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptdormantaccounts.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnRecentCancels{
    
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptrecentcancelsipad.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
   
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
     [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnRecentMoves{
    
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptrecentmoves.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnPool{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptpool.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    

    
}

- (IBAction)btnontime{
    
    
    
    NSString *UrlString = @"https://fbf.bulwarkapp.com/mgrapp/ontimetech.aspx?h=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
    
}

- (IBAction)btnNearMe{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptpoolloc.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnCancelBucket{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptbucketcancel.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}
- (IBAction)btnCloseWindow{
    webviewDetails.hidden = YES;
    closeButton.hidden = YES;
    popView.hidden = YES;
    
}
- (IBAction)btnBack{
    
    if([webviewDetails canGoBack]){
        [webviewDetails goBack];
    }
    
}

- (IBAction)btnGateCodes{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptgatecodes.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&long="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
    
}
- (IBAction)btnCompletion{
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptcompletionrate.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
}

- (IBAction)btnTMLeaderboard{
    
    
    NSString *UrlString = @"https://fbf.bulwarkapp.com/report/Tech24Month.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];
    UrlString = [UrlString stringByAppendingString:delegate.lat];
    UrlString = [UrlString stringByAppendingString:@"&lon="];
    UrlString = [UrlString stringByAppendingString:delegate.lon];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
    
    /*
    NSString *UrlString1 = @"https://www.bulwarktechnician.com/hh/retention/rptEmpId.aspx?hr_emp_id=";
    
    UrlString1 = [UrlString1 stringByAppendingString:delegate.hrEmpId];

    
    
    NSURL *url = [ NSURL URLWithString: UrlString1];
    NSURLRequest *req = [ NSURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
                                      timeoutInterval:30.0 ];
    NSError *err;
    NSURLResponse *res;
    NSData *d = [ NSURLConnection sendSynchronousRequest:req
                                       returningResponse:&res
                                                   error:&err ];
    if(err==nil){
    NSString *responseString = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    
    
        if(responseString.length >12){
            
            NSURL *qurl = [NSURL URLWithString:UrlString1];
            
            NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
            [webviewReports loadRequest:srequest];
            
            
        }else{
            
            NSString *UrlString = @"http://bulwarkadmin.com/branch/board?FKPersonnel_ID=";
            
            UrlString = [UrlString stringByAppendingString:responseString];
            
            
            
            NSURL *qurl = [NSURL URLWithString:UrlString];
            
            NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
            [webviewReports loadRequest:srequest];
            
            
            
        }

    
    }else{
        NSURL *qurl = [NSURL URLWithString:UrlString1];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [webviewReports loadRequest:srequest];
        
        
        
    }
    
    */
    
}







- (IBAction)btnTermiteFup{
    NSString *UrlString =  @"https://kpwebapi.bulwarkapp.com/payrollreports/employee?APIKEY=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=";
       
       UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
       UrlString = [UrlString stringByAppendingString:@"&lat="];
       UrlString = [UrlString stringByAppendingString:delegate.lat];
       UrlString = [UrlString stringByAppendingString:@"&lon="];
       UrlString = [UrlString stringByAppendingString:delegate.lon];
       
       
       NSURL *qurl = [NSURL URLWithString:UrlString];
       
       NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
       [webviewReports loadRequest:srequest];
       
       
    
    
    /*
    NSString *UrlString = @"https://www.bulwarktechnician.com/hh/retention/rptTermiteFUPList.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&lat="];

    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];

    */
    
    
    
    
    
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}














@end
