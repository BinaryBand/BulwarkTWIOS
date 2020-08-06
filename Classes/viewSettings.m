//
//  viewSettings.m
//  BulwarkTW
//
//  Created by Terry Whipple on 2/16/16.
//
//

#import "viewSettings.h"

//#import "ZipArchive/ZipArchive.h"




@interface viewSettings ()

@end

@implementation viewSettings{
    
    
    BulwarkTWAppDelegate *delegate;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    txtOffice.delegate = self;
    
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    appBuildString = [@"Version " stringByAppendingString:appBuildString];
    
    
    
    
    version.text = appBuildString;
    
    

    

    
    
    officeView.hidden = YES;
    [[officeView layer] setCornerRadius:10];
    [officeView setClipsToBounds:YES];
    [[officeView layer] setBorderColor:
     [[UIColor darkGrayColor] CGColor]];
    
    [[officeView layer] setBorderWidth:2.75];
    
    
    
    
    
    
    
    
    
    [NSThread detachNewThreadSelector:@selector(UpdateOfficeList) toTarget:self withObject:nil];
     [NSThread detachNewThreadSelector:@selector(loadOffices) toTarget:self withObject:nil];
    
    [self getSettings];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSettings{
    
    
    
    
   // delegate.hrEmpId = @"12345";
  //  delegate.name = @"";
    //delegate.password = @"";
  //  delegate.license = @"";
  //  delegate.office = @"";
  //  delegate.phone = @"";
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"settings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        
    }
    else {
        
        
        NSString *settingsFile = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        NSArray *paramater2 = [settingsFile componentsSeparatedByString:@"$"];
        
        @try {
            
            delegate.name = [paramater2 objectAtIndex: 0];
        
        delegate.hrEmpId = [paramater2 objectAtIndex: 1];
        
        //delegate.password = [paramater2 objectAtIndex: 2];
        
            delegate.license = [paramater2 objectAtIndex: 3];
            
            delegate.office = [paramater2 objectAtIndex: 4];
            delegate.phone = [paramater2 objectAtIndex: 5];
            
            
            txtName.text = delegate.name;
            txtHrEmpId.text = delegate.hrEmpId;
            txtLicense.text = delegate.license;
            txtOffice.text = delegate.office;
            txtPhoneNumber.text = delegate.phone;
            
            
            
        }
        @catch (NSException * e) {
            //NSString *except =	@"office";
            
            
        }
        
        
        
    }
    
    

    
    
    
    
    
}

-(void)loadOffices{
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"offices"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {

  
        
        NSString *OfficeFile = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        _listOfficeName = [OfficeFile componentsSeparatedByString:@"$"];
        
        [picker reloadAllComponents];

    }else{
        
        [self UpdateOfficeList];
       
        
    }
    

    
    
    
    
    
}


-(void)UpdateOfficeList{
    
    
    
    NSString *urlStr = @"https://www.bulwarktechnician.com/hh/office/listofficeipads.aspx";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    // Create a NSURLRequest with the given URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    
    // Get the data
    NSURLResponse *response;
    
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error==nil){
        
        
        NSString  *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"offices"];
        
        [responseString writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        //[HUD show:YES];
        
        
    }
    
    
    
 [self loadOffices];
    

    
    
}


-(void)saveSettings{
    
    
    NSString *hrEmpId = txtHrEmpId.text;
    
    
    NSString *password = @"password";
    
    NSString *empName = txtName.text;
    NSString *license = txtLicense.text;
    NSString *office = txtOffice.text;
    //NSString *Phone = txtPhoneNumber.text;
    
    NSString *Phone =  [[txtPhoneNumber.text componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                            componentsJoinedByString:@""];
    
    
    NSArray *offList = [office componentsSeparatedByString:@","];
    
    NSString *OffCode = @"ME";
    
    
    if(offList.count==2){
        OffCode = offList[1];
    }
    
    NSString *settingStr = empName;
    
    settingStr =  [settingStr stringByAppendingString:@"$"];
    settingStr =  [settingStr stringByAppendingString:hrEmpId];
    settingStr =  [settingStr stringByAppendingString:@"$"];
    settingStr =  [settingStr stringByAppendingString:password];
    settingStr =  [settingStr stringByAppendingString:@"$"];
    settingStr =  [settingStr stringByAppendingString:license];
    settingStr =  [settingStr stringByAppendingString:@"$"];
    settingStr =  [settingStr stringByAppendingString:OffCode];
    settingStr =  [settingStr stringByAppendingString:@"$"];
    settingStr =  [settingStr stringByAppendingString:Phone];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    // the path to write file
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"settings"];
    
    [settingStr writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    delegate.hrEmpId = hrEmpId;
    delegate.license = license;
    delegate.office = OffCode;
    delegate.phone = Phone;
    
    
    
    
    
}


- (IBAction)btnReportProblem{
    
    [self zipEmail];
    
    
}
- (IBAction)btnCallSupport{
    
    
    
    
    if(txtPhoneNumber.text.length >7){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Phone" message:@"Call is being placed when your phone is answered it will bridge in support" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        NSString *Phone =  [[txtPhoneNumber.text componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                            componentsJoinedByString:@""];
        
        NSString *phn = @"4804294341";
        
        NSString *UrlStr = @"https://www.bulwarktechnician.com/phones/clicktocall.aspx?mp=";
        
        NSString *techPhone =  [[Phone componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""];
        
        UrlStr = [UrlStr stringByAppendingString:techPhone];
        UrlStr = [UrlStr stringByAppendingString:@"&d="];
        UrlStr = [UrlStr stringByAppendingString:phn];
        UrlStr = [UrlStr stringByAppendingString:@"&o="];
        UrlStr = [UrlStr stringByAppendingString:delegate.office];
        
        NSURL *qurl = [NSURL URLWithString:UrlStr];
        

        
       
        NSURLRequest *req = [ NSURLRequest requestWithURL:qurl
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:30.0 ];
        NSError *err;
        NSURLResponse *res;
        NSData *d = [ NSURLConnection sendSynchronousRequest:req
                                           returningResponse:&res
                                                       error:&err ];
        
        
        
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Phone" message:@"Please add in your phone number then try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }
    

}
- (IBAction)btnDownloadChemicals{
    

    
    
    
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Chemicals" message:@"Chemicals will download" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
      [alertView show];
    
    [NSThread detachNewThreadSelector:@selector(DownloadChemicalList3) toTarget:self withObject:nil];
    
}

- (IBAction)txtNameChanged{
    
    [self saveSettings];
    
}
- (IBAction)txtHRChanged{
    
    [self saveSettings];
    
}
- (IBAction)txtLicenseChanged{
    
    [self saveSettings];
    
}
- (IBAction)txtOfficeChanged{
    
    officeView.hidden = NO;
   
    [self.view endEditing:YES];
    
    //[txtHrEmpId becomeFirstResponder];
}
- (IBAction)txtPhoneChanged{
    
    
    [self saveSettings];
    
    
}

- (IBAction)btnSaveOffice{
    
    
    officeView.hidden = YES;
    
     [txtOffice resignFirstResponder];
    
    if(txtOffice.text.length >3){
        
        [self saveSettings];
        
        [NSThread detachNewThreadSelector:@selector(DownloadChemicalList3) toTarget:self withObject:nil];
        
        
    }
    
    
}



-(void)DownloadChemicalList3{
    @autoreleasepool {

        NSString *offcode =delegate.office;
        
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        // {
        //     offcode =[office stringByReplacingOccurrencesOfString:@"5" withString:@""];
        // }
        
        
        NSString *downloadFile = @"https://www.bulwarktechnician.com/chemicalsusediphone";
        downloadFile= [downloadFile stringByAppendingString:offcode];
        downloadFile= [downloadFile stringByAppendingString:@".html"];
        
        
        downloadFile =
        [downloadFile stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
        
        NSError *err = [[NSError alloc] init];
        NSString *url = [downloadFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
        
        
        
        
        if(err.code != 0) {
            
            
            [self toastScreenAsync:@"Chemicals" withMessage:@"Unable to download try again later"];
            
            
        }
        else {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            
            
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chemicalsused.html"];
            
            [myTxtFile writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            
            
            
            [self toastScreenAsync:@"Chemicals" withMessage:@"Download Complete"];
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}

-(void)toastScreenAsync:(NSString *)sTitle withMessage:(NSString *)sMessage{
    
    
    NSString *msg = sTitle;
    msg = [msg stringByAppendingString:@" "];
    msg= [msg stringByAppendingString:sMessage];
    
    
    [[[[iToast makeText:NSLocalizedString(msg, @"")]
       setGravity:iToastGravityBottom] setDuration:10000] show];
    
    //[NSThread detachNewThreadSelector:@selector(toastScreen:)
    //						 toTarget:self
    //					   withObject:[NSArray arrayWithObjects:sTitle,
    //								   sMessage, nil]];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TextField Begin Editing Method Called!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  //  [alertView show];
    [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TextField End Editing Method Called!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //[alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TextField Should Return Method Called!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
   // [alertView show];
    
    
    return YES;
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark Report Problem
/*
-(BOOL)zipGPS{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
    BOOL isDir=NO;
    NSArray *subpaths;
    NSString *exportPath = docDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    
    NSString *archivePath = [docDirectory stringByAppendingString:@".zip"];
    
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    for(NSString *path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:path];
        }
    }
    BOOL successCompressing = [archiver CloseZipFile2];
    return successCompressing;
    
}
-(BOOL)zipServices{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];
    BOOL isDir=NO;
    NSArray *subpaths;
    NSString *exportPath = docDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    
    NSString *archivePath = [docDirectory stringByAppendingString:@".zip"];
    
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:archivePath];
    for(NSString *path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
        {
            [archiver addFileToZip:longPath newname:path];
        }
    }
    BOOL successCompressing = [archiver CloseZipFile2];
    return successCompressing;
    
}

*/

-(void)zipEmail{
    
    if ([MFMailComposeViewController canSendMail])
    {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
        BOOL isDir=NO;
        NSArray *subpaths;
        NSString *exportPath = docDirectory;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
            subpaths = [fileManager subpathsAtPath:exportPath];
        }
        
    //    NSString *archivePath = [docDirectory stringByAppendingString:@"services.zip"];
        
     //   NSString *archivePath1 = [docDirectory stringByAppendingString:@"gps.zip"];
     //   NSString *archivePath2 = [docDirectory stringByAppendingString:@"settings"];
        
        
        
    //    if([self zipServices] && [self zipGPS]){
            
            
            
            
         //   ReportProblemEmailViewController *rpemail = [[ReportProblemEmailViewController alloc] init];
            
         //
         //   rpemail.emlSubject =[@"Application Problem " stringByAppendingString:delegate.hrEmpId];
         //   rpemail.attach1 = archivePath;
         //   rpemail.attach2 = archivePath1;
         //   rpemail.attach3 = archivePath2;
            
            
        //    [self.view addSubview:[rpemail view]];
        //    NSData *fileData1 = [NSData dataWithContentsOfFile:archivePath];
        //    NSData *fileData2 = [NSData dataWithContentsOfFile:archivePath1];
         //   NSData *fileData3 = [NSData dataWithContentsOfFile:archivePath2];
            
            
            
           	MFMailComposeViewController *controller2 = [[MFMailComposeViewController alloc] init];
            controller2.mailComposeDelegate = self;
            [controller2 setSubject:@"Problem In App"];
            [controller2 setMessageBody:@"" isHTML:NO];
          //  [controller2 addAttachmentData:fileData1 mimeType:@"application/zip" fileName:@"services.zip"];
          //  [controller2 addAttachmentData:fileData2 mimeType:@"application/zip" fileName:@"gps.zip"];
           // [controller2 addAttachmentData:fileData3 mimeType:@"application/zip" fileName:@"settings.txt"];
            
            NSArray *toRecipients = [NSArray arrayWithObject:@"titans@bulwarkpest.com"];
            [controller2 setToRecipients:toRecipients];
            [self presentViewController:controller2 animated:YES completion:nil];
            
            
            
            
            
            
   //     }
   //     else{
            
            //NSLog(@"Fail");
  //      }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your Email is not Set up"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
    
    
    
}





#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _listOfficeName.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _listOfficeName[row];
} 


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
   // float rate = [_exchangeRates[row] floatValue];
   // float dollars = [_dollarText.text floatValue];
   // float result = dollars * rate;
    
   //// NSString *resultString = [[NSString alloc] initWithFormat:
     //                         @"%.2f USD = %.2f %@", dollars, result,
    //                          _countryNames[row]];
   // _resultLabel.text = resultString;
    txtOffice.text = _listOfficeName[row];
    
    
    
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
