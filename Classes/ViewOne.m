//
//  ViewOne.m
//  BulwarkTW
//
//  Created by Terry Whipple on 12/28/10.
//  Copyright 2010 bulwark. All rights reserved.
//

#import "ViewOne.h"

//#import "Socket.h"
//#import "GKAchievementHandler.h"
//#import "AsyncSocket.h"
//#import "iToast.h"

//#include <stdio.h>
//#include <errno.h>
//#include <stdlib.h>
//#include <unistd.h>
//#include <sys/types.h>
//#include <sys/socket.h>
//#include <netinet/in.h>
//#include <netdb.h>

//#include <dlfcn.h>

//#include <ifaddrs.h>
//#include <arpa/inet.h>

//#import <net/if.h> // For IFF_LOOPBACK
//#import "MBProgressHUD.h"
//#import "ZipArchive/ZipArchive.h"
//#import "MKNumberBadgeView.h"
#import <BulwarkTW-Swift.h>
#import "BulwarkTWAppDelegate.h"
//#import "JDFTooltips.h"
#import "UIView+Toast.h"

#define app ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class Toast;
@class StringFetcher;

@implementation ViewOne{
    
    NSString *GpsString;
    BulwarkTWAppDelegate *delegate;
    NSString *photoAccount;
    NSString *photoType;
    BOOL driving;
    
    CGPoint RWVpt;
    BOOL backgroundLoadingRoute;
    BOOL checkFastcomm;
    int ISTSval;
    
}


//@synthesize CurrentFile,appBuild,Rurl;
//@synthesize hrEmpId;
//@synthesize empName;
//@synthesize rdate;
//@synthesize locationManager=_locationManager;

//@synthesize location=_location;

NSString *popWebViewUrl = @"";

int cnt = 0;
NSString *incommingData = @"";
NSString *Termitedata = @"";


- (NSString *)CurrentAppBuild{
return @"60";
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    //NSString *temp = StringFetcher.
    /*
    if (@available(iOS 15, *)) {
        // iOS 11 (or newer) ObjC code
    } else {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
        self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
    }
*/
    
    ISTSval = 0;
    
    backgroundLoadingRoute = false;
    
    
    
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.viewOne = self;
    
    
    lblFastCommPP.userInteractionEnabled = YES;
    lblFastCommMTD.userInteractionEnabled = YES;
    
   // UITapGestureRecognizer *tapGesturexx =
    //[[UITapGestureRecognizer alloc] initWithTarget:self
    //                                        action:@selector(fcTooltipPP)];
    //[lblFastCommPP addGestureRecognizer:tapGesturexx];
    
     configuration = [[WKWebViewConfiguration alloc] init];
    controllerweb = [[WKUserContentController alloc] init];
    
    
    [controllerweb addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controllerweb;
    
    
    [printIcon setTintColor: [UIColor clearColor]];
    printIcon.enabled = NO;
    gpsIcon.enabled = NO;
   [gpsIcon setTintColor: [UIColor clearColor]];
    
    driving = NO;
    
    
   // webView = [[WKWebView alloc] initWithFrame:CGRectMake(300,64, 467, 867)
    //                              configuration:configuration];
    
    //webView = [[WKWebView alloc]init] ;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    //webView.frame = CGRectMake(300,64, 467, 909);
    //[self.view addSubview:webView];

    //RouteWebView = [[WKWebView alloc]init] ;
    RouteWebView.UIDelegate = self;
    RouteWebView.navigationDelegate = self;
    //RouteWebView.frame = CGRectMake(0,161, 300, 812);
    //[self.view addSubview:RouteWebView];
    
    
    //PopUpWebView = [[WKWebView alloc]init] ;
    PopUpWebView.UIDelegate = self;
    PopUpWebView.navigationDelegate = self;
   // PopUpWebView.frame = CGRectMake(75,102, 630, 830);
    //[self.view addSubview:PopUpWebView];
    
    
    
    GpsString = @"";
    [[PopUpWebView layer] setCornerRadius:10];
    [PopUpWebView setClipsToBounds:YES];
    [[PopUpWebView layer] setBorderColor:
     [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor]];
    [[PopUpWebView layer] setBorderWidth:2.75];
    [super viewDidLoad];
    
    //[[webView layer] setCornerRadius:10];
    [webView setClipsToBounds:YES];
    [[webView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[webView layer] setBorderWidth:1];
    webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //webView.scrollView.contentInset = UIEdgeInsetsZero;
    
    
    //[[RouteWebView layer] setCornerRadius:10];
   [RouteWebView setClipsToBounds:YES];
   [[RouteWebView layer] setBorderColor:[[UIColor blackColor] CGColor]];
[[RouteWebView layer] setBorderWidth:1];
    RouteWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    

    
    self.printManager = [TWBlunoManager sharedInstance];
    self.printManager.delegate = self;
    self.printDevices = [[NSMutableArray alloc] init];

    
    //[toolbar setTintColor:[UIColor blueColor]];
 
    
    
    [self.printManager scan];


    
    //UD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view addSubview:HUD];
    //[HUD show:YES];
    
    
    [self.view makeToastActivity:CSToastPositionCenter];
    
   // HUD.detailsLabelText = @"Double tap to cancel";
    delegate.hrEmpId = @"";
    
    
    
    myTabBar.delegate = self;
    
    

    
    
    
    
    
    //myTabBar.items.
   // MKNumberBadgeView *numberBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(230,-51,40,40)];
    //numberBadge.value = 5;
    //[self.view addSubview:numberBadge];
    
    [RouteWebView.scrollView setScrollsToTop:YES];
    
    

    PopUpWebView.hidden = YES;
    [PopUpWebView loadHTMLString:@"" baseURL:nil];
    //[PopUpWebView setDelegate:self];
    //PopUpWebView.UIDelegate = self;
    //textView.frame.size.width = width;
    
    
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *newDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];
	
	// Check if the directory already exists
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory]) {
		// Directory does not exist so create it
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *newDirectory1 = [NSString stringWithFormat:@"%@/gps", [paths1 objectAtIndex:0]];
	
	// Check if the directory already exists
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory1]) {
		// Directory does not exist so create it
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory1 withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
    
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        
    }
    else {
       
     NSString *spage = @"";
     
     spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
     
     
     
     NSString *decoded = [self Highlite:spage];
     
     
     NSURL *qurl = [NSURL URLWithString:decoded];
     
     NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        
        
    
        
        
        
        
        
        NSString *path4=@"";
        
        

            
            path4 = [[NSBundle mainBundle]
                     pathForResource:@"blank"
                     ofType:@"html"];
            
        
        
		NSURL *urlq = [NSURL fileURLWithPath:path4];
		
		
		
		NSString *theAbsoluteURLString = [urlq absoluteString];

		
		
		
		NSURL *finalURL = [NSURL URLWithString: theAbsoluteURLString];
		
		NSURLRequest *brequest = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		
        
        
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //{
            
            [RouteWebView loadRequest:srequest];
            [webView loadRequest:brequest];
       // }else{
       //     [webView loadRequest:srequest];
        //}

     
    }
		
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [RouteWebView.scrollView addSubview:refreshControl];

    

    
	
	[NSThread detachNewThreadSelector:@selector(sendFilesToServer) toTarget:self withObject:nil];  
	

    



    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"settings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
       //[self LoadSettings];
    }else{
        
        [self getSettings];
    }
    
    //NSString *hremptest = delegate.hrEmpId;
    
    if ([delegate.hrEmpId length] != 0){
        [FIRAnalytics setUserID:delegate.hrEmpId];
        
        //[HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
        
        [NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
        
    }
        
    
    
    
    [self fastcommcheck];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(fastcommcheck) userInfo:nil repeats:YES];
    //[self LoadSettings];
    //return YES;
    [NSThread detachNewThreadSelector:@selector(getfastcommIsTS) toTarget:self withObject:nil];
    
     [NSThread detachNewThreadSelector:@selector(getfastcommMTD) toTarget:self withObject:nil];
    

    [NSTimer scheduledTimerWithTimeInterval:900.0 target:self selector:@selector(getfastcommMTD) userInfo:nil repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(loadInBackground) userInfo:nil repeats:YES];
    

    
    
    //[self connectWebSocket];
    
    
    
    
    
    
    
}

-(void)getSettings{
    
    
    
    delegate.hrEmpId = @"12345";
    delegate.name = @"";
    //delegate.password = @"";
    delegate.license = @"";
    delegate.office = @"";
    delegate.phone = @"";
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"settings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        
    }
    else {
        
        
        NSString *settingsFile = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        NSArray *paramater2 = [settingsFile componentsSeparatedByString:@"$"];
        
        delegate.name = [paramater2 objectAtIndex: 0];
        
        delegate.hrEmpId = [paramater2 objectAtIndex: 1];
        
        //delegate.password = [paramater2 objectAtIndex: 2];
        @try {
            delegate.license = [paramater2 objectAtIndex: 3];
            
            delegate.office = [paramater2 objectAtIndex: 4];
            delegate.phone = [paramater2 objectAtIndex: 5];
        }
        @catch (NSException * e) {
            //NSString *except =	@"office";
            
            
        }
        
        
        
    }

    if([delegate.office length] == 0){
        delegate.office = @"ME";
    }
    if([delegate.name length] == 0){
        delegate.name = @"";
    }
    if([delegate.hrEmpId length] == 0){
        delegate.hrEmpId = @"12345";
    }
    if([delegate.license length] == 0){
        delegate.license = @"";
    }
    if([delegate.phone length] == 0){
        delegate.phone = @"";
    }
    
    
    
}


-(void)cycleTheGlobalMailComposer
{
    // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    //[HUD show:YES];
    
    [self.view makeToastActivity:CSToastPositionCenter];
    
    [NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
    [refresh endRefreshing];
}





- (void)startup:(NSTimer *)theTimer{
    [NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
}

- (void)countdownTracker:(NSTimer *)theTimer {
    [NSThread detachNewThreadSelector:@selector(sendFilesToServer) toTarget:self withObject:nil];
    
    //textView.text = [textView.text stringByAppendingString:[self CurrentTime]];
    //textView.text = [textView.text stringByAppendingString:@"\n"];
}



-(void)fastcommcheck{
    
    
    [self checkFastcommEight];
    [self checkFastCommThree];
    
    
}


-(BOOL)CheckIfClicked{
    
    
    
    NSString *UrlStr = @"https://fbf2.bulwarkapp.com/Fastcomm/checkfastcommexist.ashx?hr_emp_id=";
    
    UrlStr = [UrlStr stringByAppendingString:delegate.hrEmpId];
    
    
    
    //NSString* link = UrlStr;
    //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:0 timeoutInterval:5];
    //NSURLResponse* response=nil;
    //NSError* error=nil;
    //NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* stringFromServer =[self getStringFromSite:UrlStr];
    
    
    int ISTSvalue = [stringFromServer intValue];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 13];
    [components setMinute: 00];
    [components setSecond: 00];
    
    NSDate *firstDate = [gregorian dateFromComponents: components];
    
    //NSDate *firstdate
    
    NSDate *secondDate = [NSDate date];
    
    
    
    if( [secondDate timeIntervalSinceDate:firstDate] > 0 ) {
        
        
        //[btnFastComm setTitle:@"$5 Guaranteed"];
        if(ISTSvalue==2){
           
            return NO;
            
            
        }else{
            return YES;
        }
        
        
    }else{
        
        if(ISTSvalue==1){
            
            return NO;
            
            
        }else{
            return YES;
        }
        
    }
    
    
    
    
    
    
}

-(IBAction)btnFastComm{
    
    
    if([self CheckIfClicked]){
        
        
        
        
        
        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
        [components setHour: 8];
        [components setMinute: 30];
        [components setSecond: 00];
        
        NSDate *firstDate = [gregorian dateFromComponents: components];
        
        //NSDate *firstdate
        
        NSDate *secondDate = [NSDate date];
        NSString *fastCommMessage = @"This may extend my route for services by one hour today. \n\nThe office will not call me for further permission. \n\n$30 for IS or 13 for CB and 5$ for accepting, only if a Service is added today. \n\nPress the button before 8:30AM to guarantee $5 tomorrow.";
        NSString *FastTitle = @"$35 Fast Commissions";
        
        
        if(ISTSval == 1){
            fastCommMessage = @"This may extend my route for services by one hour today. \n\nThe office will not call me for further permission. \n\n$35 for IS or 13 for CB and 5$ for accepting, only if a Service is added today. \n\nPress the button before 8:30AM to guarantee $5 tomorrow.";
            FastTitle = @"$40 Fast Commissions";
        }
        
        if( [firstDate timeIntervalSinceDate:secondDate] > 0 ) {
            
      fastCommMessage = @"This may extend my route by one hour today. \n\nThe office will not call me for further permission. \n\n$5 Guaranteed just for accepting and \n$30 Commissions if an IS is added to your route. /n$13 Commissions for a CB or urgent Regular service";
            
            if(ISTSval == 1){
                fastCommMessage = @"This may extend my route by one hour today. \n\nThe office will not call me for further permission. \n\n$5 Guaranteed just for accepting and \n$35 Commissions if an IS is added to your route. /n$13 Commissions for a CB or urgent Regular service";
             
            }
            
        }
        
        
        
        
        
        NSDate *date1 = [NSDate date];
        NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *components1 = [gregorian1 components: NSUIntegerMax fromDate: date1];
        [components1 setHour: 13];
        [components1 setMinute: 00];
        [components1 setSecond: 00];
        
        NSDate *firstDate1 = [gregorian1 dateFromComponents: components1];
        
        //NSDate *firstdate
       
        
        
        
        if( [secondDate timeIntervalSinceDate:firstDate1] > 0 ) {
            
        fastCommMessage = @"This may extend my route for TOMORROW for services by one hour. \n\nThe office will not call me for further permission. \n$5 Guaranteed just for accepting and \n$30 for IS or $13for CB if an service is added to your route.";
            if(ISTSval == 1){
                fastCommMessage = @"This may extend my route for TOMORROW for services by one hour. \n\nThe office will not call me for further permission. \n$5 Guaranteed just for accepting and \n$35 for IS or $13for CB if an service is added to your route.";
                
            }
            
            
        }

        
        
        
  
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:FastTitle message:fastCommMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            
            
            NSString *UrlStr = @"https://fbf2.bulwarkapp.com/Fastcomm/FastCommSubmit.ashx?hr_emp_id=";
            
            UrlStr = [UrlStr stringByAppendingString:self->delegate.hrEmpId];
            UrlStr = [UrlStr stringByAppendingString:@"&v=1&t="];
            
            NSDate *date = [NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
            [components setHour: 13];
            [components setMinute: 00];
            [components setSecond: 00];
            
            NSDate *firstDate = [gregorian dateFromComponents: components];
            
            //NSDate *firstdate
            
            NSDate *secondDate = [NSDate date];
            
            
            
            if( [secondDate timeIntervalSinceDate:firstDate] > 0 ) {
                
                
                //[btnFastComm setTitle:@"$5 Guaranteed"];
                
                UrlStr = [UrlStr stringByAppendingString:[self CurrentFastCommTomorrow]];
                
                

            }else{
                
                UrlStr = [UrlStr stringByAppendingString:[self CurrentTimeUrl]];
                
            }
            
            
            
            
            NSString* link = UrlStr;
            //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:0 timeoutInterval:5];
            //NSURLResponse* response=nil;
            //NSError* error=nil;
            //NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            //NSString* stringFromServer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString* ret = [self getStringFromSite:link];
            
            
            NSArray *items = [ret componentsSeparatedByString:@"-"];   //take the one array for split the string
            NSString *mtd1 = @"0";
            NSString *pp1 = @"0";
            
            if(items.count == 2){
                mtd1 =[items objectAtIndex:0];
                pp1 = [items objectAtIndex:1];
            }else{
                
                mtd1 = ret;
                
            }
            
            
            
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *myNumber = [f numberFromString:mtd1];
            
            
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            NSString *mtdvalue = [formatter stringFromNumber:myNumber];
            
            
            
            NSNumberFormatter *f1 = [[NSNumberFormatter alloc] init];
            f1.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *myNumber1 = [f1 numberFromString:pp1];
            
            
            
            NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
            [formatter1 setNumberStyle:NSNumberFormatterCurrencyStyle];
            NSString *ppvalue = [formatter1 stringFromNumber:myNumber1];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self->lblFastCommMTD.text = [mtdvalue stringByAppendingString:@" MTD"];
                self->lblFastCommPP.text = [ppvalue stringByAppendingString:@" Due"];
            });
            
            //NSInteger *ISTSvalue = [stringFromServer intValue];
            
            

            
            
            
            
           
            
            
            
            
            
          
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
           
        }]];
        [self presentViewController:alertController animated:YES completion:^{}];
        

        
    
        
        
        
        
        
        
        
    
    
    }else{
        
        [self MsgBoxShow:@"Fast Commissions Already Clicked" withMessage:@"You can only click for fast comm once per day, you can click for tomorrow as early as 3pm the today" withButtonLabel:@"Ok"];
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fast Commissions Already Clicked" message:@"You can only click for fast comm once per day, you can click for tomorrow as early as 3pm the today" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        //[alert show];
        
        
        
        
    }
        
        
}

    -(void)getfastcommIsTS{
        
        NSString *UrlStr = @"https://fbf2.bulwarkapp.com/Fastcomm/getists.ashx?hr_emp_id=";
        
        UrlStr = [UrlStr stringByAppendingString:delegate.hrEmpId];
        
        
        
       // NSString* link = UrlStr;
       // NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:0 timeoutInterval:5];
        //NSURLResponse* response=nil;
        //NSError* error=nil;
       // NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString* stringFromServer = [self getStringFromSite:UrlStr];
        
        int ISTSvalue = [stringFromServer intValue];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            
            
            if(ISTSvalue  == -1){
                self->ISTSval = 0;
                //lblFastCommMessage.text = @"To qualify for fast comm your schedule needs to be avaliable for services at least till 5";
                self->lblFastCommMessage.hidden = NO;
                
                self->lblFastCommMTD.hidden = YES;
                self->   lblFastCommPP.hidden = YES;
                self->lblFastComValue.hidden = YES;
                self->lblfastcommlbl.hidden = YES;
                self->btnFastComm.hidden = YES;
                self->moneyimg.hidden = YES;
                
            }else{
                
                self->lblFastCommMessage.hidden = YES;
                
                self->lblFastCommMTD.hidden = NO;
                self->lblFastCommPP.hidden = NO;
                self->lblFastComValue.hidden = NO;
                self->lblfastcommlbl.hidden = NO;
                self->btnFastComm.hidden = NO;
                self->moneyimg.hidden = NO;
                
               // btnFastComm.layer.borderWidth = 1.0f;
                
                
               // btnFastComm.layer.borderColor = [UIColor blueColor].CGColor;
                
                
                //btnFastComm.layer.cornerRadius = 4.0f;
                
                
                
                
                
            }
            
            if(ISTSvalue==1){
                 self->ISTSval = 1;
                self->lblFastComValue.text = @"$40 Per IS";
                
            }else{
                self->ISTSval = 0;
                self->lblFastComValue.text = @"$35 Per IS";
            }
            
            
            
            
            
        });
        
        
      
        
        

        
        
        
        
        
        
        
    }

-(void)checkFastcommEight{
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 8];
    [components setMinute: 30];
    [components setSecond: 00];
    
    NSDate *firstDate = [gregorian dateFromComponents: components];
    
    //NSDate *firstdate
    
    NSDate *secondDate = [NSDate date];
    
    
    
    if( [firstDate timeIntervalSinceDate:secondDate] > 0 ) {
        
        
        //[btnFastComm setTitle:@"$5 Guaranteed"];
        [btnFastComm setTitle:@"$5 Guaranteed" forState:UIControlStateNormal];
        [btnFastComm setTitle:@"$5 Guaranteed" forState:UIControlStateSelected];
        
        
    }else{
        if(ISTSval == 1){
            
            [btnFastComm setTitle:@"IS=$35+5 & CB=$13+5" forState:UIControlStateNormal];
            [btnFastComm setTitle:@"IS=$35+5 & CB=$13+5" forState:UIControlStateSelected];
        }else{
            
            [btnFastComm setTitle:@"IS=$30+5 & CB=$13+5" forState:UIControlStateNormal];
            [btnFastComm setTitle:@"IS=$30+5 & CB=$13+5" forState:UIControlStateSelected];
        }

        
    }
    
    
}
-(void)checkFastCommThree{
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 15];
    [components setMinute: 00];
    [components setSecond: 00];
    
    NSDate *firstDate = [gregorian dateFromComponents: components];
    
    //NSDate *firstdate
    
    NSDate *secondDate = [NSDate date];
    
    
    
    if( [secondDate timeIntervalSinceDate:firstDate] > 0 ) {
        
        
        //[btnFastComm setTitle:@"$5 Guaranteed"];
        [btnFastComm setTitle:@"$5 Tomorrow" forState:UIControlStateNormal];
        [btnFastComm setTitle:@"$5 Tomorrow" forState:UIControlStateSelected];
        
        
    }
    
    
    
    
}

    -(void)getfastcommMTD{
        
        NSString *UrlStr = @"https://fbf2.bulwarkapp.com/Fastcomm/getMTD.ashx?hr_emp_id=";
        
        UrlStr = [UrlStr stringByAppendingString:delegate.hrEmpId];
        UrlStr = [UrlStr stringByAppendingString:@"&v=1"];
        
        
        
       // NSString* link = UrlStr;
        //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:0 timeoutInterval:5];
        //NSURLResponse* response=nil;
        //NSError* error=nil;
        //NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString* stringFromServer = [self getStringFromSite:UrlStr];
        
        
        
        NSArray *items = [stringFromServer componentsSeparatedByString:@"-"];   //take the one array for split the string
        NSString *mtd1 = @"0";
        NSString *pp1 = @"0";
        
        if(items.count == 2){
            mtd1 =[items objectAtIndex:0];
            pp1 = [items objectAtIndex:1];
        }else{
            
            mtd1 = stringFromServer;
            
        }

        
        
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:mtd1];
        
        
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *mtdvalue = [formatter stringFromNumber:myNumber];
        
     
        
        NSNumberFormatter *f1 = [[NSNumberFormatter alloc] init];
        f1.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber1 = [f1 numberFromString:pp1];
        
        
        
        NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
        [formatter1 setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *ppvalue = [formatter1 stringFromNumber:myNumber1];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->lblFastCommMTD.text = [mtdvalue stringByAppendingString:@" MTD"];
            self->lblFastCommPP.text = [ppvalue stringByAppendingString:@" Due"];
        });
        
        
        
    }
    
    
    
    








-(IBAction)btnClockIn{
  
        
        
    
    NSString *clockintime = [self CurrentTimeOnly];
    
    NSString *msgdisp = @"Clock IN at ";
    
    msgdisp = [msgdisp stringByAppendingString:clockintime];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msgdisp message:@"Are you sure you want to Clock In now?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
           // NSLog(@"Destructive");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
            [self SaveClockInTime];
            
            
            
            
            NSString *fdataUrl = @"https://ipadapp.bulwarkapp.com/Clock.aspx?hr_emp_id=";
            fdataUrl =  [fdataUrl stringByAppendingString:self->delegate.hrEmpId];
            
            
            fdataUrl =  [fdataUrl stringByAppendingString:@"&type=1&time="];
            
            
            
            NSDate *today1 = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy%20HH:mm"];
            
            NSString *dateString11 = [dateFormat stringFromDate:today1];
            
            //NSString *spage1 = @"Clock Out ";
            fdataUrl=  [fdataUrl stringByAppendingString:dateString11];
            
            
            NSLog(@"%@", fdataUrl);
            [self SaveServiceFile:fdataUrl];
             

            
            
            
            [self sendFilesToServerAsync];
            
            [self toastScreenAsync:@"Clocked In at " withMessage:[self CurrentTimeTimeOnly]];
            
            
            [self CheckClockOut];
            
            
            
            
        }];
        
        [alertController addAction:destructiveAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated: YES completion: nil];
    
    
    
    

        

       
        
			
}
-(IBAction)btnClockOut{
    
    NSString *clockintime = [self CurrentTimeOnly];
    
    NSString *msgdisp = @"Clock OUT at ";
    
    msgdisp = [msgdisp stringByAppendingString:clockintime];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msgdisp message:@"Are you sure you want to Clock Out now?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
           // NSLog(@"Destructive");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
            [self SaveClockInTime];
            
            
            
            
            NSString *fdataUrl = @"https://ipadapp.bulwarkapp.com/Clock.aspx?hr_emp_id=";
            fdataUrl =  [fdataUrl stringByAppendingString:self->delegate.hrEmpId];
            
            
            fdataUrl =  [fdataUrl stringByAppendingString:@"&type=2&time="];
            
            
            
            NSDate *today1 = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy%20HH:mm"];
            
            NSString *dateString11 = [dateFormat stringFromDate:today1];
            
            //NSString *spage1 = @"Clock Out ";
            fdataUrl=  [fdataUrl stringByAppendingString:dateString11];
            
            
            NSLog(@"%@", fdataUrl);
            [self SaveServiceFile:fdataUrl];
             

            
            
            
            [self sendFilesToServerAsync];
            
            [self toastScreenAsync:@"Clocked Out at " withMessage:[self CurrentTimeTimeOnly]];
            
            
            [self CheckClockOut];
            
            
            
            
        }];
        
        [alertController addAction:destructiveAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated: YES completion: nil];
    
    
    
}

-(IBAction) goBack:(id)sender {
	[webView goBack];
	
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // Log out the message received
    NSLog(@"Received event %@", message.body);
    
    // Then pull something from the device using the message body
    NSString *version = [[UIDevice currentDevice] valueForKey:message.body];
    
    // Execute some JavaScript using the result
    NSString *exec_template = @"set_headline(\"received: %@\");";
    NSString *exec = [NSString stringWithFormat:exec_template, version];
    [webView evaluateJavaScript:exec completionHandler:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    //[WKWebViewPanelManager presentConfirmOnController:self title:@"Confirm" message:message handler:completionHandler];
    
    
    
    if ([message hasPrefix:@"LateFast50TD"]){
     
        
        
        
        /*
         
         dispatch_async(dispatch_get_main_queue(), ^(){

            
            viewFBFSearch* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewFBFSearch"];
            
            //customView.DateFor = @"For Todays Route";
            //customView.istoday = 1;
            //customView.isEarly = 0;
            //customView.routeDate = [self CurrentDate];
            customView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            customView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //[self.view addSubview:customView.view];
            [self presentViewController:customView animated:YES completion:nil];
            //[self addChildViewController:customView];

     });
        
        
        
        
         */
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^(){

            
            
            
            viewFBFSearch* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewFBFSearch"];
            
            customView.HrEmpId = self->delegate.hrEmpId;
            customView.FromPage = @"Account Search";
            customView.CustomerId = 100492;
            customView.ServiceId = 3627;
            customView.isNC = false;
            customView.accountNumber = @"103328";
            customView.ServiceType = @"MO,IS";
            //customView.istoday = 1;

            customView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            customView.modalPresentationStyle = UIModalPresentationPageSheet;
            //[self.view addSubview:customView.view];
            [self presentViewController:customView animated:YES completion:nil];
            
            
            
            
            
            
            /*
            viewISExtendedOptIn* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"popIsext"];
            
            customView.DateFor = @"For Todays Route";
            customView.istoday = 1;
            customView.isEarly = 0;
            customView.routeDate = [self CurrentDate];
            customView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            customView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //[self.view addSubview:customView.view];
            [self presentViewController:customView animated:YES completion:nil];
            
            */
            
            
            
            
            
      
            

     });
        
        
        completionHandler(NO);
        
        
        
        
      /*  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"6-9PM$50 Today" message:@"You can add up to 3 additional Initial services after your route, each will have a timeblock of 5pm to 9pm" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=1&istoday=1&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=2&istoday=1&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=3&istoday=1&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NO);
        }]];
        [self presentViewController:alertController animated:YES completion:^{

            
            
        }];
        */
        
        
    }else if ([message hasPrefix:@"LateFast50TM"]){
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^(){

            
            viewISExtendedOptIn* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"popIsext"];
            
            customView.DateFor = @"For Tomorrows Route";
            customView.istoday = 0;
            customView.isEarly = 0;
            
        
            
            NSTimeInterval totalSecondsInDay = 1 * 24 * 60 * 60;
            

            NSDate *Tomorrow = [NSDate dateWithTimeIntervalSinceNow:totalSecondsInDay];
            NSCalendar* cal = [NSCalendar currentCalendar];
            NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:Tomorrow];
            
            if(comp.day == 1){
                totalSecondsInDay = totalSecondsInDay * 2;
                Tomorrow =[NSDate dateWithTimeIntervalSinceNow:totalSecondsInDay];
            }
            
            NSDateFormatter *formatter;
            NSString        *dateString;
            
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            dateString = [formatter stringFromDate:Tomorrow];
            
            customView.routeDate = dateString;

            customView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            customView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
          
            [self presentViewController:customView animated:YES completion:nil];
         

     });
        
        completionHandler(NO);
        /*
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"6-9PM$50 Tomorrow" message:@"You can add up to 3 additional Initial services after your route, each will have a timeblock of 5pm to 9pm" preferredStyle:UIAlertControllerStyleAlert];
        
        

        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=1&istoday=2&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=2&istoday=2&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Give me 3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=1&amt=3&istoday=2&hrempid=";
            submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
            
            NSString* ret = [self getStringFromSite:submitString];
            NSLog(@"%@", ret);
            completionHandler(NO);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NO);
        }]];
        [self presentViewController:alertController animated:YES completion:^{

            
            
        }];
        */
        
    }else if ([message hasPrefix:@"EarlyFast50"]){
        
    
  
    
        dispatch_async(dispatch_get_main_queue(), ^(){

            
            viewISExtendedOptIn* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"popIsextEarly"];
            
            customView.DateFor = @" For Tomorrows Route";
            customView.isEarly = 1;
            

            customView.istoday = 0;
           
        
            
            NSTimeInterval totalSecondsInDay = 1 * 24 * 60 * 60;
            

            NSDate *Tomorrow = [NSDate dateWithTimeIntervalSinceNow:totalSecondsInDay];
            NSCalendar* cal = [NSCalendar currentCalendar];
            NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:Tomorrow];
            
            if(comp.day == 1){
                totalSecondsInDay = totalSecondsInDay * 2;
                Tomorrow =[NSDate dateWithTimeIntervalSinceNow:totalSecondsInDay];
            }
            
            NSDateFormatter *formatter;
            NSString        *dateString;
            
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            dateString = [formatter stringFromDate:Tomorrow];
            
            customView.routeDate = dateString;
            
            

            customView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            customView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
            [self presentViewController:customView animated:YES completion:nil];
          
     });
        
        
        completionHandler(NO);
        
    //comment out origional
        /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"7AM$50" message:@"By Clicking Yes this will allow for an initial Service to be added before your route tomorrow morning with a timeblock of 7am to 9am" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString* submitString = @"https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=0&amt=1&istoday=2&hrempid=";
        submitString = [submitString stringByAppendingString:self->delegate.hrEmpId];
        
        NSString* ret = [self getStringFromSite:submitString];
        NSLog(@"%@", ret);
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
        
        */
        
        
        
        
        
        
    
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            completionHandler(YES);
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NO);
        }]];
        [self presentViewController:alertController animated:YES completion:^{}];
        
    }
    
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    //[WKWebViewPanelManager presentPromptOnController:self title:@"Prompt" message:prompt defaultText:defaultText handler:completionHandler];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Prompt" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    

}




- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self->HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
    });
    //NSLog(@"didStartProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    //NSLog(@"didReceiveServerRedirectForProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"didFailProvisionalNavigation: %@navigation, error: %@", navigation, error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //NSLog(@"didCommitNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishLoadingNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self->HUD hide:YES];
        
        [self.view hideToastActivity];
        
        
        if(self->backgroundLoadingRoute){
            self->backgroundLoadingRoute=false;
            
            if(webView == self->RouteWebView){
                [self->RouteWebView.scrollView setContentOffset:self->RWVpt animated:NO];
            }
            
        }
        
        
    });
    //NSLog(@"didFinishLoadingNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"didFailNavigation: %@, error %@", navigation, error);
}

- (void)_webViewWebProcessDidCrash:(WKWebView *)webView {
    //NSLog(@"WebContent process crashed; reloading");
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
      //  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self->HUD hide:YES];
        [self.view hideToastActivity];
    });
   // NSLog(@"didFinish: %@; stillLoading:%@", [webView URL], (webView.loading?@"NO":@"YES"));
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{

    
    UIApplication *app1 = [UIApplication sharedApplication];
    NSURL         *url = navigationAction.request.URL;
    

    if ([url.scheme isEqualToString:@"maps"])
    {

        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        
    }
    
    if ([url.scheme isEqualToString:@"comgooglemaps"])
    {
      
            
            NSString *mapsurllink = [url.absoluteString stringByReplacingOccurrencesOfString:@"comgooglemaps://?q=" withString:@""];
            
                NSString *Mstring = @"comgooglemaps://?directionsmode=driving&daddr=";
            Mstring = [Mstring stringByAppendingString:mapsurllink];
            
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            
        [app1 openURL:[NSURL URLWithString:Mstring] options:@{} completionHandler:nil];
           
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       
    }
    
   
    
    
    if ([url.scheme isEqualToString:@"bulwarktw"])
    {
   
        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       
    }
    if ([url.scheme isEqualToString:@"bulwarktwreports"])
    {

        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       
    }
    if ([url.scheme isEqualToString:@"bulwarktwmap"])
    {
       
        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       
    }
    if ([url.scheme isEqualToString:@"prefs"])
    {
    
        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
     
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}




- (void)handleOpenURL:(NSURL *)url {

	NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
	
	NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"settings"];

	NSString *URLString = [url absoluteString];
	
	NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
	
	NSString *urlParamater = [paramater objectAtIndex: 2];
	
	NSString *spage =[paramater objectAtIndex: 1];
	
	double dpage = [spage doubleValue];

	if (dpage==1)
	{
		// Example 1, loading the content from a URLNSURL
		NSURL *urlz = [NSURL URLWithString:urlParamater];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
		[webView loadRequest:request];		
		
	}
	else if (dpage==2){
	
        
        
        
        
        [self CheckClockIn];
        

		NSString *path = [[NSBundle mainBundle]
						  pathForResource:@"results"
						  ofType:@"html"]; 
		NSURL *urlq = [NSURL fileURLWithPath:path];

		NSString *theAbsoluteURLString = [urlq absoluteString];   
		
		NSString *queryString = [@"?" stringByAppendingString: urlParamater]; 
		
		NSString *absoluteURLwithQueryString = [theAbsoluteURLString stringByAppendingString: queryString];  
		
		NSURL *finalURL = [NSURL URLWithString: absoluteURLwithQueryString];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		[webView loadRequest:request];		
		
	}
	else if (dpage==3)
	{
		//NSString *Build = [self CurrentAppBuild];
		//[HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
        NSString *truck = @"0";
        
        NSArray *paths3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory3 = [paths3 objectAtIndex:0];
        
        NSString *myPathDocs3 =  [documentsDirectory3 stringByAppendingPathComponent:@"truck"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs3])
        {
            
        }
        else {
            
            
            truck = [[NSString alloc] initWithContentsOfFile:myPathDocs3 encoding:NSUTF8StringEncoding error:NULL];
            
	
        }
        
        
        
        
        
        
		Rurl = url;
        
        NSString *URLString = [url absoluteString];
        
        //URLString = [URLString stringByReplacingOccurrencesOfString:@"routedatestring"
                                                                // withString:rdate];
        
        
        NSString *off = [delegate.office stringByReplacingOccurrencesOfString:@"4" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"5" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"3" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"6" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"2" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"1" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"7" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"8" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"9" withString:@""];
        
        
        URLString = [URLString stringByAppendingString:@"&truck="];
        URLString = [URLString stringByAppendingString:off];
        URLString = [URLString stringByAppendingString:@"%20"];
        URLString = [URLString stringByAppendingString:truck];
        URLString = [URLString stringByAppendingString:@"&now="];
		URLString= [URLString stringByAppendingString:[self CurrentTimeUrl]];
        
        
        NSURL * url3 = [NSURL URLWithString:URLString];
		
		[NSThread detachNewThreadSelector:@selector(sendResults:) toTarget:self withObject:url3];
		
			
	}
	else if (dpage==4)
	{
        NSString *truck = @"0";
        
       // NSArray *paths3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       // NSString *documentsDirectory3 = [paths3 objectAtIndex:0];
        
        NSString *myPathDocs3 =  [documentsDirectory2 stringByAppendingPathComponent:@"truck"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs3])
        {
            
        }
        else {
            
            
            truck = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
            
            
        }
		
		
		NSArray *paramater1 = [URLString componentsSeparatedByString:@"!"];
		
		NSString *urlParamater1 = [paramater1 objectAtIndex: 1];
		
		
		urlParamater1 = [urlParamater1 stringByReplacingOccurrencesOfString:@"routedatestring"
														 withString:rdate];
        
        
        
        NSString *off = [delegate.office stringByReplacingOccurrencesOfString:@"4" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"5" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"3" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"6" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"2" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"1" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"7" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"8" withString:@""];
        off = [off stringByReplacingOccurrencesOfString:@"9" withString:@""];
        
        
        URLString = [URLString stringByAppendingString:@"&truck="];
        URLString = [URLString stringByAppendingString:off];
        URLString = [URLString stringByAppendingString:@"%20"];
        URLString = [URLString stringByAppendingString:truck];
			
		urlParamater1 = [urlParamater1 stringByAppendingString:@"&now="];
		urlParamater1 = [urlParamater1 stringByAppendingString:[self CurrentTimeUrl]];
		
		[self SaveServiceFile:urlParamater1];

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
		{
			
		}  
		else {
			spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
		}		
		
		
		NSURL *urlz = [NSURL URLWithString:spage];
		
		
		
        
        NSString *path4=@"";
        
        
        
        
        path4 = [[NSBundle mainBundle]
                 pathForResource:@"blank"
                 ofType:@"html"];
        
        
        
		NSURL *urlq = [NSURL fileURLWithPath:path4];
		
		
		
		NSString *theAbsoluteURLString = [urlq absoluteString];
        
		
		
		
		NSURL *finalURL = [NSURL URLWithString: theAbsoluteURLString];
		
		NSURLRequest *brequest = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
        
       // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      //  {
            
            [RouteWebView loadRequest:request];
            [webView loadRequest:brequest];
       // }else{
       //     [webView loadRequest:request];
       // }
		
		
		
		//[webView loadRequest:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view makeToast:@"Copy of Route Loaded"
                        duration:3.0
                        position:CSToastPositionTop];
            
        });
      
       
        
        
		//[[iToast makeText:NSLocalizedString(, @"")] show];
		

		
	}	
	else if (dpage==5){

        

	}
	else if (dpage==6){
		//save routedate
		
		
		NSArray *paramater1 = [urlParamater componentsSeparatedByString:@"!"];
		
		NSString *urlParamater1 = [paramater1 objectAtIndex: 1];		
		rdate = [paramater1 objectAtIndex: 0]; 
		
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// the path to write file
		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"rdate.tw"];
		
		[rdate writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];		
		
		
		NSString *appFile1 = [documentsDirectory stringByAppendingPathComponent:@"main"];
		
		[urlParamater1 writeToFile:appFile1 atomically:YES encoding:NSUTF8StringEncoding error:NULL];			
		
		
		NSURL *urlz = [NSURL URLWithString:urlParamater1];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
		[RouteWebView loadRequest:request];
		
		PopUpWebView.hidden = YES;
		

		
		
	}
		else if (dpage==7){
			
            
            
			//alertWithYesNoButtons = [[UIAlertView alloc] initWithTitle:@"Clock In"
			//												   message:@"Are you sure you want to Clock In?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			
			//[alertWithYesNoButtons show];
	
		
		
		}
		else if (dpage==8){
			//alertWithOkButton = [[UIAlertView alloc] initWithTitle:@"Clock Out"
			//												   message:@"Are you sure you want to Clock Out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			
            
			//[alertWithOkButton show];
			
			
		}				
		else if (dpage==9){
		
			//UIWebView *printView;
			// zzzzzzzzzzzzzzzzzzxzxzzxzxzxzxzxzxzxzxzxzxzzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzx
            //origional print stuff not used in a very long time
			
		/*
			NSString *HTMLData = [urlParamater stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];		
		
		
		//stringByReplacingPercentEscapesUsingEncoding:urlParamater;
			
			
			
			
			
			
			UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
			pic.delegate = self;
			//UIPrintPaper paper 
	
			
			UIPrintInfo *printInfo = [UIPrintInfo printInfo];
			printInfo.outputType = UIPrintInfoOutputGeneral;
			printInfo.jobName = @"test";
			pic.printInfo = printInfo;
			
			UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
														 initWithMarkupText:HTMLData];
			htmlFormatter.startPage = 0;
			//htmlFormatter.maximumContentHeight = 6 * 72.0;
			//htmlFormatter.
            htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(5, -20, -20, -20); // 1 inch margins
			htmlFormatter.maximumContentWidth = 6 * 72.0;
			pic.printFormatter = htmlFormatter;
			
			
			pic.showsPageRange = YES;
			
			
			
			void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
			^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
				if (!completed && error) {
					NSLog(@"Printing could not complete because of error: %@", error);
				}
			};

				[pic presentAnimated:YES completionHandler:completionHandler];
			
			 
			 
			*/
			
		}
		else if(dpage==10){
			
			
			/*
			NSString *downloadFile = @"https://ipadapp.bulwarkapp.com/chemicalsusediphone";
			downloadFile= [downloadFile stringByAppendingString:delegate.office];
			downloadFile= [downloadFile stringByAppendingString:@".html"];
			
			
			downloadFile =
			[downloadFile stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];				
			
			NSError *err = [[NSError alloc] init];
			NSString *url = [downloadFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
			
			
			
			
			if(err.code != 0) {
				UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Download" message: @"Unable to Download" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
				
				[someError show];
				
	
			}
			else {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				
				//NSString *appFile = [[NSBundle mainBundle]
				//				  pathForResource:@"chemicalsused"
				//				  ofType:@"html"]; 				
				// the path to write file
				NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
				
				[myTxtFile writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
				
				UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Download" message: @"Download Complete" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
				
				[someError show];
             
			}

             */
		}
	else if (dpage==11)
	{
	
        
        [self CheckClockIn];
		NSString *chemicals=@"";
		
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
		
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
		{
			
		}  
		else {
			chemicals = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
		}
		
        
        
        
        NSString *arvtime = @"";
        
       // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //{
 
        
        NSString *temparv = [self GetArrvTime];
        
        NSArray *arr = [temparv componentsSeparatedByString:@" "];
        
        if (arr.count >1){
            arvtime = [arr objectAtIndex:1];
        }
         
        //}
        
        
        

		NSString *queryString = [@"" stringByAppendingString: urlParamater]; 		
		//NSString *absoluteURLwithQueryString = @"";
		queryString = [queryString stringByAppendingString: @"&techname="];
		queryString = [queryString stringByAppendingString: delegate.name];
		queryString = [queryString stringByAppendingString: @"&licnum="];
		queryString = [queryString stringByAppendingString: delegate.license];
        queryString = [queryString stringByAppendingString: @"&office="];
		queryString = [queryString stringByAppendingString: delegate.office];
        queryString = [queryString stringByAppendingString: @"&timein="];
		queryString = [queryString stringByAppendingString: arvtime];		//NSString *str = @"This is a string";
		
		chemicals = [chemicals stringByReplacingOccurrencesOfString:@"%paramaterstoreplace%"
														 withString:queryString];	
		
		NSData *data = [NSData dataWithBytes:[chemicals UTF8String] length:[chemicals lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		
		
        NSString *final =[data base64EncodedStringWithOptions:0];

		
		final = [@"data:text/html;charset=utf-8;base64," stringByAppendingString: final];		
		
		
		
		
		NSURL *urlz = [NSURL URLWithString:final];
		
		
		NSURLRequest *request3 = [NSURLRequest requestWithURL:urlz];
		
		[webView loadRequest:request3];			
		
				
	}
	else if (dpage==18){
		

		
		
	}
	else if (dpage==19){
	
		
		
		
		NSString* addr = urlParamater;
        
    
        
        NSURL* url = [[NSURL alloc] initWithString:addr];
		
         [NSThread detachNewThreadSelector:@selector(openurl_in_background:) toTarget:self withObject:url];
        //[[UIApplication sharedApplication] openURL:url];
	
	}
	else if (dpage==16){
		}

	else if (dpage==20){
		
		[webView goBack];
		
	}
	else if (dpage==21){
		
		//NSString *Build = [self CurrentAppBuild];
		
		//NSString *msg = @"Current build is ";
		
		//msg = [msg stringByAppendingString: Build];
		
		//UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"Build Info" message: msg  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		//[someError1 show];
		
		
	}
	else if (dpage==22){
		
		
		

				
		
		
	}	
	else if(dpage==23){ //load survey
		//NSString *urlParamater2 = [paramater objectAtIndex: 3];
		urlParamater =  [urlParamater stringByAppendingString:@"?"];
		urlParamater =  [urlParamater stringByAppendingString:@"hr_emp_id="];		
		urlParamater =  [urlParamater stringByAppendingString:delegate.hrEmpId];
		urlParamater =  [urlParamater stringByAppendingString:@"&survey_id=1&pt=1"];	
		
		//NSString* addr = urlParamater;
		//NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		//[[UIApplication sharedApplication] openURL:url];
		//[url release];				
		
		NSURL *urlz = [NSURL URLWithString:urlParamater];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
		[webView loadRequest:request];	
	
	}
	else if(dpage==24){ //load avaliable routes
		//[HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
		PopUpWebView.hidden=YES;
        [PopUpWebView loadHTMLString:@"" baseURL:nil];
		[NSThread detachNewThreadSelector:@selector(loadAvailable) toTarget:self withObject:nil];  		
		
	}
	else if(dpage==25){
		
		
	//UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Test" message:hrEmpId delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[alert show];
	//[alert release];	
		
		//[HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
		[NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];  	
		
	}
	else if(dpage==26){
		[webView goBack];
		[webView goBack];
		
	}
    else if(dpage==27){
        NSString *phn = @"4804294341";
        
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/phones/clicktocall.aspx?mp=";
        
        NSString *techPhone =  [[delegate.phone componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
        
        UrlStr = [UrlStr stringByAppendingString:techPhone];
        UrlStr = [UrlStr stringByAppendingString:@"&d="];
        UrlStr = [UrlStr stringByAppendingString:phn];
        UrlStr = [UrlStr stringByAppendingString:@"&o="];
        UrlStr = [UrlStr stringByAppendingString:delegate.office];
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = YES;
        [PopUpWebView loadRequest:srequest];
        
    }
	else if(dpage==28){
        
        NSString *HTMLData = urlParamater; //[urlParamater stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];;
        
        
        NSString * str = @"1B";
		NSMutableString * newString = [[NSMutableString alloc] init];
		int i = 0;
		while (i < [str length])
		{
			NSString * hexChar = [str substringWithRange: NSMakeRange(i, 2)];
			int value = 0;
			sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
			[newString appendFormat:@"%c", (char)value];
			i+=2;
		}
        
		
		NSString * esc = [NSString stringWithString: newString];
        
        NSString * str1 = @"0A";
		NSMutableString * newString1 = [[NSMutableString alloc] init];
		int i1 = 0;
		while (i1 < [str1 length])
		{
			NSString * hexChar1 = [str1 substringWithRange: NSMakeRange(i1, 2)];
			int value1 = 0;
			sscanf([hexChar1 cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value1);
			[newString1 appendFormat:@"%c", (char)value1];
			i1+=2;
		}
        
		
		NSString * lf = [NSString stringWithString: newString1];
        
        
        
        
        
        
		NSString *string = HTMLData;
		string = [string stringByReplacingOccurrencesOfString:@"<ESC>"
                                                   withString:esc];
		string = [string stringByReplacingOccurrencesOfString:@"<LF>"
											   withString:lf];
        
		
        NSString *someString = string;
        //uint8_t buffer[1024];
        
        
        
        
        if([someString length]+1 >4096){
            
            [self toastScreenAsync:@"Error" withMessage:@"to many char"];
            
        }
        
        //memcpy(txBuffer, [someString UTF8String], [someString length]+1);
        
        //txBuffer[0] = esc ;
       // [rscMgr setDtr:NO];
       // [rscMgr setRts:YES];
        //[NSThread sleepForTimeInterval:2];
        
        
        
        //NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[myString length]];

        
        someString = [someString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //[self BtConnectPrinter:someString];
        
        if (self.printDev.bReadyToWrite)
        {
            //NSString *nstr = @"\x1b\nthis is a test\n\r\n\r";
            
            NSString *wspace = @"\x1b\n\n\r\n\r";
            
            NSData* wdata = [wspace dataUsingEncoding:NSUTF8StringEncoding];
            [self.printManager writeDataToDevice:wdata Device:self.printDev];
            [NSThread sleepForTimeInterval:0.3];
            
            
        
            
            NSString *stringg = HTMLData;
            
            if([self.printDev.name containsString:@"STAR"]){
           stringg = [stringg stringByReplacingOccurrencesOfString:@"E1"
                                                       withString:@"E"];
            stringg = [stringg stringByReplacingOccurrencesOfString:@"E0"
                                                       withString:@"F"];
            }
            
            stringg = [stringg stringByReplacingOccurrencesOfString:@"<ESC>"
                                                       withString:esc];
            stringg = [stringg stringByReplacingOccurrencesOfString:@"<LF>"
                                                       withString:lf];
            
            stringg = [stringg stringByReplacingOccurrencesOfString:@"&comma;" withString:@","];
            
          //  NSString *pd = HTMLData;
            
           // pd= [pd stringByReplacingOccurrencesOfString:@"<ESC>"
            //                                  withString:@"\r"];
           // pd = [pd stringByReplacingOccurrencesOfString:@"<LF>"
            //                                   withString:lf];
            
           // NSArray *arr = [pd componentsSeparatedByString:@"\n"];

            
           // for (NSString *string1 in arr) {
            //    NSLog(@"%@",string1);
       
            
            
            
            
            for (int i=0; i < [stringg length]; i=i+50) {
                long er = 50;
                
                
                long ss = [stringg length];
                
                if((i+50)>= ss){
                    er= [stringg length] - i;
                    
                }
                
                NSRange r = NSMakeRange(i, er);
                
                NSString *cup = [stringg substringWithRange: r];
                
                NSData* data = [cup dataUsingEncoding:NSUTF8StringEncoding];
                
                [self.printManager writeDataToDevice:data Device:self.printDev];
                
                
                [NSThread sleepForTimeInterval:.01];
                
                //[characters addObject:ichar];

            
            }
            
            
            
            
            
            
            
            
            
            
            
            
           // NSLog([@"1234567890" substringWithRange:NSMakeRange(3, 5)]);
                  
            
            
            
              //  NSString *nstr = [string1 stringByAppendingString:@"\n"];
             //   NSData* data = [stringg dataUsingEncoding:NSUTF8StringEncoding];
            
              //  [self.printManager writeDataToDevice:data Device:self.printDev];
            
            
              //  [NSThread sleepForTimeInterval:1.0];
            
           // }
            
           

       }else{
        
        
        
       // for (int i=0; i < [someString length]; i=i+500) {
       //     long er = 500;
            
            
         //   long ss = [someString length];
            
         //   if((i+500)>= ss){
        //        er= [someString length] - i;
         //
          //  }
            
            //NSRange r = NSMakeRange(i, er);
            
            //NSString *cup = [someString substringWithRange: r];
            
            //int le = (int)[cup length] +1;
            
           // memcpy(txBuffer, [cup UTF8String], le);
            
            
           // [rscMgr write:txBuffer length:le];
            
            //[rscMgr write:txBuffer Length:le];
            
            
          //  [NSThread sleepForTimeInterval:.001];
            
            //[characters addObject:ichar];
      // }
        
        

        
        
        }
        
        [NSThread sleepForTimeInterval:1];
       //   [rscMgr setRts:NO];
        //[rscMgr setDtr:YES];

        
    }
	else if(dpage==29){
        
        
        NSArray *paramater4 = [urlParamater componentsSeparatedByString:@"~"];
        
        NSString *phoneNumber = [paramater4 objectAtIndex: 0];
        
        NSString *AccountNumber =[paramater4 objectAtIndex: 1];
        
        NSString *CustId =[paramater4 objectAtIndex: 2];
        
        
        NSString *fdata = @"https://ipadapp.bulwarkapp.com/hh/retention/call.aspx?number=";
        
        fdata = [fdata stringByAppendingString:phoneNumber];
        fdata = [fdata stringByAppendingString:@"&account="];
        fdata = [fdata stringByAppendingString:AccountNumber];
        fdata = [fdata stringByAppendingString:@"&custid="];
        fdata = [fdata stringByAppendingString:CustId];
        fdata = [fdata stringByAppendingString:@"&date="];
        fdata = [fdata stringByAppendingString:[self CurrentTimeUrl]];
        fdata = [fdata stringByAppendingString:@"&hr_emp_id="];
        fdata = [fdata stringByAppendingString:delegate.hrEmpId];
        
        
        
        
        [self SaveServiceFile:fdata];
        
        NSString* addr = @"tel:";
        addr = [addr stringByAppendingString:phoneNumber];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
        
        [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:nil];
        
        
    }
    else if(dpage==30){
        
        NSString *site = urlParamater;
        
        
        
        if(delegate.driving){
            
            
            site = [site stringByReplacingOccurrencesOfString:@"data:text/html;charset=utf-8;base64," withString:@""];
            
            
            // NSData from the Base64 encoded str
            NSData *nsdataFromBase64String = [[NSData alloc]
                                              initWithBase64EncodedString:site options:0];
            
            // Decoded NSString from the NSData
            NSString *base64Decoded = [[NSString alloc]
                                       initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
            
            
            
           // NSString *str = @"The Quick Brown Fox Brown";
           // NSInteger count = 0;
            
            NSString *mapUrl = @"";
            
            NSArray *arr = [base64Decoded componentsSeparatedByString:@"\""];
            for(int i=0;i<[arr count];i++)
            {
            if([[arr objectAtIndex:i] hasPrefix:@"maps://maps/m"])
               // count++;
                mapUrl = [arr objectAtIndex:i];
            }

            
            NSLog(@"Url: %@", mapUrl);
            
            
         
            
            mapUrl = [mapUrl stringByReplacingOccurrencesOfString:@"maps://maps/m?dc=mgc_maps&q=" withString:@"http://maps.apple.com/maps?saddr=Current%20Location&daddr="];
            
            mapUrl=[mapUrl stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSLog(@"Url: %@", mapUrl);
            
            
            
            NSURL* url = [[NSURL alloc] initWithString:mapUrl];
           
            //dispatch_async(dispatch_get_main_queue(), ^{
              //  [[UIApplication sharedApplication] openURL:url];
           // });
            
            
            [NSThread detachNewThreadSelector:@selector(openurl_in_background:) toTarget:self withObject:url];

            
            //[[UIApplication sharedApplication] openURL:url];
            
        }else{
            
            NSURL *qurl = [NSURL URLWithString:site];
            
            NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
            [webView loadRequest:srequest];
            
        }



        
        
    }
    else if(dpage==31){
        //click to call
        
        NSString *phn = urlParamater;
        
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/phones/clicktocall.aspx?mp=";
        
        NSString *techPhone =  [[delegate.phone componentsSeparatedByCharactersInSet:
                                                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                     componentsJoinedByString:@""];
        
        UrlStr = [UrlStr stringByAppendingString:techPhone];
        UrlStr = [UrlStr stringByAppendingString:@"&d="];
        UrlStr = [UrlStr stringByAppendingString:phn];
        UrlStr = [UrlStr stringByAppendingString:@"&o="];
        UrlStr = [UrlStr stringByAppendingString:delegate.office];
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = YES;
        [PopUpWebView loadRequest:srequest];
        
        
        
        
        
    }
    else if (dpage==32){
        //close PopupWindow
        PopUpWebView.hidden=YES;
        [PopUpWebView loadHTMLString:@"" baseURL:nil];
    }
    else if(dpage==33){
       	
        
        
		PopUpWebView.hidden = YES;
        

		rdate = urlParamater;
		
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// the path to write file
		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"rdate.tw"];
		
		[rdate writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
		
		

		
		
		
		//[HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
		[NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
    }
    else if (dpage==34){
        NSArray *paramater4 = [urlParamater componentsSeparatedByString:@"~"];
        
        NSString *phoneNumber = [paramater4 objectAtIndex: 0];
        
        NSString *AccountNumber =[paramater4 objectAtIndex: 1];
        
        NSString *CustId =[paramater4 objectAtIndex: 2];
        
        
        NSString *fdata = @"https://ipadapp.bulwarkapp.com/hh/retention/call.aspx?number=";
        
        fdata = [fdata stringByAppendingString:phoneNumber];
        fdata = [fdata stringByAppendingString:@"&account="];
        fdata = [fdata stringByAppendingString:AccountNumber];
        fdata = [fdata stringByAppendingString:@"&custid="];
        fdata = [fdata stringByAppendingString:CustId];
        fdata = [fdata stringByAppendingString:@"&date="];
        fdata = [fdata stringByAppendingString:[self CurrentTimeUrl]];
        fdata = [fdata stringByAppendingString:@"&hr_emp_id="];
        fdata = [fdata stringByAppendingString:delegate.hrEmpId];
        
        
        
        
        [self SaveServiceFile:fdata];
        
        
        
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/phones/clicktocall.aspx?mp=";
        
        NSString *techPhone =  [[delegate.phone componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
        
        UrlStr = [UrlStr stringByAppendingString:techPhone];
        UrlStr = [UrlStr stringByAppendingString:@"&d="];
        UrlStr = [UrlStr stringByAppendingString:phoneNumber];
        UrlStr = [UrlStr stringByAppendingString:@"&o="];
        UrlStr = [UrlStr stringByAppendingString:delegate.office];
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = YES;
        [PopUpWebView loadRequest:srequest];
        

        
    }
    else if (dpage==35){
        //add to route
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/hh/retention/addtoroute.aspx?customer_id=";
        

        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];

        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];

    }
    else if (dpage==36){
        
        //Customer notes
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/hh/customernotes.aspx?c=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];
        
    }
    else if (dpage==37){
        
        //Customer notes
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/hh/FUP/FollowUpCallIpad.aspx?cid=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];
        
    }
    else if (dpage==38){
        
        //Customer notes
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/hh/AnyTime.aspx&Customer_Id=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        //NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        //NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        //PopUpWebView.hidden = YES;
        //[PopUpWebView loadRequest:srequest];
        
        
        
        [self getStringFromSite:UrlStr];
        
        [self MsgBoxShow:@"Anytime" withMessage:@"This Customer has Been Set as Anytime" withButtonLabel:@"OK"];
        
       // UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Anytime" message: @"This Customer has Been Set as Anytime"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		//[someError show];
		//[someError release];
        
        
    }
    else if (dpage==39){
        
        //Customer notes
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/paymentipad.aspx?account=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];
        
    }
    else if (dpage==40){
        
        
        /*
        // pick a video from the documents directory
        NSURL *video =  [NSURL URLWithString:urlParamater];
        
        // create a movie player view controller
        controller = [[MPMoviePlayerViewController alloc]initWithContentURL:video];
        controller.moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        [controller.moviePlayer prepareToPlay];
        [controller.moviePlayer play];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(btnCloseVideo:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        button.frame = CGRectMake(680.0, 3.0, 65.0, 25.0);
        button.layer.cornerRadius = 6;
        button.accessibilityIdentifier = urlParamater;
        [controller.view addSubview :button];
        
        
        // and present it
        [self presentMoviePlayerViewControllerAnimated:controller];
        */
        
    }
    else if (dpage==41){
        
       //termiteImage
        NSArray *paramater4 = [urlParamater componentsSeparatedByString:@"$"];
        photoAccount = [paramater4 objectAtIndex: 0];
        photoType = @"2";
        
        Termitedata= @"" ;
        
 
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Termite Image"
                                      message:@"Take or select a image of termite activity to send"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Use Existing"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self selectTermitePhoto];
                                 [alert dismissViewControllerAnimated:YES completion: nil];
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Take Photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self takeTermitePhoto];
                                     [alert dismissViewControllerAnimated:YES completion: nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

        
    }
    else if(dpage==42){
        //while i was out i found.... open foundPicture view
        
        //termiteImage
        
        
        NSArray *paramater4 = [urlParamater componentsSeparatedByString:@"$"];
        photoAccount = [paramater4 objectAtIndex: 0];
        photoType = @"1";
        
        Termitedata= @"" ;
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Photo"
                                      message:@"Take or select a image of activity to send"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Use Existing"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self selectTermitePhoto];
                                 [alert dismissViewControllerAnimated:YES completion: nil];
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Take Photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self takeTermitePhoto];
                                     [alert dismissViewControllerAnimated:YES completion: nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

        
    }
   else if(dpage==43){
       
        
        rdate = urlParamater;
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // the path to write file
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"rdate.tw"];
        
        [rdate writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        

        
        
        
        [self.tabBarController setSelectedIndex:0];
        
        //[HUD show:YES];
       [self.view makeToastActivity:CSToastPositionCenter];
        [NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
        
        

        
        
        
    }
    else if(dpage==44){
         [self.tabBarController setSelectedIndex:4];
    }
    else if(dpage==45){
        //fieldleader clock in
         
        
        NSString *clurl = @"https://fbf2.bulwarkapp.com/TechApp/FieldWorkInOut.aspx?h=";
        
        
        clurl =  [clurl stringByAppendingString:delegate.hrEmpId];
        clurl =  [clurl stringByAppendingString:@"&dt="];
        NSDate *today1 = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy%20HH:mm"];
        
        NSString *dateString11 = [dateFormat stringFromDate:today1];
        clurl =  [clurl stringByAppendingString:dateString11];
        clurl =  [clurl stringByAppendingString:@"&isin=YES"];
        clurl =  [clurl stringByAppendingString:@"&lat="];
        
        
        NSString *lt = [self Getlat];
        NSString *ln = [self GetLon];
        clurl =  [clurl stringByAppendingString:lt];
        clurl =  [clurl stringByAppendingString:@"&lon="];
        clurl =  [clurl stringByAppendingString:ln];
        
        
        NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[aSession dataTaskWithURL:[NSURL URLWithString:clurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (((NSHTTPURLResponse *)response).statusCode == 200) {
                if (data) {
                    NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", contentOfURL);

                    

                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        

                        
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Field Work" message:contentOfURL preferredStyle:UIAlertControllerStyleAlert];

                                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];

                                [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                        [self->delegate refreshSchedule];
                        
                        
                        
                    });
                    
                    //[self toastScreenAsync:@"Clocked in" withMessage:contentOfURL];
                }
            }
        }] resume];
        
        
    }
    else if(dpage==46){ //field leader clock out
         
        
       
       NSString *clurl = @"https://fbf2.bulwarkapp.com/TechApp/FieldWorkInOut.aspx?h=";
       
       
       clurl =  [clurl stringByAppendingString:delegate.hrEmpId];
       clurl =  [clurl stringByAppendingString:@"&dt="];
       NSDate *today1 = [NSDate date];
       NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
       [dateFormat setDateFormat:@"MM/dd/yyyy%20HH:mm"];
       
       NSString *dateString11 = [dateFormat stringFromDate:today1];
       clurl =  [clurl stringByAppendingString:dateString11];
       clurl =  [clurl stringByAppendingString:@"&isin=NO"];
       clurl =  [clurl stringByAppendingString:@"&lat="];
       
       
       NSString *lt = [self Getlat];
       NSString *ln = [self GetLon];
       clurl =  [clurl stringByAppendingString:lt];
       clurl =  [clurl stringByAppendingString:@"&lon="];
       clurl =  [clurl stringByAppendingString:ln];
       
       
       NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
       [[aSession dataTaskWithURL:[NSURL URLWithString:clurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (((NSHTTPURLResponse *)response).statusCode == 200) {
               if (data) {
                   NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                   NSLog(@"%@", contentOfURL);
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Field Work" message:contentOfURL preferredStyle:UIAlertControllerStyleAlert];

                               [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];

                               [self presentViewController:alertController animated:YES completion:nil];
                       
                       
                       //self.viewSchedule = self->delegate.viewSchedule;
                       
                       [self->delegate refreshSchedule];
                       
                       
                       
                       
                       
                   });
                   
                   
                   //[self toastScreenAsync:@"Clocked Out" withMessage:contentOfURL];
               }
           }
       }] resume];
        
    }
    else if(dpage==47){
        
        
        
        
        NSString *noteId = urlParamater;
        // use UIAlertController
        UIAlertController *alert= [UIAlertController
                                      alertControllerWithTitle:@"Add Note"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                       UITextField *textField = alert.textFields[0];
                                                       NSLog(@"text was %@", textField.text);
            
            
            
            //post the notes to the server
            
            
            
           
            NSString *escapedString = [textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            NSLog(@"escapedString: %@", escapedString);
            
            NSString *clurl = @"https://fbf2.bulwarkapp.com/TechApp/FWNote.aspx?id=";
            
            
            clurl =  [clurl stringByAppendingString:noteId];
            clurl =  [clurl stringByAppendingString:@"&N="];

            
          
            clurl =  [clurl stringByAppendingString:escapedString];

            
            
            NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[aSession dataTaskWithURL:[NSURL URLWithString:clurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (((NSHTTPURLResponse *)response).statusCode == 200) {
                    if (data) {
                        NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@", contentOfURL);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Field Work Note" message:contentOfURL preferredStyle:UIAlertControllerStyleAlert];

                                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];

                                    [self presentViewController:alertController animated:YES completion:nil];
                            
                            [self->delegate refreshSchedule];
                            
                            
                        });
                        
                        
                        //[self toastScreenAsync:@"Clocked Out" withMessage:contentOfURL];
                    }
                }
            }] resume];
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            //end server call
            
            

                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {

                                                           NSLog(@"cancel btn");

                                                           [alert dismissViewControllerAnimated:YES completion:nil];

                                                       }];
        [alert addAction:cancel];
        [alert addAction:ok];
        

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            textField.keyboardType = UIKeyboardTypeDefault;
            
        }];

        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
        
        
        
        
        
    }
    else if (dpage==48){
        
        //technician go pro trianing
        NSString *UrlStr = @"https://fbf2.bulwarkapp.com/gopro/VideoPlayQuestions.aspx?h=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];
        
    }
    else if (dpage==49){
        
        //close tech training and reload the route
        
        PopUpWebView.hidden=YES;
        [PopUpWebView loadHTMLString:@"" baseURL:nil];
        
        [self.tabBarController setSelectedIndex:0];
       // [HUD show:YES];
        [self.view makeToastActivity:CSToastPositionCenter];
        [NSThread detachNewThreadSelector:@selector(loadRoute) toTarget:self withObject:nil];
        
        
    }
    else if (dpage==50){
        
        //Customer Service Agreement
        NSString *UrlStr = @"https://my.bulwarkpest.com/s?k=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        popWebViewUrl = UrlStr;
        //segueOpenContract
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self performSegueWithIdentifier:@"OpenWebView" sender:self];
        });
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^(){

            
            viewModalWeb* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewModalWeb"];
            
            //customView.DateFor = @"For Todays Route";
            //customView.istoday = 1;
            //customView.isEarly = 0;
            //customView.routeDate = [self CurrentDate];
            customView.url = UrlStr;
            customView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            customView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //[self.view addSubview:customView.view];
            [self presentViewController:customView animated:YES completion:nil];
            //[self addChildViewController:customView];

     });
        
        
        
        
        
        
        
      
               /* NSURL *qurl = [NSURL URLWithString:UrlStr];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        PopUpWebView.hidden = NO;
        [PopUpWebView loadRequest:srequest];*/
        
        
        //segueISExtended
    } else if (dpage==51){
        
        //Is extended from url scheme
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self performSegueWithIdentifier:@"segueISExtended" sender:self];
        });
        
    }
    
    
    
    
}



- (void)openurl_in_background:(NSURL *)url
{
    
    
    [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:nil];
    
}

- (void)takeTermitePhoto {
    
    Termitepicker = [[UIImagePickerController alloc] init];
    Termitepicker.delegate = self;
    Termitepicker.allowsEditing = YES;
    Termitepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:Termitepicker animated:YES completion:NULL];
    
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)selectTermitePhoto{
    
    Termitepicker = [[UIImagePickerController alloc] init];
    Termitepicker.delegate = self;
    Termitepicker.allowsEditing = YES;
    Termitepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:Termitepicker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    
  
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    [self MsgBoxShow:@"Image Uploading" withMessage:@"Your Image will be uploaded in the background"  withButtonLabel:@"Ok"];
    
  //  UIAlertView *someError2 = [[UIAlertView alloc] initWithTitle: @"Image Uploading" message: @"Your Image will be uploaded in the background"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    
   // [someError2 show];
    
   
        [NSThread detachNewThreadSelector:@selector(uploadImageBackground:) toTarget:self withObject:chosenImage];
   
    

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)uploadImageBackground:(UIImage *)image
{
    
    @autoreleasepool {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        
    //NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *urlString = @"https://ipadapp.bulwarkapp.com/hh/CustImage/uploadImage.aspx";
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"acct\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[photoAccount dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"hrempid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[delegate.hrEmpId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
    [body appendData:[photoType dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSMutableData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    

    NSLog(@"%@", returnString);

    }
    
}

- (void)emailImage:(UIImage *)image
{
    
   
   }
- (void)emailImageTermite:(UIImage *)image
{
    
    
    
     NSData *data = UIImagePNGRepresentation(image);


    
    
  
    
   

       NSString *messageBody = @"";

       NSArray *toRecipents = [NSArray arrayWithObject:@"termites@bulwarkpest.com"];



       MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];

       mc.mailComposeDelegate = self;
       [mc setSubject:@"Termite Activity Found"];
       [mc setMessageBody:messageBody isHTML:YES];
       [mc addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];

       [mc setToRecipients:toRecipents];

       [self presentViewController:mc animated:YES completion:NULL];

    
    
    
 
}


- (NSString *)Base64Encode:(NSString *)plainText
{
    

    
     NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];

    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [plainTextData base64EncodedStringWithOptions:0];
    
    
    
   
    //NSString *base64String = [plainTextData base64EncodedString];
    return base64Encoded;
}

- (NSString *)base64Decode:(NSString *)base64String
{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:base64String options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];

    return base64Decoded;
}

/*
- (NSString *)getIPAddress{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}
*/
-(void)sendResults:(NSURL *)url {
	
	//NSURL *url = Rurl;
	
	
	@autoreleasepool {

		
		NSString *Build = [self CurrentAppBuild];
		
		NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
		
		NSString *myPathDocs1 =  [documentsDirectory1 stringByAppendingPathComponent:@"rdate.tw"];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs1])
		{
			rdate = @"1/1/2000";
		}       	
		else {
			
			rdate = [[NSString alloc] initWithContentsOfFile:myPathDocs1 encoding:NSUTF8StringEncoding error:NULL];
		}
		//if (!url) { return NO;}
		NSString *surl = @"";
		NSString *URLString = [url absoluteString];
		
		NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
		
		//NSString *urlParamater = [paramater objectAtIndex: 2];
		
		NSString *spage =[paramater objectAtIndex: 1];
		

		
		NSArray *paramater1 = [URLString componentsSeparatedByString:@"!"];
		
		NSString *urlParamater1 = [paramater1 objectAtIndex: 1];		
			urlParamater1 = [urlParamater1 stringByReplacingOccurrencesOfString:@"routedatestring"
																	 withString:rdate];		
		urlParamater1 =  [urlParamater1 stringByAppendingString:@"&build="];
		urlParamater1 =  [urlParamater1 stringByAppendingString:Build];		

		

		
		
        surl = urlParamater1;
        //[urlParamater1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		
			NSError *err = [[NSError alloc] init];

			
		
		
		
		
        //NSString *escapedUrlString = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *responseString;
    NSURLResponse *response;
    //NSError *error;
		
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                             initWithURL:[NSURL URLWithString:surl]
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:5]; // 5 second timeout?
    
    [request setHTTPMethod:@"GET"];
		
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		

		
		
		
		
			
			if(err.code != 0) {
				
				//[self performSelectorOnMainThread:@selector(emailResults:) withObject:url waitUntilDone:YES];
					[self emailResults:url];
				
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
				
				if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
				{
					
				}  
				else {
					spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
				}		
				
				
				//NSURL *urlz = [NSURL URLWithString:spage];
				
				
			}	
			else {
					
				if((responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])){
					//NSLog(@"Recieved String Result: %@", responseString);

				@try {
		
				
				NSArray *paramater2 = [responseString componentsSeparatedByString:@"$"];
				
				NSString *successmsg = [paramater2 objectAtIndex: 1];
				
				spage =[paramater2 objectAtIndex: 2];			
				
				
				
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				
				
				successmsg = [successmsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				
                if ([successmsg isEqualToString:@"Success"]){
                    
                    [self MsgBoxShow:@"Success" withMessage:@"Posted Successfully" withButtonLabel:@"Ok"];
                    
					//UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Success" message: @"Posted Successfully" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
					
					//[someError show];
					// the path to write file
					NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"main"];
					
					[spage writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];	
				} else {
					//[self performSelectorOnMainThread:@selector(emailResults:) withObject:url waitUntilDone:YES];
					[self emailResults:url];
					
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					
					NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
					
					if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
					{
						
					}  
					else {
						spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
					}		
					
					
					//NSURL *urlz = [NSURL URLWithString:spage];
					
				}	
					
				}
					@catch (NSException * e) {
						//[self performSelectorOnMainThread:@selector(emailResults:) withObject:url waitUntilDone:YES];
						[self emailResults:url];
						
						NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
						NSString *documentsDirectory = [paths objectAtIndex:0];
						
						NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
						
						if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
						{
							
						}  
						else {
							spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
						}		
						
                        
                        NSLog(@"An exception occurred: %@", e.name);
                        NSLog(@"Here are some details: %@", e.reason);
						
						//NSURL *urlz = [NSURL URLWithString:spage];				}
				
				}						
			}
				
				
				
			
		
}
    
    
  	//[reqUrl release];
		
    NSString *decoded = [self Highlite:spage];

		NSURL *urlz = [NSURL URLWithString:decoded];

		NSURLRequest *request3 = [NSURLRequest requestWithURL:urlz];

        NSString *path4=@"";

        path4 = [[NSBundle mainBundle]
                 pathForResource:@"blank"
                 ofType:@"html"];

		NSURL *urlq = [NSURL fileURLWithPath:path4];

		NSString *theAbsoluteURLString = [urlq absoluteString];

		NSURL *finalURL = [NSURL URLWithString: theAbsoluteURLString];
		
		NSURLRequest *brequest = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //{
                
            [self->RouteWebView loadRequest:request3];
            [self->webView loadRequest:brequest];
            //}else{
           //     [webView loadRequest:request3];
           // }

            
            //[self->HUD hide:YES];
            [self.view hideToastActivity];
          
        });

	}
    
    
    
}


-(void) loadInBackground {

    @autoreleasepool {
        
        //[self CheckChemList];
        
        NSString *spage = @"";
        
        
        NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
        
        NSString *myPathDocs1 =  [documentsDirectory1 stringByAppendingPathComponent:@"rdate.tw"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs1])
        {
            rdate = @"1/1/2000";
        }
        else {
            
            rdate = [[NSString alloc] initWithContentsOfFile:myPathDocs1 encoding:NSUTF8StringEncoding error:NULL];
        }
        

        NSString *surl = @"https://ipadapp.bulwarkapp.com/refreshIphone.aspx?hr_emp_id=";
        
        surl =  [surl stringByAppendingString:delegate.hrEmpId];
        surl =  [surl stringByAppendingString:@"&date="];
        surl =  [surl stringByAppendingString:rdate];
        //surl =  [surl stringByAppendingString:@"&build="];
        //surl =  [surl stringByAppendingString:Build];

        surl =  [surl stringByAppendingString:@"&ipad=4"];
        
        
        
        //surl =
        //[surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
     
        
        
        NSError *err = [[NSError alloc] init];

        //NSString *escapedUrlString = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *responseString;
        NSURLResponse *response;
   
        
        NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:surl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
        
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
      
       
    
        
        if(err.code != 0) {

            
            
            
        }
        else {
            @try {
                
                if((responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])){
                    
                    NSArray *paramater = [responseString componentsSeparatedByString:@"?"];
                    
                    //NSString *urlParamater = [paramater objectAtIndex: 1];
                    
                    spage = [paramater objectAtIndex: 2];
                    
                    @try {
                        NSString *AlertTimes = [paramater objectAtIndex:3];
                        [self ScheduleAlertsForCall:AlertTimes];
                        
                    } @catch (NSException *exception) {
                        
                        NSLog(@"An exception occurred: %@", exception.name);
                        NSLog(@"Here are some details: %@", exception.reason);
                        
                    } @finally {
                        
                    }
                    
                    
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    // the path to write file
                    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"main"];
                    
                    [spage writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                    
                    
                    
                    NSString *decoded = [self Highlite:spage];
                    NSURL *qurl = [NSURL URLWithString:decoded];
                    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [self->RouteWebView loadRequest:srequest];
                         [self toastScreenAsync:@"Route Updated" withMessage:@""];
                        NSLog(@"Route Updated");
                        
                    });
                    
                    
                    
                    
                }
                else {
                    

                }
                
            }
            @catch (NSException * e) {
                
                
                
            }
            
        }
   
    }

}


-(void)MsgBoxShow:(NSString *)title withMessage:(NSString *)msg withButtonLabel:(NSString *)btnLabel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:btnLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
    }


-(void) emailResults:(NSURL *)url {
	
	//NSString *surl = @"";
	NSString *URLString = [url absoluteString];
	
	//NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
	
	//NSString *urlParamater = [paramater objectAtIndex: 2];
	
	//NSString *spage =[paramater objectAtIndex: 1];
	
	//double dpage = [spage doubleValue];
	// Example 1, loading the content from a URLNSURL
	//NSURL *urlz = [NSURL URLWithString:urlParamater];
	
	//NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
	//[webView loadRequest:request];		
	
	
	
	NSArray *paramater1 = [URLString componentsSeparatedByString:@"!"];
	
	NSString *urlParamater1 = [paramater1 objectAtIndex: 1];		
	urlParamater1 = [urlParamater1 stringByReplacingOccurrencesOfString:@"routedatestring"
															 withString:rdate];		
	
	
    
    [self SaveServiceFile:urlParamater1];
	
	/*
     MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Service Results Http"];
	[controller setMessageBody:urlParamater1 isHTML:NO];
	NSArray *toRecipients = [NSArray arrayWithObject:@"bulwarkrouteresults@gmail.com"];
	[controller setToRecipients:toRecipients];
	[self presentModalViewController:controller animated:YES];
	[controller release];
    
    */
	
	
}








-(void)SaveGPSFile:(NSString *)url {
    
    
    
    @try {
        
        
        NSString *name = [self CurrentTimeLabel];
        
        
        
        
        
        
        
        
        
        
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
        //documentsDirectory = [documentsDirectory stringByAppendingString:@"/send/"];
        //NSString *appFile = [[NSBundle mainBundle]
        //				  pathForResource:@"chemicalsused"
        //				  ofType:@"html"];
        // the path to write file
        
        NSString *Fname = @"";
        
        //NSString *inStr = [NSString stringWithFormat:@"%d", CurrentFile];
        
        Fname = [Fname stringByAppendingString:name];
        Fname = [Fname stringByAppendingString:@".gps"];
        
        
        
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:Fname];
        
        NSError *error1 = [[NSError alloc] init];
        
        [url writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:&error1];
        
        //CurrentFile = CurrentFile + 1;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	
	
}



-(void)CheckClockIn{
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
	
	NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"clockin.tw"];
	
    
    NSString * LastTruckDate = @"1/1/1900";
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
	{
		
	}
    else{
        LastTruckDate  = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        
        
        
        
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *today = [dateFormat dateFromString:[self CurrentDate]];// it will give you current date
    NSDate *newDate = [dateFormat dateFromString:LastTruckDate]; // your date
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:newDate]; // comparing two dates
    
    if(result==NSOrderedSame){
        NSLog(@"today is less");
    }
    else if(result==NSOrderedDescending){
        
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clock In" message:@"You havent Clocked In do you want to do so now?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
               // NSLog(@"Destructive");
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"OK");
                [self SaveClockInTime];
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    
                NSDate *today1 = [NSDate date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yyyy"];
                
                NSString *dateString11 = [dateFormat stringFromDate:today1];
                

                self->viewClockIn = [[viewMissedClockIn alloc]init];
                self->viewClockIn.delegate = self;
                self->viewClockIn->date = dateString11;
                self->viewClockIn->hr_emp_id = self->delegate.hrEmpId;
                self->viewClockIn.view.layer.borderWidth = 1;
                self->viewClockIn.view.layer.borderColor = UIColor.darkGrayColor.CGColor;
                self->viewClockIn.view.layer.cornerRadius = 5;
                //[viewClockIn setDate];
                CGRect nframe = CGRectMake(223, 320, 322, 322);
                
                self->viewClockIn.view.frame = nframe;
                
                
                
                self->viewClockIn.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self->viewClockIn.view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished){
                    // do something once the animation finishes, put it here
                }];
                
                
               
                    
                    [self.view addSubview:self->viewClockIn.view];
                    
                    
                    
                });
           
                                
                
                
               
               
                
                
                
                
            }];
            
            [alertController addAction:destructiveAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated: YES completion: nil];
        
        
        
        
        
        
        
        
        
        
        
        
     
    }
        
        
        
        

    
   
}

-(void)SaveClockInTime {
    
    
    
    @try {
        

    NSString *name = @"clockin.tw";
    
   
    
       
    
    
    
    
    
    
    
    

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@", [paths objectAtIndex:0]];

	

	
	
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:name];
	
	[[self CurrentDate] writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	
	
        
        //[self toastScreenAsync:@"Clocked In" withMessage:[self CurrentTimeOnly]];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	
	
}
-(void)SaveClockOutTime {
    
    
    
    @try {
        

    NSString *name = @"clockout.tw";

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@", [paths objectAtIndex:0]];


    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:name];
    
    [[self CurrentDate] writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}




-(void)SaveServiceFile:(NSString *)url {
    
   
    
    NSString *custGPS = @"";
    
    	NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    
    NSString *myPathDocs1 =  [documentsDirectory1 stringByAppendingPathComponent:@"LatLng"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs1])
    {
        
    }
    else {
        
       
        
        custGPS = [[NSString alloc] initWithContentsOfFile:myPathDocs1 encoding:NSUTF8StringEncoding error:NULL];
        
        
        
    }
    
    
    
    
    
    
    
    
    
    Boolean useGps = NO;
    NSString *name = [self CurrentTimeLabel];
    
    NSString *urlString = url;
	NSArray *comp1 = [urlString componentsSeparatedByString:@"?"];
	NSString *query = [comp1 lastObject];
	NSArray *queryElements = [query componentsSeparatedByString:@"&"];
	
	
	for (NSString *element in queryElements) {
		NSArray *keyVal = [element componentsSeparatedByString:@"="];
		NSString *variableKey = [keyVal objectAtIndex:0];
		
		NSString *value = [keyVal lastObject];
		
		if([variableKey isEqualToString: @"workorderitem_id"] == YES){
			name= value;
            useGps = YES;
		}
		
				
	}

    
    
    
    
    
    
    
    
    
	NSString * str = @"";
	str = [url stringByReplacingOccurrencesOfString:@"submitIphone"
										 withString:@"submitResults"];
    str= [str stringByReplacingOccurrencesOfString:@"68.14.234.84"
                                                             withString:@"205.38.65.5"];
    if(useGps){
    str = [str stringByAppendingString:custGPS];
    }
    
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];	
	//documentsDirectory = [documentsDirectory stringByAppendingString:@"/send/"];		
	//NSString *appFile = [[NSBundle mainBundle]
	//				  pathForResource:@"chemicalsused"
	//				  ofType:@"html"]; 				
	// the path to write file
	
	NSString *Fname = @"";
	
	//NSString *inStr = [NSString stringWithFormat:@"%d", CurrentFile];
	
	Fname = [Fname stringByAppendingString:name];
	Fname = [Fname stringByAppendingString:@".tw"];
	
	
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:Fname];
	
	[str writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	
	//CurrentFile = CurrentFile + 1;
	
	
	
}


-(void)SaveLat:(NSString *)lat {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"lat.tw"];
	
	[lat writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
}
-(void)SaveLon:(NSString *)lon {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"lon.tw"];
	
	[lon writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
}

-(NSString*)GetLon{
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
	
	NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"lon.tw"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
	{
		return @"0";
	}
	else {
		
		return [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
		
    }

    
    
    
}
-(NSString*)Getlat{
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
	
	NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"lat.tw"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
	{
		return @"0";
	}
	else {
		
		return [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
		
    }

    
    
    
}


-(NSString*)GetArrvTime{
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
	
	NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"ArriveTime"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
	{
		return @"1/1/1900 00:00";
	}
	else {
		
		return [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
		
    }
    
    
    
    
}


-(NSString *)Highlite:(NSString *)data{
    NSString *r= [self base64Decode:[data stringByReplacingOccurrencesOfString:@"data:text/html;charset=utf-8;base64," withString:@""]];
    
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];
	//NSString *documentsDirectory = [paths objectAtIndex:0];
	//documentsDirectory = [documentsDirectory stringByAppendingString:@"/send"];
	
	NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err;
    
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:&err];
	
	//NSFileManager *fileManager = [NSFileManager defaultManager];
	
	
    for (NSString *s in fileList){
		

		
		
		NSString *se = @".tw";
		NSRange ra = [s rangeOfString:se];
		
		if(ra.location !=NSNotFound){
			
			
			
			NSString *myPathDocs2 =  [documentsDirectory stringByAppendingPathComponent:s];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
			{
				
			}
			else {
				NSString *newstr = [s stringByReplacingOccurrencesOfString:se withString:@""];
                
                NSString *rep = [newstr stringByAppendingString:@" style=\"background-color:White"];
                NSString *rep1 = [newstr stringByAppendingString:@" style=\"background-color:#F4F47F"];
                
				r = [r stringByReplacingOccurrencesOfString:rep withString:@" style=\"background-color:#3399CC"];
                
				
				r = [r stringByReplacingOccurrencesOfString:rep1 withString:@" style=\"background-color:#3399CC"];
                
                
							
			
			
                
                
            }
		
		
		

    }
    }
    

    
    NSString *rVal = [@"data:text/html;charset=utf-8;base64," stringByAppendingString:[self Base64Encode:r]];
   

    
    return rVal;
}

	

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
   
    [controller dismissViewControllerAnimated:YES completion:^{[self cycleTheGlobalMailComposer];}];
    
     
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			// FAILS
			//exit(0);
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    
	
	 
}



-(void)dateTimePicker:(NSString *)date{
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *minimumTime = [formatter dateFromString:date];
    NSLog(@"minimumTime Formatted %@", minimumTime);

    
    [ClockOutDate setMinimumDate:minimumTime];
    
    int daysToAdd = 1;
    NSDate *newDate1 = [minimumTime dateByAddingTimeInterval:60*60*23*daysToAdd];
    
   
    NSDate *newDate2 = [minimumTime dateByAddingTimeInterval:60*60*17*daysToAdd];
    [ClockOutDate setMaximumDate:newDate1];
    [ClockOutDate setDate:newDate2];
    ClockBack.hidden = NO;
    ClockButton.hidden = NO;
    ClockOutDate.hidden=NO;
    clockoutlabel.hidden=NO;
    ClockButtonCancel.hidden=NO;
    NSString *txt =@"You did not clock out on ";
    
    txt = [txt stringByAppendingString:date];
    txt = [txt stringByAppendingString:@" please enter your clock out time"];
    
    clockoutlabel.text = txt;
    
    
    
}
-(IBAction)btncancelClockOut{
    ClockBack.hidden = YES;
    ClockButton.hidden = YES;
    ClockOutDate.hidden=YES;
    clockoutlabel.hidden=YES;
    ClockButtonCancel.hidden=YES;

}

    
-(IBAction)btnFixClockOut{
    
    ClockBack.hidden = YES;
    ClockButton.hidden = YES;
    ClockOutDate.hidden=YES;
    clockoutlabel.hidden=YES;
     ClockButtonCancel.hidden=YES;
    
    NSDate *date = ClockOutDate.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy%20HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
   NSString *txt = dateString;
   
    NSString *fdataUrl = @"https://ipadapp.bulwarkapp.com/Clock.aspx?hr_emp_id=";
    fdataUrl =  [fdataUrl stringByAppendingString:delegate.hrEmpId];
    
    
    fdataUrl =  [fdataUrl stringByAppendingString:@"&type=2&time="];
    
    
    

    
   
    
    //NSString *spage1 = @"Clock IN ";
    fdataUrl=  [fdataUrl stringByAppendingString:txt];
    
    
    [self SaveServiceFile:fdataUrl];

    

    
    
    [self sendFilesToServerAsync];
    
    
}

-(void)ClockOutCancel:(NSString *)str{
    
    [viewClockOut.view removeFromSuperview];
}
-(void)ClockInCancel:(NSString *)str{
    
    //[viewClockIn.view removeFromSuperview];
    
    
    viewClockIn.view.transform = CGAffineTransformIdentity;
   [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       self->viewClockIn.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
   } completion:^(BOOL finished){
       self->viewClockIn.view.hidden = YES;
   }];
    
}

-(void)ClockOutSaved:(NSString *)str{
    [self SaveServiceFile:str];
    
    
    
    
    [viewClockOut.view removeFromSuperview];
    [self sendFilesToServerAsync];
     [self toastScreenAsync:@"Clocked Out" withMessage:@""];
    
}
-(void)ClockInSaved:(NSString *)str{
    [self SaveServiceFile:str];
    
    
  
    
    [viewClockIn.view removeFromSuperview];
    
    
    [self CheckClockOut];
    
    //[[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Clocked In" andMessage:timestr];
    
    [self toastScreenAsync:@"Clocked In" withMessage:@""];
    //[self sendFilesToServerAsync];
      [self sendFilesToServerAsync];
}


-(void)CheckClockOut{
    
    
    
    
    
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"clockout.tw"];
    
    
    NSString * LastTruckDate = @"1/1/1900";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        
    }
    else{
        LastTruckDate  = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        
        
        
        
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *today = [dateFormat dateFromString:[self CurrentDate]];// it will give you current date
    NSDate *newDate = [dateFormat dateFromString:LastTruckDate]; // your date
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:newDate]; // comparing two dates
    
    if(result==NSOrderedSame){
        NSLog(@"today is less");
    }
    else if(result==NSOrderedDescending){
        
        
        
 
    
    
    
    
    NSString *urlString = @"https://ipadapp.bulwarkapp.com/hh/checkclockout.aspx?h=";
    urlString = [urlString stringByAppendingString:delegate.hrEmpId];

        
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:[NSURL URLWithString:urlString]
                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                             timeoutInterval:3.0];
    
    
 
        
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {

            if (error == nil)
            {
                // Parse data here
                
                NSString  *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                
                if([responseString isEqualToString:@"ok"]){
                    [self SaveClockOutTime];
                }else{
                    
                    
                    self->viewClockOut = [[viewMissedClockOut alloc]init];
                    self->viewClockOut.delegate = self;
                    self->viewClockOut->date = responseString;
                    self->viewClockOut->hr_emp_id = self->delegate.hrEmpId;
                    self->viewClockOut.view.layer.borderWidth = 1;
                    self->viewClockOut.view.layer.borderColor = UIColor.darkGrayColor.CGColor;
                    self->viewClockOut.view.layer.cornerRadius = 5;
                    //[viewClockOut setDate];
                    CGRect nframe = CGRectMake(223, 320, 322, 322);

                    self->viewClockOut.view.frame = nframe;
                    
                    self->viewClockOut.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self->viewClockOut.view.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished){
                        // do something once the animation finishes, put it here
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    [self.view addSubview:self->viewClockOut.view];
                        
                    });
                }
                
                
                
            }        }] resume];
    
  
    
      
        
        

    }
    
}

-(void)ScheduleAlertsForCall:(NSString *)strList{
   
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
        
        int cnt = (int)[arrayOfLocalNotifications count];
        
        if(cnt >0){
            for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
                
                //if ([localNotification.alertBody isEqualToString:savedTitle]) {
                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                
                // }
                
            }
            
        }
        
        
        
        NSArray *paramater = [strList componentsSeparatedByString:@"~"];
        
        
        
        for (id object in paramater) {
            // do something with object
            
            NSArray *items = [object componentsSeparatedByString:@","];
            
            int elements = (int)[items count];
            
            if(elements == 2){
                
                
                NSString *timeblockstart =[items objectAtIndex: 0];
                //NSString *AccountNum = [items objectAtIndex: 1];
                NSString *msg = [items objectAtIndex: 1];
                
                NSString *PhnNumber = @"";
                
                
                int strlen = (int)msg.length - 10;
                
                PhnNumber = [msg substringWithRange:NSMakeRange(strlen, 10)];
                

                
                
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // this is imporant - we set our input date format to match our input string
                // if format doesn't match you'll get nil from your string, so be careful
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                NSDate *dateFromString = [[NSDate alloc] init];
                // voila!
                dateFromString = [dateFormatter dateFromString:timeblockstart];
                
                
                
                NSDate *today = [NSDate date]; // it will give you current date
                
                
                NSComparisonResult result;
                //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
                
                result = [today compare:dateFromString]; // comparing two dates
                
                if(result==NSOrderedAscending){
                    
                    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                    localNotification.fireDate = dateFromString;
                    localNotification.alertBody = msg;
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.alertTitle = PhnNumber;
                    localNotification.alertAction=@"Call Now";
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    
                    
                    NSLog(@"Notification Scheduled");
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
        }
        
        
        
    });

  

    
    
    
    
    
}

-(void)loadRoute{
	@autoreleasepool {	
	
		[self CheckChemList];
		
		NSString *spage = @"";

		
		NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
		
		NSString *myPathDocs1 =  [documentsDirectory1 stringByAppendingPathComponent:@"rdate.tw"];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs1])
		{
			rdate = @"1/1/2000";
		}       	
		else {
			
			rdate = [[NSString alloc] initWithContentsOfFile:myPathDocs1 encoding:NSUTF8StringEncoding error:NULL];
		}
		
		//UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Printer" message: @"data sent to printer"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		//[someError show];
		//[someError release];	
		NSString *surl = @"https://ipadapp.bulwarkapp.com/refreshIphone.aspx?hr_emp_id=";
		
		surl =  [surl stringByAppendingString:delegate.hrEmpId];
		surl =  [surl stringByAppendingString:@"&date="];
		surl =  [surl stringByAppendingString:rdate];
		//surl =  [surl stringByAppendingString:@"&build="];
		//surl =  [surl stringByAppendingString:Build];

            surl =  [surl stringByAppendingString:@"&ipad=4"];
 
        
        
		//surl = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

		
		
		NSError *err = [[NSError alloc] init];
		//NSString *url1 = [surl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		//NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:&err];
		
		
		
        //NSString *escapedUrlString = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *responseString;
    NSURLResponse *response;
    //NSError *error;
		
    NSURLRequest *request = [[NSMutableURLRequest alloc] 
                             initWithURL:[NSURL URLWithString:surl]
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:20]; // 5 second timeout?
		
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		
		
		
		
		
		
		
		
		
		if(err.code != 0) {
            
            
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
			{
				
			}  
			else {
				spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
			}
			
            dispatch_async(dispatch_get_main_queue(), ^{
                [self toastScreenAsync:@"Copy" withMessage:@"Copy of route loaded couldnt connect to server"];
            });
        
			

            
		}
		else {
			@try {

				if((responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])){
					
					NSArray *paramater = [responseString componentsSeparatedByString:@"?"];
			
			//NSString *urlParamater = [paramater objectAtIndex: 1];
			
                    spage = [paramater objectAtIndex: 2];
                    
                    @try {
                        NSString *AlertTimes = [paramater objectAtIndex:3];
                        [self ScheduleAlertsForCall:AlertTimes];
                        
                    } @catch (NSException *exception) {
                        
                        NSLog(@"An exception occurred: %@", exception.name);
                        NSLog(@"Here are some details: %@", exception.reason);
                        
                    } @finally {
                        
                    }
                    
			
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			// the path to write file
			NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"main"];
			
			[spage writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self toastScreenAsync:@"Route Updated" withMessage:@""];
                    });
                
                
				}
					else {
						NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
						NSString *documentsDirectory = [paths objectAtIndex:0];
						
						NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
						
						if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
						{
							
						}  
						else {
							spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self toastScreenAsync:@"Copy" withMessage:@"Copy of route loaded couldnt connect to server"];
                            });

						}
					}
				
			}
			@catch (NSException * e) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"main"];
				
				if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
				{
					
				}  
				else {
					spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
				}
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self toastScreenAsync:@"Copy" withMessage:@"Copy of route loaded couldnt connect to server"];
                });
 
				
				
			}
		
		}
		
		
		
		//[reqUrl release];
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// Example 2, loading the content from a string
		//NSString *HTMLData = spage;
		//[webView loadHTMLString:HTMLData baseURL:nil];
    
    
    NSString *decoded = [self Highlite:spage];
    
		
		NSURL *qurl = [NSURL URLWithString:decoded];
		
		NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        
        
        NSString *path4=@"";
        
        
        
        
        path4 = [[NSBundle mainBundle]
                 pathForResource:@"blank"
                 ofType:@"html"];
        
        
        
		NSURL *urlq = [NSURL fileURLWithPath:path4];
		
		
		
		NSString *theAbsoluteURLString = [urlq absoluteString];
        
		
		
		
		NSURL *finalURL = [NSURL URLWithString: theAbsoluteURLString];
		
		NSURLRequest *brequest = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		
        dispatch_async(dispatch_get_main_queue(), ^{
            //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            //{
                
            [self->RouteWebView loadRequest:srequest];
            [self->webView loadRequest:brequest];
            //}else{
               //    [webView loadRequest:srequest];
            //}
       
        

     
            //[self->HUD hide:YES];
       
            [self.view hideToastActivity];
	
	 });
	
	
	

	}	
	
	//[activityIndicator stopAnimating];		
	//[self performSelectorOnMainThread:@selector([webView loadRequest:srequest]) withObject:nil waitUntilDone:NO];

}

-(void)CheckChemList{
	
	NSString *Build = [self CurrentAppBuild];	
	
	
	
	
	
	
	
	NSArray *paths3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory3 = [paths3 objectAtIndex:0];
	NSString *myPathDocs3 =  [documentsDirectory3 stringByAppendingPathComponent:@"appBuild"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs3]){
		
		[self DownloadChemicalList];
		
		[Build writeToFile:myPathDocs3 atomically:YES encoding:NSUTF8StringEncoding error:NULL];	
	}  
	else {	
		
		
		
		
		NSString *lastbuild = [[NSString alloc] initWithContentsOfFile:myPathDocs3 encoding:NSUTF8StringEncoding error:NULL];		
		
		
		
		
		if([lastbuild isEqualToString: Build])
		{
			// do something
			
			// the path to write file
			
		}
		else {
			//download chem list
			
			[self DownloadChemicalList];
			[Build writeToFile:myPathDocs3 atomically:YES encoding:NSUTF8StringEncoding error:NULL];
			
		}
		
	}	
}

-(void)DownloadChemicalList{
	

	NSString *offcode =delegate.office;
    
    if([offcode length] ==0){
        offcode = @"ME";
    }
  //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  //  {
   //     offcode =[office stringByReplacingOccurrencesOfString:@"5" withString:@""];
   // }
    
    
	NSString *downloadFile = @"https://ipadapp.bulwarkapp.com/chemicalsusediphone";
	downloadFile= [downloadFile stringByAppendingString:offcode];
	downloadFile= [downloadFile stringByAppendingString:@".html"];
	
	
	//downloadFile =
	//[downloadFile stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	
	NSError *err = [[NSError alloc] init];
	//NSString *url = [downloadFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:downloadFile] encoding:NSUTF8StringEncoding error:&err];
	
	
	
	
	if(err.code != 0) {
//unable to downloasd
		
		
	}
	else {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		

		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
		
		[myTxtFile writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
		 NSLog(@"Chemical list Downloaded");
			
	}
	
	
	







	
	
}

/*
-(void)DownloadChemicalList2{
	@autoreleasepool {	

        NSString *offcode =delegate.office;
        
     //   if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     //   {
     //       offcode =[office stringByReplacingOccurrencesOfString:@"5" withString:@""];
      //  }
        
        
        NSString *downloadFile = @"https://ipadapp.bulwarkapp.com/chemicalsusediphone";
        downloadFile= [downloadFile stringByAppendingString:offcode];
        downloadFile= [downloadFile stringByAppendingString:@".html"];
        
		
		downloadFile =
		[downloadFile stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];				
		
		NSError *err = [[NSError alloc] init];
		NSString *url = [downloadFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
		
		
		
		
		if(err.code != 0) {
			//UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Download" message: @"Unable to Download New Chemical List" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			
			//[someError show];
			//[someError release];
        
        [self toastScreenAsync:@"Chemicals" withMessage:@"Unable to download try again later"];
			
			
		}
		else {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			

			NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
			
			[myTxtFile writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
			

         NSLog(@"Chemical list Downloaded");
        [self toastScreenAsync:@"Chemicals" withMessage:@"Download Complete"];
		}
		
		
		
		
		[HUD hide:YES];
	
	
	
	
	
	
	}	
	
	
	
	
	
	
	
	
}
-(void)DownloadChemicalList3{
	@autoreleasepool {

        NSString *offcode =delegate.office;
        
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       // {
       //     offcode =[office stringByReplacingOccurrencesOfString:@"5" withString:@""];
       // }
        
        
        NSString *downloadFile = @"https://ipadapp.bulwarkapp.com/chemicalsusediphone";
        downloadFile= [downloadFile stringByAppendingString:offcode];
        downloadFile= [downloadFile stringByAppendingString:@".html"];
        
		
		downloadFile =
		[downloadFile stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
		
		NSError *err = [[NSError alloc] init];
		NSString *url = [downloadFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
		
		
		
		
		if(err.code != 0) {

            
            [self toastScreenAsync:@"Chemicals" withMessage:@"Unable to download try again later"];
			
			
		}
		else {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			

			NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
			
			[myTxtFile writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
			

            NSLog(@"Chemical list Downloaded");
            [self toastScreenAsync:@"Chemicals" withMessage:@"Download Complete"];
		}
		
		
		
		
		
        
        
        
        
        
        
	}
	
	
	
	
	
	
	
	
}
*/

-(void)loadAvailable{
	@autoreleasepool {	
	
        
	
		NSString *spage = @"";
		
	//	hrEmpId = @"12345";
	//	empName = @"";
	//	password = @"";
		
		
		
		NSString *Build = [self CurrentAppBuild];	
		
		
		
		
		[self CheckChemList];
		
		
		

		
		NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
		
		NSString *myPathDocs1 =  [documentsDirectory1 stringByAppendingPathComponent:@"rdate.tw"];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs1])
		{
			rdate = @"1/1/2000";
		}       	
		else {
			
			rdate = [[NSString alloc] initWithContentsOfFile:myPathDocs1 encoding:NSUTF8StringEncoding error:NULL];
		}
		
		
		NSDate *today1 = [NSDate date];
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
		
		NSString *dateString11 = [dateFormat stringFromDate:today1];	
		
		//NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
		
		
		
		NSString *surl = @"https://ipadapp.bulwarkapp.com.com/AvailableIpad.aspx?hr_emp_id=";
		surl =  [surl stringByAppendingString:delegate.hrEmpId];
		surl =  [surl stringByAppendingString:@"&date="];
		surl =  [surl stringByAppendingString:dateString11];
		surl =  [surl stringByAppendingString:@"&build="];
		surl =  [surl stringByAppendingString:Build];


		
		//surl = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		
		
		
		NSError *err = [[NSError alloc] init];
		//NSString *url1 = [[NSString stringWithFormat:surl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		//NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:&err];
		
		
		
        //NSString *escapedUrlString = [surl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *responseString;
    NSURLResponse *response;
    //NSError *error;
		
    NSURLRequest *request = [[NSMutableURLRequest alloc] 
                             initWithURL:[NSURL URLWithString:surl]
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:30]; // 5 second timeout?
		
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
		
		
		
		
		
		
		
		
		
		if(err.code != 0) {		
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"available"];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
			{
				
			}  
			else {
				spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
			}
			
			
            [self toastScreenAsync:@"Copy" withMessage:@"Copy Loaded could not connect to server"];
    


		
			
		}
		else {
			@try {
				
				if((responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])){
					
					
					
					
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					
					// the path to write file
					NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"available"];
					
					[responseString writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
					spage = responseString;
                [self toastScreenAsync:@"Update" withMessage:@"Route Updated"];
				}
				else {
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					
					NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"available"];
					
					if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
					{
						
					}  
					else {
						spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
					}
				}
				
			}
			@catch (NSException * e) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"available"];
				
				if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
				{
					
				}  
				else {
					spage = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
				}
                [self toastScreenAsync:@"Copy" withMessage:@"Copy Loaded could not connect to server"];
				
			}
			
		}
		
		
		
		//[reqUrl release];
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
       // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       // {
            PopUpWebView.hidden=NO;
            [PopUpWebView loadHTMLString:spage baseURL:nil];
            
        //}else{
        //    [webView loadHTMLString:spage baseURL:nil];
        //}

		

		
		
		
		
		
		//[HUD hide:YES];
        [self.view hideToastActivity];
	
	
	
	
	
	}	
	
	//[activityIndicator stopAnimating];		
	//[self performSelectorOnMainThread:@selector([webView loadRequest:srequest]) withObject:nil waitUntilDone:NO];
	
}





-(NSDate*)ConvertToDate:(NSString *)stringDate{
   
    
    NSString *dateString = stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM/dd/yyy HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
    
    
    
    
}
-(NSString*)CurrentDate{
	
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	
	return dateString;
}

-(NSString*)CurrentTime{
	
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	
	return dateString;
}
-(NSString*)CurrentTimeOnly{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}
-(NSString*)CurrentTimeLabel{
	
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-HH-mm-ss"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	
	return dateString;
}
-(NSString*)CurrentTimeUrl{
	
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyy%20HH:mm:ss"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	
	return dateString;
}
-(NSString*)CurrentFastCommTomorrow{
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay
                                       value:1
                                      toDate:[NSDate date]
                                     options:0];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyy"];
    
    dateString = [formatter stringFromDate:tomorrow];
    
    dateString = [dateString stringByAppendingString:@"%2004:00"];
    
    
    return dateString;
    
    
    
}
    


-(NSString*)CurrentTimeTimeOnly{
	
	
	NSDateFormatter *formatter;
	NSString        *dateString;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"hh:mm tt"];
	
	dateString = [formatter stringFromDate:[NSDate date]];
	
	
	return dateString;
}
-(void)toastScreenAsync:(NSString *)sTitle withMessage:(NSString *)sMessage{
	
    
    NSString *msg = sTitle;
    msg = [msg stringByAppendingString:@" "];
    msg= [msg stringByAppendingString:sMessage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:msg];
    });
  
    
    
   // [[[[iToast makeText:NSLocalizedString(msg, @"")]
    //   setGravity:iToastGravityBottom] setDuration:3000] show];
    
    //[NSThread detachNewThreadSelector:@selector(toastScreen:)
	//						 toTarget:self
	//					   withObject:[NSArray arrayWithObjects:sTitle,
	//								   sMessage, nil]];
}

-(void)loadappdetails:(NSString*)appid {
    NSString* searchurl = [@"https://itunes.apple.com/lookup?id=" stringByAppendingString:appid];

    [self performSelectorInBackground:@selector(asyncload:) withObject:searchurl];

}
-(void)asyncload:(NSString*)searchurl {
    NSURL* url = [NSURL URLWithString:searchurl];
    NSError* error = nil;
    NSString* str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"str: %@", str);
}


-(NSString*)getStringFromSite:(NSString *)urlstr{


    //NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    //NSString *encodedUrl = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSError *err = [[NSError alloc] init];
    NSString *strVal = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlstr] encoding:NSUTF8StringEncoding error:&err];
    
    if(err.code != 0) {
        return @"Error";
        

    }else{
        return strVal;
    }
    
}



    
    
    
    
-(BOOL)zipGPS{
    /*
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
    BOOL isDir=NO;
    NSArray *subpaths;
    NSString *exportPath = docDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    
    NSString *archivePath = [docDirectory stringByAppendingString:@".zip"];
    
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    for(NSString *path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:path];
        }
    }
    BOOL successCompressing = [archiver CloseZipFile2];
    return successCompressing;
    */
    return YES;
}
-(BOOL)zipServices{
    
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
    BOOL isDir=NO;
    NSArray *subpaths;
    NSString *exportPath = docDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    
    NSString *archivePath = [docDirectory stringByAppendingString:@".zip"];
    
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    for(NSString *path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:path];
        }
    }
    BOOL successCompressing = [archiver CloseZipFile2];
    return successCompressing;
    */
    return YES;
}

-(void)zipEmail{
    
    if ([MFMailComposeViewController canSendMail])
    {
        
        
        
        
        
        

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
    BOOL isDir=NO;
    NSArray *subpaths;
    NSString *exportPath = docDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    
   // NSString *archivePath = [docDirectory stringByAppendingString:@"services.zip"];
    
   // NSString *archivePath1 = [docDirectory stringByAppendingString:@"gps.zip"];
   // NSString *archivePath2 = [docDirectory stringByAppendingString:@"settings"];
    
    
    
    if([self zipServices] && [self zipGPS]){

    

        
        NSString *messageBody = @"";

        NSArray *toRecipents = [NSArray arrayWithObject:@"titans@bulwarkpest.com"];



        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];

        mc.mailComposeDelegate = self;
        [mc setSubject:@"Application Problem "];
        [mc setMessageBody:messageBody isHTML:YES];
        //[mc addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];

        [mc setToRecipients:toRecipents];

        [self presentViewController:mc animated:YES completion:NULL];
    
       // ReportProblemEmailViewController *rpemail = [[ReportProblemEmailViewController alloc] init];
       
        
       //  rpemail.emlSubject =[@"Application Problem " stringByAppendingString:delegate.hrEmpId];
    //    rpemail.attach1 = archivePath;
     //   rpemail.attach2 = archivePath1;
      //  rpemail.attach3 = archivePath2;
        
        
        //[self.view addSubview:[rpemail view]];
        
        
    
}
    else{

           //NSLog(@"Fail");
    }
    }
    else
    {
        
        
        [self MsgBoxShow:@"Failure" withMessage:@"Email Not Set Up" withButtonLabel:@"Ok"];
      
       
    }
    
    

}



/*

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{


    
  
    
    if(alertView == alertTruck){
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        
        if([self isANumber:[[alertView textFieldAtIndex:0] text]]){
            
            
            
            
            NSString *string = [[alertView textFieldAtIndex:0] text];
            int value = [string intValue];
            
            if(value >0 && value<60){
                
                //UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"test" message: @"number"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                
                //[someError show];
                //[someError release];
            
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                
                //NSString *appFile = [[NSBundle mainBundle]
                //				  pathForResource:@"chemicalsused"
                //				  ofType:@"html"];
                // the path to write file
                NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"truck"];
                
                [string writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                
                NSString *appFile1 = [documentsDirectory stringByAppendingPathComponent:@"lasttruck"];
                
                [[self CurrentTime] writeToFile:appFile1 atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                
                
                
            }
            else {
                alertTruck = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Truck # must be between 1 and 60" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
                alertTruck.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alertTruck textFieldAtIndex:0];
                alertTextField.keyboardType = UIKeyboardTypeNumberPad;
                alertTextField.placeholder = @"Enter truck number only";
                [alertTruck show];
                
            }
            

            
        }
        else
        {
            
            alertTruck = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Truck # enter only the truck number" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            alertTruck.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * alertTextField = [alertTruck textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            alertTextField.placeholder = @"Enter truck number only";
            [alertTruck show];
            
            
        }
        
        
        
    }

	
	

    

    
	
	
}

*/





-(BOOL)isANumber:(NSString *)s {
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];
    return [numberPredicate evaluateWithObject:s];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

/*
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/

#pragma mark - Serial Connect Delegates

- (IBAction)btnTestSerial{
    
    
  //  if(textView.hidden==NO){
  //      textView.hidden=YES;
  //  }else{
  //      textView.hidden=NO;
  //  }
    
}



//- (void) registerForNotifications {
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(_accessoryConnected:)
     name:EAAccessoryDidConnectNotification
      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(_accessoryDisconnected:)
     name:EAAccessoryDidDisconnectNotification
     object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    */
//}



//- (void) _accessoryConnected:(NSNotification *)notification {

   // EAAccessory* connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    //NSString* accessoryName = [[NSString alloc] initWithString:[connectedAccessory name]];
   
//}
//- (void) _accessoryDisconnected:(NSNotification *)notification {
   
   // EAAccessory* disconnectedAccessory = [[notification userInfo]
   //                                       objectForKey:EAAccessoryKey];
//}

//- (void) accessoryDidDisconnect:(EAAccessory *)accessory {

   // [self dispatchDelegate:@selector(scanToolDidDisconnect:)
              //  withObject:nil];
//}


/*

#pragma mark - RscMgrDelegate methods

- (void) cableConnected:(NSString *)protocol {
   
   // UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Serial" message: @"Connected"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	//[someError show];
	//[someError release];
   // textView.text =[textView.text stringByAppendingString:@"Serial cable Connected\n"];
    
    [rscMgr setBaud:9600];
    [rscMgr setDtr:YES];
    
    [rscMgr setRts:NO];
   
	[rscMgr open];
    
    //txBuffer[0] = 'p';
    
    
    
    [rscMgr write:txBuffer length:1];
    //[rscMgr write:@"a" Length:1];
    //[toolbar setTintColor:[UIColor blueColor]];
    
    [printIcon setTintColor: nil];

    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
}

- (void) cableDisconnected {
   // UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Serial" message: @"Disconnected"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	//[someError show];
	//[someError release];
    
    //[toolbar setTintColor:[UIColor whiteColor]];

 [printIcon setTintColor: [UIColor clearColor]];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    
}

- (void) portStatusChanged {
    
}

- (void) readBytesAvailable:(UInt32)length {
     //UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Serial" message: @"reveive data"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	//[someError show];
	//[someError release];
    

    
    //if(length >0){

    
 //   if(cnt>60){
   //     cnt = 0;
     //   textView.text = @"";
    //}
    //cnt +=1;
    
     //   @try {
         
       

    
   // [rscMgr read:rxBuffer Length:length];
    
   // NSString *rfid = [[NSString alloc] initWithBytes:rxBuffer length:length encoding:NSUTF8StringEncoding];
    

    
    //textView.text =[textView.text stringByAppendingString:rfid];
          
            
      //      NSRange textRange;
       //     textRange =[rfid rangeOfString:@"$"];
            
        //    if(textRange.location != NSNotFound)
        //    {
                
        //        [self SaveGPSFile:incommingData];
        //        incommingData = @"";
                
               // textView.text=@"done";
                
        //    }else{
         //         incommingData = [incommingData stringByAppendingString:rfid];
                
               // textView.text =[textView.text stringByAppendingString:@"."];
                
         //   }
  
    

            
            
        //     }
      //  @catch (NSException *exception) {
           // UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Exception" message: @"reveive data"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
           // [someError show];
           // [someError release];
      //  }
      //  @finally {
            
      //  }
  // }
    
    
  
    

    
    
    
    
    
    
}

- (BOOL) rscMessageReceived:(UInt8 *)msg TotalLength:(int)len {
    
    
    //NSString *str = [[NSString alloc] initWithBytes:msg length:len encoding:NSUTF8StringEncoding];
    

    
    //textView.text = [NSString stringWithUTF8String: (char *)msg];
    
    
    
    
    return FALSE;
}

- (void) didReceivePortConfig {
}

#pragma mark- DFBlunoDelegate

-(void)bleDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.blunoManager scan];
    }
}
-(void)didDiscoverDevice:(DFBlunoDevice*)dev
{
    
    
    //DFBlunoDevice* device = [self.aryDevices objectAtIndex:indexPath.row];
    if (self.blunoDev == nil)
    {
        self.blunoDev = dev;
        [self.blunoManager connectToDevice:self.blunoDev];
    }
    else if ([dev isEqual:self.blunoDev])
    {
        if (!self.blunoDev.bReadyToWrite)
        {
            [self.blunoManager connectToDevice:self.blunoDev];
        }
    }
    else
    {
        if (self.blunoDev.bReadyToWrite)
        {
            [self.blunoManager disconnectToDevice:self.blunoDev];
            self.blunoDev = nil;
        }
        
        [self.blunoManager connectToDevice:dev];
    }
    
    
    
    
    [self.blunoManager stop];

}
-(void)readyToCommunicate:(DFBlunoDevice*)dev
{
    
    self.blunoDev = dev;
  //  [toolbar setTintColor:[UIColor greenColor]];
  //  [self.locationManager stopUpdatingLocation];
    [gpsIcon setTintColor: nil];
    
    //self.lbReady.text = @"Ready!";
}
-(void)didDisconnectDevice:(DFBlunoDevice*)dev
{
    
    [self.blunoManager scan];
   // [toolbar setTintColor:[UIColor whiteColor]];
  //  [self.locationManager stopUpdatingLocation];

    
    [gpsIcon setTintColor: [UIColor clearColor]];
    
    
    //self.lbReady.text = @"Not Ready!";
}
-(void)didWriteData:(DFBlunoDevice*)dev
{
    
}


-(void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev
{
    


    
   
    
    @try {

    NSString *recdata =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
        
        
    for (int i = 0; i < [recdata length]; i++) {
        NSString *ch = [recdata substringWithRange:NSMakeRange(i, 1)];
        
        
        if(ch != nil){
            
        
    
    
    
    
    if([ch isEqualToString:@"~"]){
        
        
        NSLog(@"%@", @"Ping");
        
        
        NSLog(@"%@", recdata);
        // textView.text = [@"\n" stringByAppendingString:textView.text];
       // textView.text = [recdata stringByAppendingString:textView.text];
        
        
        
        
        
       
        NSString *nstr = @"~";
        NSData* data = [nstr dataUsingEncoding:NSUTF8StringEncoding];
        [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
        
    } else{
    
        
        if([ch isEqualToString:@"\n"]){
            
        }
        
        
        
        if([ch isEqualToString:@"\n"]){
            NSLog(@"%@\n", GpsString);
            

          
            NSArray *arr = [GpsString componentsSeparatedByString:@","];
            
    if(arr.count == 7){
      // textView.text = [GpsString stringByAppendingString:textView.text];
            NSString *sLat = [arr objectAtIndex:0];
            NSString *sLon = [arr objectAtIndex:1];
            NSString *sSpeed = [arr objectAtIndex:2];
        
        
        double cal = [sSpeed doubleValue] * 0.44704;
        NSString *dSpeed =[NSString stringWithFormat:@"%.1f",cal];
        
        
       // 0.44704
        
            NSString *sDist = [arr objectAtIndex:3];
             NSString *sCourse = [arr objectAtIndex:4];
        NSString *sTruck =[arr objectAtIndex:5];
            NSString *sDate = [arr objectAtIndex:6];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSDate * eventDate = [dateFormatter dateFromString:sDate];
            
            
            NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
            [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [df_utc setDateFormat:@"MM/dd/yyyy,HH:mm:ss"];
            
            [self SaveLat:sLat];
            [self SaveLon:sLon];
            
            
            
        NSString *gpsStr = @"&t=";
        
        gpsStr = [gpsStr stringByAppendingString:sTruck];
        gpsStr = [gpsStr stringByAppendingString:@"&data="];
        
        gpsStr = [gpsStr stringByAppendingString:[df_utc stringFromDate:eventDate]];
        
            gpsStr = [gpsStr stringByAppendingString:@","];
            gpsStr = [gpsStr stringByAppendingString:sLat];
            gpsStr = [gpsStr stringByAppendingString:@","];
            gpsStr = [gpsStr stringByAppendingString:sLon];
            gpsStr = [gpsStr stringByAppendingString:@","];
            gpsStr = [gpsStr stringByAppendingString:sCourse];
            gpsStr = [gpsStr stringByAppendingString:@","];
            gpsStr = [gpsStr stringByAppendingString:dSpeed];
            gpsStr = [gpsStr stringByAppendingString:@","];
            gpsStr = [gpsStr stringByAppendingString:sDist];
            
            
            NSString *custGps = @"&lat=";
            
            custGps = [custGps stringByAppendingString:sLat];
            custGps = [custGps stringByAppendingString:@"&lng="];
            custGps = [custGps stringByAppendingString:sLon];
            
            //[self toastScreenAsync:@"GPS" withMessage:custGps];
           
                
                
         [self SaveGPSFile:gpsStr];
            
            [self saveLastlatLng:custGps];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            
            NSDateFormatter* df_utc1 = [[NSDateFormatter alloc] init];
            
            [df_utc1 setDateFormat:@"MM/dd/yyyy hh:mm a"];
              [df_utc1 setTimeZone:[NSTimeZone systemTimeZone]];
            float timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT] / 3600.0);
            NSDate *newDate = [eventDate dateByAddingTimeInterval:timezoneoffset];
            
            NSString *appFile1 = [documentsDirectory stringByAppendingPathComponent:@"ArriveTime"];
        
        NSString *artime = [df_utc1 stringFromDate:newDate];
            [artime writeToFile:appFile1 atomically:YES encoding:NSUTF8StringEncoding error:NULL];

            
        
        
           //
            
            }
            
            GpsString = @"";
            
            
        }else{
            if([ch isEqualToString:@"\r"]){
                
            }else{
                GpsString = [GpsString stringByAppendingString:ch];}
        }
        
        

        
    }
    
    
    }

        
    }
        
        }
    @catch (NSException *exception) {
        NSLog(@"An exception occurred: %@", exception.name);
        NSLog(@"Here are some details: %@", exception.reason);
    }
    @finally {
        
    }
    

    //NSLog(@"%@", @"tttt");
    //self.lbReceivedMsg.text = [self.lbReceivedMsg.text stringByAppendingString:recdata];
}



-(void)saveLastlatLng:(NSString *)str{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    //NSString *appFile = [[NSBundle mainBundle]
    //				  pathForResource:@"chemicalsused"
    //				  ofType:@"html"];
    // the path to write file
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"LatLng"];
    
    [str writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    
    
    
}
*/

#pragma mark- TWBlunoDelegate

-(void)printDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.printManager scan];
    }
}

-(void)didDiscoverPrinter:(DFBlunoDevice *)dev
{
    
    
    //DFBlunoDevice* device = [self.aryDevices objectAtIndex:indexPath.row];
    if (self.printDev == nil)
    {
        self.printDev = dev;
        [self.printManager connectToDevice:self.printDev];
    }
    else if ([dev isEqual:self.printDev])
    {
        if (!self.printDev.bReadyToWrite)
        {
            [self.printManager connectToDevice:self.printDev];
        }
    }
    else
    {
        if (self.printDev.bReadyToWrite)
        {
            [self.printManager disconnectToDevice:self.printDev];
            self.printDev = nil;
        }
        
        [self.printManager connectToDevice:dev];
    }
    
    
    
    
    [self.printManager stop];
    // BOOL bRepeat = NO;
    // for (DFBlunoDevice* bleDevice in self.aryDevices)
    // {
    //    if ([bleDevice isEqual:dev])
    //    {
    //        bRepeat = YES;
    //        break;
    //     }
    // }
    // if (!bRepeat)
    // {
    //     [self.aryDevices addObject:dev];
    // }
    //[self.tbDevices reloadData];
}
-(void)readyToPrint:(DFBlunoDevice*)dev
{
    
    self.printDev = dev;
    //[toolbar setTintColor:[UIColor blueColor]];
    //[self.locationManager stopUpdatingLocation];
    
    //self.lbReady.text = @"Ready!";
    
   [printIcon setTintColor: [UIColor whiteColor]];
    
    
    
}
-(void)didDisconnectPrinter:(DFBlunoDevice*)dev
{
    
    [self.printManager scan];
    //[toolbar setTintColor:[UIColor blueColor]];
    
   [printIcon setTintColor: [UIColor clearColor]];
    //[self.locationManager stopUpdatingLocation];
    
    //self.lbReady.text = @"Not Ready!";
}
-(void)didPrintData:(DFBlunoDevice*)dev
{
    
}
-(void)didReceiveDataP:(NSData*)data Device:(DFBlunoDevice*)dev
{
    

}


-(IBAction)btnScreenShot{

    
    
    

    
    
    

    
    
    // void (*BKSDisplayServicesSetScreenBlanked)(BOOL blanked) = (void (*)(BOOL blanked))dlsym(RTLD_DEFAULT, "BKSDisplayServicesSetScreenBlanked");
    
   // BKSDisplayServicesSetScreenBlanked(0);
    
    
   /* viewClockOut = [[viewMissedClockOut alloc]init];
    viewClockOut.delegate = self;
    viewClockOut->date = @"11/20/2015";
    viewClockOut->hr_emp_id = delegate.hrEmpId;
    [viewClockOut setDate];
    CGRect nframe = CGRectMake(0, 20, 322, 322);
    
    viewClockOut.view.frame = nframe;
    
    
    [UIView transitionWithView:self.view duration:0.55
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^ { [self.view addSubview:viewClockOut.view]; }
                    completion:nil];

    
    
    
    
    
    
    */
    
    CGRect grabRect = CGRectMake(20, 20, 768, 955);
    
    //for retina displays
    
    UIGraphicsBeginImageContextWithOptions(grabRect.size, NO, 0.0);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextTranslateCTM(ctx, -grabRect.origin.x, -grabRect.origin.y);
    //[self.view.layer renderInContext:ctx];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    
    
    

    
    if([MFMailComposeViewController canSendMail]){
 
    
    
    
    NSString *emailTitle = @"ScreenShot";
    NSString *messageBody = @"Here is a screenshot";
    NSArray *toRecipents = [NSArray arrayWithObject:@"titans@bulwarkpest.com"];
    
    //NSArray *bcc = [NSArray arrayWithObjects:@"DoorSales@bulwarkpest.com", nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    // Determine the file name and extension
    //   NSArray *filepart = [file componentsSeparatedByString:@"."];
    NSString *filename = @"SScreenShot.png";
    // NSString *extension = [filepart objectAtIndex:1];
    
    //  // Get the resource path and read the file using NSData
    //  NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    //  NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    // Determine the MIME type
     NSData *imageData = UIImagePNGRepresentation(viewImage);
    
    // Add attachment
    [mc addAttachmentData:imageData mimeType:@"image/png" fileName:filename];
    
    // Present mail view controller on screen
   // [self presentViewController:mc animated:YES completion:NULL];
    
    
    }
    
    
}


-(IBAction)btnTest{
    
  //  UIDevice.currentDevice.isProximityMonitoringEnabled = TRUE;
    //UIDevice.current.isProximityMonitoringEnabled = true;
    /*
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Account:103328 01:00 to 04:00 Call:On the Way";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertTitle = @"4807455226";
    localNotification.alertAction=@"Call Now";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TechnicianApp"]];
    
   // NSLog(@"%@\n", testdata);
   // [delegate ShowDrivingFrm];
   // delegate.driving = YES;
  //  driving=YES;
    */
    
}

-(IBAction)gestOpenMap{
    NSLog(@"%@\n", @"2Finger Tap Recognized");
    
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    /*
     
     if(segue.identifier == "OpenMapsSegue"){
         
             let displayVC = segue.destination as! viewRouteMap
         displayVC.rurl = mapDate
     }
     */
    if ([segue.identifier isEqualToString:@"OpenWebView"]) {
       viewPopupWeb *vC = [segue destinationViewController];
        vC.url = popWebViewUrl;
        //[vC openContract];
        //[vC openContractWithContractUrl:popWebViewUrl];
    }
}





@end

