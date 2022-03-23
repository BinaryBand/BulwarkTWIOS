//
//  ViewOne.h
//  BulwarkTW
//
//  Created by Terry Whipple on 12/28/10.
//  Copyright 2010 bulwark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Webkit/Webkit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Foundation/Foundation.h>
#import <Availability.h>

//#import "RscMgr.h"

#import <CoreTelephony/CoreTelephonyDefines.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DFBlunoManager.h"
#import "TWBlunoManager.h"
#import "BulwarkTWAppDelegate.h"
#import "viewMissedClockOut.h"
#import "viewDriving.h"
#import "viewMissedClockIn.h"

#define BUFFER_LEN 4096

@class MBProgressHUD;
@class viewSchedule;

//@class ReportProblemEmailViewController;

@interface ViewOne : UIViewController<UIPrintInteractionControllerDelegate,UIGestureRecognizerDelegate,WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITabBarDelegate, DFBlunoDelegate, TWBlunoDelegate, viewMissedClockOutDelegate, viewMissedClockInDelegate > {

    
    WKWebViewConfiguration *configuration;
    WKUserContentController *controllerweb;
    
    viewMissedClockOut *viewClockOut;
    viewMissedClockIn *viewClockIn;

    
    
	 IBOutlet UIToolbar *toolbar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSInputStream *iStream;
	NSOutputStream *oStream;
	NSTimer *timer;
	IBOutlet WKWebView *webView;
    IBOutlet WKWebView *RouteWebView;
	IBOutlet WKWebView *PopUpWebView;
    //IBOutlet WKWebView *printView;
 
	NSString *rdate;
	//NSString *hrEmpId;
	//NSString *empName;
	//NSString *password;
	//NSString *license;
	//NSString *office;
	//NSString *printerIp;
	NSURL *Rurl;
	NSString *appBuild;
	MPMoviePlayerViewController * controller;
	NSInteger *CurrentFile;
	
	UIAlertView *alertWithOkButton;
	UIAlertView *alertWithYesNoButtons;
    
    UIAlertView *alertTruck;
    
    UIAlertView *CallInAdvanced;
    
    UIImagePickerController *Termitepicker;
    
    
	UIActionSheet *settingsAction;
	UIActionSheet *MenuAction;
	UIActionSheet *reportsAction;
    UIActionSheet *ImageAction;
    UIActionSheet *TermiteAction;
    
    IBOutlet UILabel *clockoutlabel;
    IBOutlet UIDatePicker *ClockOutDate;
    IBOutlet UILabel *ClockBack;
    IBOutlet UIButton *ClockButton;
    IBOutlet UIButton *ClockButtonCancel;
    
    
    IBOutlet UIButton *btnFastComm;
    IBOutlet UILabel *lblFastComValue;
    IBOutlet UILabel *lblFastCommMTD;
    IBOutlet UILabel *lblFastCommMessage;
    IBOutlet UILabel *lblfastcommlbl;
    IBOutlet UIImageView *moneyimg;
    IBOutlet UILabel *lblFastCommPP;
    
    UIAlertView *fastCommAlert;
    
    
    IBOutlet UIBarButtonItem *gpsIcon;
    IBOutlet UIBarButtonItem *printIcon;
    
    
    IBOutlet UITabBar *myTabBar;
    IBOutlet UITabBarItem *Videos;
    //UIToolbar *toolBar;
	
    UIRefreshControl *refreshControl;
    
    
    
    
	MBProgressHUD *HUD;
    

    
   
    
	
}
//- (ReportProblemEmailViewController *)rpemail;

- (void)handleOpenURL:(NSURL *)url;
-(void)sendResults:(NSURL *)url;
-(void)SaveServiceFile:(NSString *)url;
-(void) sendFilesToServerAsync;
-(void)emailResults:(NSURL *)url;

-(void)SaveGPSFile:(NSString *)url;
- (void)backgroundHandler;
- (void) BtConnectPrinter : (NSString *)s;
- (void) takeTermitePhoto;


//@property(nonatomic,strong) UIWebView *webView;

//@property(nonatomic,strong) UIWebView *printView;
//@property(nonatomic,retain) UITextView *textView;


@property(nonatomic,strong) NSString *rdate;
@property(nonatomic, strong) NSString *hrEmpId;
@property(nonatomic,strong) NSString *empName;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) NSString *license;
@property(nonatomic,strong) NSString *office;
@property(nonatomic,strong) NSString *printerIp;
@property(nonatomic,strong) NSString *appBuild;
@property(nonatomic,strong) NSURL *Rurl;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

@property (readwrite, assign) NSInteger *CurrentFile;
@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;

@property(strong, nonatomic) TWBlunoManager* printManager;
@property(strong, nonatomic) DFBlunoDevice * printDev;
@property(strong, nonatomic) NSMutableArray* printDevices;
@property (nonatomic,strong)IBOutlet viewSchedule *viewSchedule;



- (IBAction)btnRefreshPressed;
- (IBAction)btnRequestPressed;
- (IBAction)btnRoutesPressed;
- (IBAction)btnSettingsPressed;
- (IBAction)btnTestSerial;
-(IBAction)btnClockIn;
-(IBAction)btnClockOut;
-(IBAction)btnSearch;
-(IBAction)btnMap;
-(IBAction)btnAvaliableRoutes;
-(IBAction)btnMyPay;
-(IBAction)btnVideo;
-(IBAction)btnFixClockOut;
-(IBAction)btncancelClockOut;
-(IBAction)btnScreenShot;
    -(IBAction)btnFastComm;
-(IBAction)btnMyStats;
-(IBAction)btnTest;
-(IBAction)gestOpenMap;


@end
