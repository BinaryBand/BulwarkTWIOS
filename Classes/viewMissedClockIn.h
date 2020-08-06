//
//  viewMissedClockIn.h
//  BulwarkTW
//
//  Created by Terry Whipple on 11/2/17.
//

#import <UIKit/UIKit.h>

@protocol viewMissedClockInDelegate <NSObject>
- (void)ClockInSaved:(NSString *)str;
- (void)ClockInCancel:(NSString *)str;
@end

@interface viewMissedClockIn : UIViewController{
    
    
    IBOutlet UILabel *lblMsg;
    IBOutlet UIDatePicker *ClockInDate;
    
@public NSString *date;
@public NSString *hr_emp_id;
    
    
    
    
}

@property (assign) id <viewMissedClockInDelegate> delegate;

- (IBAction)btnCancel;
- (IBAction)btnSave;
- (void)setDate;




@end
