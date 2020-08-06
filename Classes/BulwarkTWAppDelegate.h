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
#import "VideoTableView.h"

@class ViewOne;
@class viewReports;
@class viewRouteMaps;

@interface BulwarkTWAppDelegate :  UIViewController <MFMailComposeViewControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate> {
    UIWindow *window;
	IBOutlet UIWebView *webView;
	BulwarkTWAppDelegate *viewController;
	ViewOne *viewOne;
    viewReports *viewRpt;
    viewRouteMaps *viewMap;
    
    viewDriving *vDriving;
    UIAlertView *alertGPS;
    UIAlertView *alertCall;
	NSTimer *timer;
	//MFMailComposeViewController *Mcontroller;
	
	//MFMailComposeViewControllerDelegate *mailController;
    AVAudioPlayer *audioPlayer;
    UIBackgroundTaskIdentifier counterTask;
    
}



-(void)openSelfFromBackOrTerm;


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet BulwarkTWAppDelegate *viewController;
@property (nonatomic,strong)IBOutlet ViewOne *viewOne;
@property (nonatomic,strong)IBOutlet viewReports *viewRpt;
@property (nonatomic,strong)IBOutlet viewRouteMaps *viewMap;

@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;
@property (nonatomic,strong) NSString *hrEmpId;
@property (nonatomic,strong) NSString *office;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *license;
@property (nonatomic,strong) NSString *mapDate;
@property (nonatomic,strong) NSString *mapinit;
@property (nonatomic) Boolean driving;
@property (nonatomic,strong) NSMutableArray *placesArray;
@property (nonatomic,strong) VideoTableView *videoTableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

//@property (nonatomic, retain) IBOutlet MFMailComposeViewController *Mcontroller;
-(void)ShowDrivingFrm;


@end

