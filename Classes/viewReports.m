//
//  viewReports.m
//  BulwarkTW
//
//  Created by Terry Whipple on 1/25/16.
//
//

#import "viewReports.h"
#import "BulwarkTWAppDelegate.h"
#import "BulwarkTW-Swift.h"
#import "UIView+Toast.h"

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
    backButton.hidden = YES;
    popView.hidden = YES;
    webviewDetails.navigationDelegate = self;
    webviewDetails.UIDelegate = self;
    
    
    
    webviewReports.navigationDelegate = self;
    webviewReports.UIDelegate = self;
   
    
    
    
    //HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view addSubview:HUD];
    //[HUD hide:YES];
    
    NSURL *qurl = [NSURL URLWithString:_url];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewReports loadRequest:srequest];
    
    
    
   
    
}

- (void) receiveLoadReportNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.

    if ([[notification name] isEqualToString:@"LoadReport"]){
        
        NSURL *qurl = [NSURL URLWithString:delegate.reportUrl];
        
        NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
        [webviewReports loadRequest:srequest];
        
    }
        //NSLog (@"Successfully received the test notification!");
    
    
}


/*
- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
    [HUD hide:YES];
}
*/

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    /*
    // Log out the message received
    NSLog(@"Received event %@", message.body);
    
    // Then pull something from the device using the message body
    NSString *version = [[UIDevice currentDevice] valueForKey:message.body];
    
    // Execute some JavaScript using the result
    NSString *exec_template = @"set_headline(\"received: %@\");";
    NSString *exec = [NSString stringWithFormat:exec_template, version];
    [webView evaluateJavaScript:exec completionHandler:nil];
     */
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
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
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
        [self.view makeToastActivity:CSToastPositionCenter];
       // [self->HUD show:YES];
    });
    NSLog(@"didStartProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation: %@navigation, error: %@", navigation, error);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishLoadingNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self->HUD hide:YES];
        [self.view hideToastActivity];
        
        
    });
    NSLog(@"didFinishLoadingNavigation: %@", navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation: %@, error %@", navigation, error);
}

- (void)_webViewWebProcessDidCrash:(WKWebView *)webView {
    NSLog(@"WebContent process crashed; reloading");
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
    NSLog(@"didFinish: %@; stillLoading:%@", [webView URL], (webView.loading?@"NO":@"YES"));
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
   // if(webView != self.wkWebView) {
   //     decisionHandler(WKNavigationActionPolicyAllow);
    //    return;
   // }
    
    UIApplication *app1 = [UIApplication sharedApplication];
    NSURL         *url = navigationAction.request.URL;
    
   // if (!navigationAction.targetFrame) {
        //if ([app1 canOpenURL:url]) {
            //[app1 openURL:url];
           // decisionHandler(WKNavigationActionPolicyCancel);
           // return;
        //}
    //}
    if ([url.scheme isEqualToString:@"maps"])
    {
       // if ([app1 canOpenURL:url])
       // {
        [app1 openURL:url options:@{} completionHandler:nil];
        //[app1 openURL:options:completionHandler::url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        //}
    }
    
    if ([url.scheme isEqualToString:@"comgooglemaps"])
    {
       // if ([app1 canOpenURL:url])
       // {
            
            NSString *mapsurllink = [url.absoluteString stringByReplacingOccurrencesOfString:@"comgooglemaps://?q=" withString:@""];
            
                NSString *Mstring = @"comgooglemaps://?directionsmode=driving&daddr=";
            Mstring = [Mstring stringByAppendingString:mapsurllink];
            
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            
        [app1 openURL:[NSURL URLWithString:Mstring] options:@{} completionHandler:nil];
            //[app1 openURL:[NSURL URLWithString:Mstring]];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    
    //[[UIApplication sharedApplication] openURL:url];
    
    
    if ([url.scheme isEqualToString:@"bulwarktw"])
    {
       // if ([app1 canOpenURL:url])
        //{
           // [app1 openURL:url];
        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"bulwarktwreports"])
    {
       // if ([app1 canOpenURL:url])
       // {
           // [app1 openURL:url];
        [app1 openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"bulwarktwmap"])
    {
       // if ([app1 canOpenURL:url])
       // {
        [app1 openURL:url options:@{} completionHandler:nil];
           // [app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"prefs"])
    {
       // if ([app1 canOpenURL:url])
       // {
        [app1 openURL:url options:@{} completionHandler:nil];
            //[app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
   decisionHandler(WKNavigationActionPolicyAllow);
}















-(void)loadWebViewDetails:(NSString *)UrlString{
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webviewDetails loadRequest:srequest];
    webviewDetails.hidden = NO;
    closeButton.hidden = NO;
    backButton.hidden = NO;
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
       
        NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/hh/retention/rptaddtoroute.aspx?customer_id=";
        
        
        
        UrlStr = [UrlStr stringByAppendingString:urlParamater];
        
        
        
        
        
        
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
        
        
        
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        NSError *err = nil;
        
        NSString *html = [NSString stringWithContentsOfURL:qurl encoding:NSUTF8StringEncoding error:&err];
        
        if(err)
        {
            
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Loading" message:@"Error Adding to route please contact support" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
            [self presentViewController:alertController animated:YES completion:^{}];
            
            //UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error Loading" message: @"Error Adding to route please contact support"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
            //[someError show];
            
            
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Done"  message:html preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
            [self presentViewController:alertController animated:YES completion:^{}];
            
          //  UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Done" message: html  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
           // [someError show];
            
        }
        

        
    }
    
    
    
    
    
}









- (IBAction)btnCloseWindow{
    webviewDetails.hidden = YES;
    closeButton.hidden = YES;
    backButton.hidden = YES;
    popView.hidden = YES;
    
}
- (IBAction)btnBack{
    
    if([webviewDetails canGoBack]){
        [webviewDetails goBack];
    }
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if ([segue.identifier isEqualToString:@"ReportsMenue"]) {
    //    viewRetReports *customViewController = (viewRetReports *)segue.destinationViewController;
        
    //}
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
  
      //  if([segue.identifier isEqualToString:@"OpenMapsSegue"]){
          // viewRouteMap *Vc = segue.destinationViewController;
            
           // Vc.rurl = RouteUrl;
            
            

        //}

    
    
    
//}









@end
