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
    
  
    delegate.viewSched = self;
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
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
        [self->HUD show:YES];
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
        [self->HUD hide:YES];
       
        
        
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
        [self->HUD hide:YES];
    });
    NSLog(@"didFinish: %@; stillLoading:%@", [webView URL], (webView.loading?@"NO":@"YES"));
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
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
            [app1 openURL:url];
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
            
            
            [app1 openURL:[NSURL URLWithString:Mstring]];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    
    //[[UIApplication sharedApplication] openURL:url];
    
    
    if ([url.scheme isEqualToString:@"bulwarktw"])
    {
       // if ([app1 canOpenURL:url])
        //{
            [app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"bulwarktwreports"])
    {
       // if ([app1 canOpenURL:url])
       // {
            [app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"bulwarktwmap"])
    {
       // if ([app1 canOpenURL:url])
       // {
            [app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    if ([url.scheme isEqualToString:@"prefs"])
    {
       // if ([app1 canOpenURL:url])
       // {
            [app1 openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
       // }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}











-(void)handleRefresh:(UIRefreshControl *)refresh {
   
    refreshing =1;
    NSString *UrlString = @"https://ipadapp.bulwarkapp.com/hh/retention/rptRouteSummary.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&build=60"];
    
    
    NSURL *qurl = [NSURL URLWithString:UrlString];
    
    NSURLRequest *srequest = [NSURLRequest requestWithURL:qurl];
    [webview loadRequest:srequest];
    
    
}

- (void)handleReload:(NSString *)url{
    
    
    [self getSchedule];
}

-(void) getSchedule{
    
    
    
    
    
    NSString *UrlString = @"https://ipadapp.bulwarkapp.com/hh/retention/rptRouteSummary.aspx?hr_emp_id=";
    
    UrlString = [UrlString stringByAppendingString:delegate.hrEmpId];
    UrlString = [UrlString stringByAppendingString:@"&build=60"];
    
    
    
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
