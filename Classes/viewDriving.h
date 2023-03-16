//
//  viewDriving.h
//  BulwarkTW
//
//  Created by Terry Whipple on 4/11/16.
//
//
#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"


@interface viewDriving : UIViewController{
    
    
    IBOutlet UILabel *lblVin;
    
    IBOutlet UILabel *lblOdo;
    IBOutlet UILabel *currSpeed;
    IBOutlet UILabel *lbldtcdist;
    
}

-(void)UpdateSpeed:(NSString *)Speed;
-(void)UpdateODO:(NSString *)Odometer;


-(void)UpdateVin:(NSString *)vin;

-(void)UpdateReadTime:(NSString *)dtcdist;


@end
 
 
       
 
