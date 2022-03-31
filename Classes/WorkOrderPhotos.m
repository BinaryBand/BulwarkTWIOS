//
//  WorkOrderPhotos.m
//  BulwarkTW
//
//  Example:
//      WorkOrderPhotos *WOP_Service = [[WorkOrderPhotos alloc] init];
//                                       //AccountNum //WorkOrderId
//      [WOP_Service SendWCFUPhotoMessage:@"324442" :@"11089355"];
//                                    //WorkorderId //ServiceType //Status
//      [WOP_Service SubmitWorkOrderBid:@"12123":@"T":@"status.."];
//


#import "WorkOrderPhotos.h"
#import "iToast.h"
#import <BulwarkTW-Swift.h>
#import "BulwarkTWAppDelegate.h"
#import "ViewOne.h"


@implementation WorkOrderPhotos{
    BulwarkTWAppDelegate *deleg;
}


NSString *accountNum;
NSString *woId;

static const NSString *SubmitWorkOrderBidURL = @"https://kpwebapi.bulwarkapp.com/api/bulwarktwapp/PostWorkOrderBid";

static const NSString *SubmitWorKOrderBidParameters = @"workorderId=%@&servicetype=%@&status=%@&mediaBase64=%@";

static const NSString *SubmitPhotoURL = @"https://servicesnapshot.bulwarkapp.com/api/servicesnapshot/SendMessageByWorkorderId";

static const NSString *SubmitPhotoParameters = @"accountNumber=%@&workOrderId=%@&body=%@&mediaBase64=%@&IsTest=%@&IsPhotoSubmission=%@&hrempid=%@&IsWCFU=%@&IsChatRelaySubmission=false";

-(id)init{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.showsCameraControls = YES;
    return self;
}

NSString *ServiceType;
NSString *Status;

bool submittingWorkOrderBid = false;

-(bool) SubmitWorkOrderBid:(NSString *)workOrderId :(NSString *)serviceType :(NSString *)status{
    
    @try{
        NSLog(@"SubmitWorkOrderBid");
        submittingWorkOrderBid = true;
             
        ServiceType = serviceType;
        woId = workOrderId;
        Status = status;
        [self takePhoto];
        
    }
    @catch(NSException *exc){
        NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "WorkOrderPhotosSubmitPhotoURL", [exc reason]];
       NSLog(logmessage);
        return NO;
    }
    
    
    return YES;
    
}



- (bool) SubmitMessage:(NSString *) accountNumber: (NSString *) workOrderId:(NSString *) msg: (bool) isPhotoSubmission:(NSString *) base64Photo: (bool) isWCFU{
    bool result =    [self SubmitMessage:accountNumber :workOrderId :msg: isPhotoSubmission :base64Photo :isWCFU:NO];
    return result;
}

- (bool) SubmitMessage:(NSString *) accountNumber: (NSString *) workOrderId:(NSString *) msg:(bool) isPhotoSubmission: (NSString *) base64Photo: (bool) isWCFU:(bool) isTest{
    @try{
        
        NSString *hrempid = [self getHrEmpId];
       
        NSString *url =SubmitPhotoURL; //[NSString stringWithFormat:SubmitPhotoURL, hrempid];
        
        if(submittingWorkOrderBid == YES){
            url = SubmitWorkOrderBidURL;
        }
        
        ///// TEMP OVERRIDE - REMOVE
        //isTest = true;
        
        if(isTest){
            if(submittingWorkOrderBid == YES){
                url = @"http://094b-184-4-51-47.ngrok.io/api/bulwarktwapp/PostWorkOrderBid";
            }
            else{
            url = @"http://094b-184-4-51-47.ngrok.io/api/servicesnapshot/SendMessageByWorkorderId";
            }
            
        }
        
        if(isPhotoSubmission){
            if(base64Photo == nil){
                return NO;
            }
        }
        
        NSString *isWCFUStr = isWCFU ? @"true" : @"false";
        NSString *isTestStr = isTest ? @"true" : @"false";
        NSString *isPhotoSubmissionStr = isPhotoSubmission ? @"true" : @"false";
        
        NSString *params;
        if(submittingWorkOrderBid == YES){
            params   = [NSString stringWithFormat:SubmitWorKOrderBidParameters, workOrderId, ServiceType,Status, base64Photo];
        }else{
            params   = [NSString stringWithFormat:SubmitPhotoParameters,accountNumber, workOrderId, msg, base64Photo,isTestStr,isPhotoSubmissionStr,hrempid,isWCFUStr];
        }
        
        NSLog(@" Url: %@",url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:url]];
        
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200){
            NSLog(@"Error POSTing to %@, HTTP status code %i", url, [responseCode statusCode]);
            [[[[iToast makeText:NSLocalizedString(@"Error submitting", @"")]
               setGravity:iToastGravityBottom] setDuration:3000] show];
            return NO;
        }else{
            NSLog(@"Succesfully Posted Work Order Photo!");
            [[[[iToast makeText:NSLocalizedString(@"Success", @"")]
               setGravity:iToastGravityBottom] setDuration:3000] show];
            return YES;
        }
        
    }
    @catch(NSException *exc) {
          NSString *logmessage = [NSString stringWithFormat:@"Error %@: %@", "WorkOrderPhotosSubmitPhotoURL", [exc reason]];
         NSLog(logmessage);
    }
}



UIViewController *controller;


-(void) SendWCFUPhotoMessage:(NSString *) accountNumber: (NSString *) workOrderId{
    
    NSLog(@"SendWCFUPhotoMessage");
    submittingWorkOrderBid = false;
    accountNum = accountNumber;
    woId = workOrderId;
    [self takePhoto];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"DidFinishPickingMediaWithInfo");
    UIImage *choseImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage *imgCompressed = [self compressImage:choseImage];
    NSString *b64 = [self encodeToBase64String:imgCompressed];
    
    NSString *fullb64 = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",b64];
    
    
    NSString *msg = [NSString stringWithFormat:@"We found a few weeds during today's pest service, don't worry we got em! -%@", [self getEmpName]];

    if(submittingWorkOrderBid == YES){
        msg = nil;
    }
    
    [self SubmitMessage:nil:woId:msg:YES:fullb64:NO];
    
    [controller dismissViewControllerAnimated:YES completion:^{    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSLog(@"DidFinishPickingImage");
    [controller dismissViewControllerAnimated:YES completion:^{    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"ImagePickerDidCancel");
    [controller dismissViewControllerAnimated:YES completion:^{    }];
}


- (void)finishTakePhoto{
    NSLog(@"FinishTakePhoto");
    NSString *msg = @"We found a few weeds during today's pest service, don't worry we got em!";
    NSString *tempBase646Str = @"";
    [self SubmitMessage:accountNum:woId:msg:YES:tempBase646Str:YES];
}


- (void)takePhoto
{
    
    UIViewController *yourCurrentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while(yourCurrentViewController.presentedViewController){
        yourCurrentViewController = yourCurrentViewController.presentedViewController;
    }
    
    controller = yourCurrentViewController;

    [controller presentViewController:self animated:YES completion:^{
        [self presentViewController:self.picker animated:YES completion:^{}];
    }];
}


-(NSString*) getEmpName{
    NSString *result = @"";
    @try{
        BulwarkTWAppDelegate *del = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
        result = del.name;
    }@catch(NSException *exc){}
    return result;
}

-(NSString*) getHrEmpId{
    NSString *result = @"";
    @try{
        BulwarkTWAppDelegate *del = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
        result = del.hrEmpId;
    }@catch(NSException *exc){}
    return result;
}

-(NSString*) encodeToBase64String:(UIImage* )image{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(UIImage *)compressImage:(UIImage *)image{

    NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);

    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression

    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }

    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();

    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);

    return [UIImage imageWithData:imageData];
}

-(void)SendTestMessage{
    
    WorkOrderPhotos *WOP_Service = [[WorkOrderPhotos alloc] init];
    NSString *b646img = @"data:image/jpeg;base64,%@";
  bool result=  [WOP_Service SubmitMessage:@"1500" :@"11089355" :@"TEST" :true :b646img :true: true];
    bool result2 = result;
}

@end
