//
//  viewMissedClockIn.m
//  BulwarkTW
//
//  Created by Terry Whipple on 11/2/17.
//

#import "viewMissedClockIn.h"

@interface viewMissedClockIn ()

@end

@implementation viewMissedClockIn

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setDate];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel{
    
    [self.delegate ClockInCancel:@"Cancel"];
    
  
    
}
- (IBAction)btnSave{
    
    NSDate *date1 = ClockInDate.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy%20HH:mm"];
    NSString *dateString = [formatter stringFromDate:date1];
    NSString *txt = dateString;
    
    NSString *fdataUrl = @"https://ipadapp.bulwarkapp.com/Clock.aspx?hr_emp_id=";
    fdataUrl =  [fdataUrl stringByAppendingString:hr_emp_id];
    
    
    fdataUrl =  [fdataUrl stringByAppendingString:@"&type=1&time="];
    
    
    
    
    
    
    
    //NSString *spage1 = @"Clock IN ";
    fdataUrl=  [fdataUrl stringByAppendingString:txt];
    
    
    [self.delegate ClockInSaved:fdataUrl];
    
}

- (void)setDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *minimumTime = [formatter dateFromString:date];
    NSLog(@"minimumTime Formatted %@", minimumTime);
    
    
    [ClockInDate setMinimumDate:minimumTime];
    
    int daysToAdd = 1;
    NSDate *newDate1 = [minimumTime dateByAddingTimeInterval:60*60*23*daysToAdd];
    
    
    NSDate *newDate2 = [minimumTime dateByAddingTimeInterval:60*60*17*daysToAdd];
    [ClockInDate setMaximumDate:newDate1];
    
    NSDate *today1 = [NSDate date];

    
    [ClockInDate setDate:today1];
    
    NSString *txt =@"You did not clock in Today ";
    
    txt = [txt stringByAppendingString:date];
    txt = [txt stringByAppendingString:@" please enter your clock In time"];
    
    lblMsg.text = txt;
    
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
