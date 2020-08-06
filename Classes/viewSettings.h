//
//  viewSettings.h
//  BulwarkTW
//
//  Created by Terry Whipple on 2/16/16.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BulwarkTWAppDelegate.h"
#import "iToast.h"


@interface viewSettings : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,MFMailComposeViewControllerDelegate>{
    
   IBOutlet UITextField *txtName;
   IBOutlet UITextField *txtHrEmpId;
   IBOutlet UITextField *txtPhoneNumber;
   IBOutlet UITextField *txtLicense;
   IBOutlet UITextField *txtOffice;
    
    
   IBOutlet UILabel *version;
    
    IBOutlet UIView *officeView;
    

    IBOutlet UIPickerView *picker;
    
    
}

@property (strong, nonatomic) NSArray *listOfficeName;
@property (strong, nonatomic) NSArray *listOfficeCode;

- (IBAction)btnReportProblem;
- (IBAction)btnCallSupport;
- (IBAction)btnDownloadChemicals;

- (IBAction)txtNameChanged;
- (IBAction)txtHRChanged;
- (IBAction)txtLicenseChanged;
- (IBAction)txtOfficeChanged;
- (IBAction)txtPhoneChanged;
- (IBAction)btnSaveOffice;

-(void)UpdateOfficeList;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;


@end
