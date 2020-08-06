//
//  viewMissedClockOut.h
//  BulwarkTW
//
//  Created by Terry Whipple on 11/22/15.
//
//

#import <UIKit/UIKit.h>


@protocol viewMissedClockOutDelegate <NSObject>
- (void)ClockOutSaved:(NSString *)str;
- (void)ClockOutCancel:(NSString *)str;
@end

@interface viewMissedClockOut : UIViewController{
    
    
    IBOutlet UILabel *lblMsg;
    IBOutlet UIDatePicker *ClockOutDate;
    
    @public NSString *date;
    @public NSString *hr_emp_id;
    
    
    
    
}

@property (assign) id <viewMissedClockOutDelegate> delegate;

- (IBAction)btnCancel;
- (IBAction)btnSave;
- (void)setDate;




@end
