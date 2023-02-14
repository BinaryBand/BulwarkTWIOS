//
//  CommissionReportsService.m
//  BulwarkTW
//
//  Created by Kole Pottorff on 8/10/20.
//

#import "PayrollDetailReportsService.h"
#import <BulwarkTW-Swift.h>
#import "BulwarkTWAppDelegate.h"
#import "ViewOne.h"


@implementation PayrollDetailReportsService{
    BulwarkTWAppDelegate *delegate2;

    UIButton *webviewbutton;
    //UIAlertView *askOpenReport;
    UIWindow *window2;
}
//static BOOL UIAlertShowing = false;
NSString *UpdatePushTokenUrl = @"https://kpwebapi.bulwarkapp.com/api/bulwarktwapp/updatepushtoken?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=%@&pushtoken=%@&deviceIdUUID=%@";
NSString *CheckForAvailableReportUrl = @"https://kpwebapi.bulwarkapp.com/api/payrollreports/commissionreportreadytoview?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=%@";
NSString *ReportUrl = @"https://kpwebapi.bulwarkapp.com/payrollreports/employee?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=%@&viewedby=%@";

- (void) doneButtonTapped{
    @try{
        NSLog(@"Done Button Tapped");
    }
    @catch(NSException *exc) {
        @try{
            NSString *logmessage = [NSString stringWithFormat:@"Error %s: %@", "doneButtonTapped", [exc reason]];
            NSLog(@"%@", logmessage);
        }@catch(NSException *exc){}
    }
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
    @try{
        /*
        CGRect nframe = CGRectMake(5, 24, delegate2.window.frame.size.width - 10, delegate2.window.frame.size.height - 32);
        self.view.frame = nframe;
        [HUD.superview bringSubviewToFront:HUD];
        [HUD hide:NO];
        
        self.view.hidden = false;
        // self.view.autoresizesSubviews = true;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 65, self.view.frame.size.width - 10, self.view.frame.size.height - 75)];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        
        NSString *hrempid = [self getHrEmpId];
        NSString *url = [NSString stringWithFormat:ReportUrl, hrempid,hrempid];
        
        NSURL *qurl = [NSURL URLWithString:url];
        
        //qurl = [NSURL URLWithString:@"https://servicesnapshot.bulwarkapp.com"];
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [self.webView loadRequest:srequest];
        
        
        @try{
            self.view.backgroundColor = [UIColor colorWithRed:234 green:234 blue:234 alpha:1];
        }@catch(NSException *excc){}
        
        
        if (@available(iOS 13.0, *)) {
            webviewbutton = [UIButton buttonWithType:UIButtonTypeClose];
            webviewbutton.frame = CGRectMake(1, 1, 50, 50);
            
        } else {
            // Fallback on earlier versions
            webviewbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [webviewbutton setTitle:@"Close" forState:UIControlStateNormal];
            webviewbutton.frame = CGRectMake(1, 1.0, 120.0, 40.0);
        }
        
        [webviewbutton addTarget:self
                          action:@selector(closeAd:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UIWindow *wind =  [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootc = [wind rootViewController];
        //  [rootc.view bringSubviewToFront:[self view]];
        [self.view addSubview:webviewbutton];
        
        [UIView transitionWithView:self.view duration:1
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [[[UIApplication sharedApplication] delegate].window  addSubview:[self view]]; }
                        completion:^(BOOL finished) {
            self.view.backgroundColor = [UIColor colorWithRed:234 green:234 blue:234 alpha:1];
            [self.view.superview bringSubviewToFront:self.view];
            [self.view bringSubviewToFront:self->webviewbutton];
            self.view.userInteractionEnabled = YES;
            self->webviewbutton.userInteractionEnabled = YES;
            self.webView.userInteractionEnabled = YES;
            [self.view bringSubviewToFront:self->webviewbutton];
        }];
        */
        
        /* for (UIView *view in self.view.superview.subviews) {
         if (!view.hidden && view != self.view ){                            }
         }*/
        
        //  self.view.superview.userInteractionEnabled = false;
    }@catch(NSException *exc){
        //NSString *fhdj = @"";
    }
}
/*-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
 for (UIView *view in self.view.subviews) {
 if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self.view convertPoint:point toView:view] withEvent:event])
 return YES;
 }
 return NO;
 }*/
- (void) closeAd: (UIButton*) sender{
    @try{
        [self.view removeFromSuperview];
    }
    @catch(NSException *exc) {
        @try{
            NSString *logmessage = [NSString stringWithFormat:@"Error %s: %@", "doneButtonTapped", [exc reason]];
            NSLog(@"%@", logmessage);
        }@catch(NSException *exc){}
    }
    
}
/*
 -(id) init{
 
 delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
 
 
 return [super init];
 }*/

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
       // HUD = [[MBProgressHUD alloc] initWithView:self.view];
       // [self.view addSubview:HUD];
        
        if(delegate2 == NULL  || delegate2 == nil){
            delegate2 = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
        }
       // if(askOpenReport == nil)
        //    askOpenReport =  [[UIAlertView alloc] initWithTitle:@"Commission Report Available"
        //                                                message:@"Your commission report for the last payperiod is now available. Would you like to view it now?"
        //                                               delegate:self cancelButtonTitle:@"Later"
         //                                     otherButtonTitles:@"View Commission Report",nil];
    }@catch(NSException *exc){}
}


/*
- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
    [HUD hide:YES];
    [self.view bringSubviewToFront:self.webView];
    webviewbutton.userInteractionEnabled = YES;
    [webviewbutton.superview bringSubviewToFront:webviewbutton];
    [self.view bringSubviewToFront:self.webView];
    self.webView.userInteractionEnabled = YES;
    
    UIWindow *wind =  [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootc = [wind rootViewController];
    [self.view.superview bringSubviewToFront:self.view];
}

*/

//- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
//{
   // @try{
     //   NSLog(@"Clicked Alert Button: %ld",(long)buttonIndex);
        
     //   if(buttonIndex == 0){
     //       NSLog(@"View Later Clicked - Not Displaying Commission Report");
            
    //    }
   //     if(buttonIndex > 0){
            
            
            //NSString *ReportUrl = @"https://kpwebapi.bulwarkapp.com/payrollreports/employee?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=%@&viewedby=%@";
             //     BulwarkTWAppDelegate *del = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
             //  NSString *hrempid = del.hrEmpId;
             
              //   NSString *url = [NSString stringWithFormat:ReportUrl, hrempid,hrempid];
                 
          //  NSURL *qurl = [NSURL URLWithString:url];
                 
            //[del.viewOne btnMyPay];
            //  NSURLRequest *request = [NSURLRequest requestWithURL:qurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
           // [del.viewOne handleOpenURL:qurl];
            /*  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
              {
                  [del.viewOne handleOpenURL:qurl];
                  PopUpWebView.hidden = NO;
                  [PopUpWebView loadRequest:request];
              }else{
                  [webView loadRequest:request];
              }*/
            
            
            
            
            
            // CommissionReportsService *ss = [[CommissionReportsService alloc] init];
            // delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
         /*   UIWindow *wind =  [[UIApplication sharedApplication] keyWindow];
            UIViewController *rootc = [wind rootViewController];
            [rootc.view addSubview:self.view];*/
            //[window2 addSubview:self.view];
    //    }
        
  //  }
  //  @catch(NSException *exc) {
        //  NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "OpenReportAlertView", [exc reason]];
        // NSLog(logmessage);
 //   }
//}
- (void) openReport:(UIWindow *)window{
    //@try{
        //window2 = window;
        /*if([CommissionReportsService askOpenReport] == NULL){
         self.askOpenReport  = [[UIAlertView alloc] initWithTitle:@"Commission Report Available"
         message:@"Your commission report for the last payperiod is now available. Would you like to view it now?"
         delegate:self cancelButtonTitle:@"Later"
         otherButtonTitles:@"View Commission Report",nil];
         }*/
       // if(askOpenReport == nil)
        //    askOpenReport  = [[UIAlertView alloc] initWithTitle:@"Payroll Detail Report Available"
        //                                                message:@"Your Payroll Detail report for the last payperiod is now available. Would you like to view it now?"
        //                                               delegate:self cancelButtonTitle:@"Later"
        //                                      otherButtonTitles:@"View Payroll Detail Report",nil];
        //if(askOpenReport.isVisible == false && askOpenReport.visible == false){
        //   [askOpenReport  show];
       // }
    //}
    //@catch(NSException *exc) {
        //@try{
           // NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "OpenPayrollDetailReport", [exc reason]];
          //  NSLog(logmessage);
        //}@catch(NSException *exc){}
   // }
    
}

-(NSString*) getHrEmpId{
    NSString *result = @"";
    @try{
        BulwarkTWAppDelegate *del = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
        result = del.hrEmpId;
    }@catch(NSException *exc){}
    return result;
}

-(BOOL) techHasPendingCommisionReport{
    
    BOOL result = false;
   /* @try{
        NSString *hrempid = [self getHrEmpId];
        if([hrempid length] == 0){
            NSLog(@"Comm. Report: No hr emp id");
            return result;
        }
        NSString *url = [NSString stringWithFormat:CheckForAvailableReportUrl, hrempid];
        NSLog(@"TechHasPendingCommissionReport Url: %@",url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200){
            NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
            
        }else{
            NSString *response = [[NSString alloc] initWithData:oResponseData encoding:NSASCIIStringEncoding];
            if([response rangeOfString:@"true"].location != NSNotFound || [response rangeOfString:@"True"].location != NSNotFound) {
                NSLog(@"Tech Has Pending Commission Report Available To View");
                result = true;
            }
            
        }
        if(result == false){
            NSLog(@"Tech Has NO Pending Commission Reports");
        }
    }
    @catch(NSException *exc) {
        @try{
            NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "TechHasPendingCommReport", [exc reason]];
            NSLog(logmessage);
        }@catch(NSException *exc){}
    }
    */
    return result;
}

-  (void)  updatePushToken:(NSData *)pushToken: (NSString *)deviceIdUUID{
    @try{
        
        NSString *token = [self hexadecimalStringFromData:pushToken];
        NSString *hrempid = [self getHrEmpId];
        
        if([hrempid length] == 0){
            NSLog(@"Comm. Report UpdatePushToken: No hr emp id");
            return;
        }
        if([token length] == 0 || [deviceIdUUID length] == 0){
            NSLog(@"Comm. Report - Update Push Token: Token or DeviceIdUUID Invalid");
            return;
        }
        
        NSString *url = [NSString stringWithFormat:UpdatePushTokenUrl, hrempid, token,deviceIdUUID];
        NSLog(@"UpdatePushToken Url: %@",url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error ];
        
        if([responseCode statusCode] != 200){
            NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
            
        }else{
            NSString *response = [[NSString alloc] initWithData:oResponseData encoding:NSASCIIStringEncoding];
            NSLog(@"UpdatePushToken Successful");
        }
        
    }
    @catch(NSException *exc) {
       // @try{
        //    NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "UpdatePushToken", [exc reason]];
        //    NSLog(logmessage);
       // }@catch(NSException *exc){}
        
    }
}

- (NSString *)hexadecimalStringFromData:(NSData *)data
{
    @try{
        NSUInteger dataLength = data.length;
        if (dataLength == 0) {
            return nil;
        }        
        const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
        NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
        for (int i = 0; i < dataLength; ++i) {
            [hexString appendFormat:@"%02x", dataBuffer[i]];
        }
        return [hexString copy];
    }@catch(NSException *exc){return @"";}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
