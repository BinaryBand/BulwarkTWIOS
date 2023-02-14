//
//  WorkOrderPhotos.h
//  BulwarkTW
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

@interface WorkOrderPhotos : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
}

@property (nonatomic, retain) UIImagePickerController *picker;
-(void) SendTestMessage;


-(bool) SubmitWorkOrderBid :(NSString *)workOrderId :(NSString *)serviceType :(NSString *) status;

-(void) SendWCFUPhotoMessage :(NSString *)accountNumber :(NSString *)workOrderId;


-(bool) SubmitMessage :(NSString *)accountNumber :(NSString *)workOrderId :(NSString *)msg :(bool)isPhotoSubmission :(NSString * )base64Photo :(bool)isWCFU;
-(bool) SubmitMessage :(NSString *)accountNumber :(NSString *)workOrderId :(NSString *)msg :(bool)isPhotoSubmission :(NSString * )base64Photo :(bool)isWCFU :(bool)isTest;

@end

