//
//  BulwarkTWAppDelegate.h
//  BulwarkTW
//
//  Created by Terry Whipple on 12/20/10.
//  Copyright 2010 bulwark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "viewDriving.h"
#import <CoreLocation/CoreLocation.h> 
#import "PayrollDetailReportsService.h"
#import "LTSupportAutomotive.h"
//#import "ViewOne.h"
//#import "BulwarkTW-Swift.h"


@import Firebase;
@import FirebaseMessaging;
@import FirebaseAnalytics;
@import FirebaseCrashlytics;

@class viewDashboard;


@class ViewOne;
@class viewReports;
@class viewRouteMaps;
@class viewRoutes;
@class viewSettings;
@class viewRouteStop;

@class Utilities;

typedef enum : NSUInteger {
    PageCurrentData,
    PageComponentMonitors,
    PageDTC,
} Page;

@interface BulwarkTWAppDelegate :  UIViewController <MFMailComposeViewControllerDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate, FIRMessagingDelegate> {
    UIWindow *window;
	
	BulwarkTWAppDelegate *viewController;
	ViewOne *viewOne;
    viewReports *viewRpt;
    viewRouteMaps *viewMap;
    viewRoutes *viewSched;
    viewSettings *viewsett;
    viewDriving *vDriving;
    //UIAlertView *alertGPS;
   // UIAlertView *alertCall;
	NSTimer *timer;
	//MFMailComposeViewController *Mcontroller;
	
	//MFMailComposeViewControllerDelegate *mailController;
    AVAudioPlayer *audioPlayer;
    UIBackgroundTaskIdentifier counterTask;
    
    PayrollDetailReportsService *viewPayrollDetailReports;
    
    
    LTBTLESerialTransporter* _transporter;
    LTOBD2Adapter* _obd2Adapter;

    NSArray<CBUUID*>* _serviceUUIDs;
    NSArray<LTOBD2PID*>* _pids;
    NSArray<LTOBD2MonitorResult*>* _monitors;
    NSArray<LTOBD2DTC*>* _dtcs;
    
    NSTimer* _timer;
    
    Page _selectedPage;
    
    LTOBD2PID_MONITOR_STATUS_SINCE_DTC_CLEARED_01* _statusPID;
    
    
}



-(void)openSelfFromBackOrTerm;


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet BulwarkTWAppDelegate *viewController;
@property (nonatomic,strong)IBOutlet ViewOne *viewOne;
@property (nonatomic,strong)IBOutlet viewReports *viewRpt;
@property (nonatomic,strong)IBOutlet viewRouteMaps *viewMap;
@property (nonatomic,strong)IBOutlet viewRoutes *viewSched;

@property (nonatomic,strong)IBOutlet viewSettings *viewsett;


@property (nonatomic, strong) viewDashboard *viewDash;
@property (nonatomic,strong) viewRouteStop *viewRStop;




@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;
@property (nonatomic,strong) NSString *hrEmpId;
@property (nonatomic,strong) NSString *office;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *license;
@property (nonatomic,strong) NSString *mapDate;
@property (nonatomic,strong) NSString *mapinit;
@property (nonatomic,strong) NSString *reportUrl;
@property (nonatomic,strong) NSString *Vin;
@property (nonatomic,strong) NSString *Odo;
@property (nonatomic,strong) NSDate *lastObdRead;
@property (nonatomic,strong) NSString *appBuild;
@property (nonatomic,strong) NSString *obdTroubleCodes;

@property (nonatomic) double lastSavedLat;
@property (nonatomic) double lastSavedLon;

@property (nonatomic) Boolean driving;
@property (nonatomic,strong) NSMutableArray *placesArray;
//@property (nonatomic,strong) VideoTableView *videoTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

//@property (nonatomic, retain) IBOutlet MFMailComposeViewController *Mcontroller;
-(void)ShowDrivingFrm;
-(void)refreshSchedule;
-(void)ConnectOBD;

-(void) sendFilesToServerAsync;
-(void) sendFilesToServe;

-(void)sendGpsFilesToServer;

@end

