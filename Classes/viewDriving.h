//
//  viewDriving.h
//  BulwarkTW
//
//  Created by Terry Whipple on 4/11/16.
//
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface viewDriving : UIViewController{
    
    
   
    IBOutlet UILabel *currSpeed;
    
}

-(void)UpdateSpeed:(NSString *)Speed;


@end
