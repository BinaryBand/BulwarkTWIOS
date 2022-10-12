//
//  viewDriving.m
//  BulwarkTW
//
//  Created by Terry Whipple on 4/11/16.
//
//

#import "viewDriving.h"
#import "BulwarkTWAppDelegate.h"

@interface viewDriving ()

@end

@implementation viewDriving{
    
   // BulwarkTWAppDelegate *delegate;
   // int refreshing;
    
    
}



/*
- (void)webViewDidStartLoad:(UIWebView *)nWebView {
    

        [HUD show:YES];

}

- (void)webViewDidFinishLoad:(UIWebView *)nWebView {
   

        
        [HUD hide:YES];
        
    
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   // [self LoadRouteListData];
    
    
    // Do any additional setup after loading the view from its nib.
}



/*
-(void)LoadRouteListData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
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
        
        
        
        
        
        

        
        

            [webview loadRequest:srequest];
        
        

    
    
    }
    
    
    
    
    
    
}


-(NSString *)Highlite:(NSString *)data{
    NSString *r= [self base64Decode:[data stringByReplacingOccurrencesOfString:@"data:text/html;charset=utf-8;base64," withString:@""]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];

    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err;
    
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:&err];

    
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



*/

-(void)UpdateSpeed:(NSString *)Speed
{
    
    
    
    currSpeed.text = Speed;
    
    
}

/*

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



*/





















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
