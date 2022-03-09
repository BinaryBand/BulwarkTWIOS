//
//  BulwarkTWAppDelegate.m
//  BulwarkTW
//
//  Created by Terry Whipple on 12/20/10.
//  Copyright 2010 bulwark. All rights reserved.
//

#import "BulwarkTWAppDelegate.h"
#import "ViewOne.h"
#import "viewReports.h"
#import "viewRouteMaps.h"
#import "PayrollDetailReportsService.h"
#import "viewSchedule.h"


//#import “MessageUI.h” 
//#import “MFMailComposeViewController.h”

@implementation BulwarkTWAppDelegate{
    
    Boolean isstopped;
    NSString *CustPhn;
    Boolean SendingtoServer;
    BulwarkTWAppDelegate* _workspace;
}

@synthesize window;
@synthesize viewController;
//@synthesize Mcontroller;
@synthesize viewOne;
@synthesize viewRpt;
@synthesize viewMap;
@synthesize viewSched;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Example 1, loading the content from a URLNSURL
    isstopped = NO;
    self.driving = NO;
    _lat = @"0";
    _lon = @"0";
    _mapDate = @"";
    _mapinit = @"";

    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:myTypes];
        
    }
    
    
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
   if (localNotification) {
        application.applicationIconBadgeNumber = 0;
       
       
       [self CallNowPressed:localNotification.alertTitle];
       
       
       
    }
	
	
	NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    
    
    
    
    alertGPS.delegate = self;
    alertCall.delegate = self;
    
    if(self.locationManager==nil){
        self.locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        self.locationManager.delegate=self;
        //_locationManager.purpose = @"Gps is used to find customer locations";
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1;
        
        
        NSOperatingSystemVersion ios9_0_0 = (NSOperatingSystemVersion){9, 0, 0};
        if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9_0_0]) {
           self.locationManager.allowsBackgroundLocationUpdates = YES;
        } else {
            // iOS 8.0.0 and below logic
        }
       
        
        
        // iOS 8 - request location services via requestWhenInUseAuthorization.
        
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            // iOS 7 - We can't use requestWhenInUseAuthorization -- we'll get an unknown selector crash!
            // Instead, you just start updating location, and the OS will take care of prompting the user
            // for permissions.
            [self.locationManager startUpdatingLocation];
        }
        
        
    }

    

    [self checkGpsAndBackground];
    
    
    

        vDriving = [[viewDriving alloc] initWithNibName:@"viewDriving" bundle:nil];
    

            viewPayrollDetailReports = [[PayrollDetailReportsService alloc] init];
	return YES;
	
	
}


-(void) checkGpsAndBackground{
    
    

    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        
        alertGPS = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > TechnicianApp> Background App Refresh"
                                         delegate:self
                                cancelButtonTitle:@"Continue"
                                otherButtonTitles:nil, nil];
        [alertGPS show];
        
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        
        alertGPS = [[UIAlertView alloc]initWithTitle:@""
                                             message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > TechnicianApp> Background App Refresh"
                                            delegate:self
                                   cancelButtonTitle:@"Continue"
                                   otherButtonTitles:nil, nil];
        [alertGPS show];
        
    } else {
        
        
    }

    
    


    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services, TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            [alertGPS show];
        }
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services, TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            [alertGPS show];
        }
        
    }else{
        
        alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings the Privacy and enable Location Services" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alertGPS show];
        
        
    }

    
  
    
    
}


- (void)backgroundHandler {
    
   // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
   // {
        
        NSLog(@"backgroundfired");
        
        // if (self.blunoDev.bReadyToWrite){
        
        // }else{
        [self.locationManager startUpdatingLocation];
        //  }
   // }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // We only need to start updating location for iOS 8 -- iOS 7 users should have already
    // started getting location updates
    if (status == kCLAuthorizationStatusAuthorizedAlways){
        
        //  if (self.blunoDev.bReadyToWrite){
        
        //   }else{
        [manager startUpdatingLocation];
        //   }
        
        
    } else {
        
        if ( status == kCLAuthorizationStatusAuthorizedWhenInUse){
            alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services, TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            [alertGPS show];
            
        }else{
        
        
        if(status == kCLAuthorizationStatusNotDetermined){
            [manager requestAlwaysAuthorization];
        }else{
            
            alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            [alertGPS show];
            
            
        }
        
        }
        
        
    }
    
    
}
/*
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
 {
 // Delegate of the location manager, when you have an error
 NSLog(@"didFailWithError: %@", error);
 
 UIAlertView *errorAlert = [[UIAlertView alloc]     initWithTitle:NSLocalizedString(@"application_name", nil) message:NSLocalizedString(@"location_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
 
 [errorAlert show];
 
 }
 */





-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0)
    {
        //Location timestamp is within the last 15.0 seconds, let's use it!
        
        
       
        
        if(newLocation.horizontalAccuracy<500.0){
            //Location seems pretty accurate, let's use it!
            
            
            if (newLocation.speed > 4.5){
                
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
                {
                   
                    [self openSelfFromBackOrTerm];
                    
                 //   Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
                  //  NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
                  //  BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkapp.BulwarkTW"];
                    
                   
                    /*
                    _workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
                    
                    NSTimer *timer = [NSTimer timerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
                        [self openAppWithBundleIdentifier:@"com.bulwarkapp.BulwarkTW"];
                    }];
                    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                    
                    */
                    
                    //Do checking here.
                     //NSLog(@"app inactive");
                    //NSString* addr = @"bulwarktw://?32?";
                    
                    //NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                   // [[UIApplication sharedApplication] openURL:url];
                    
                        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
                    
                    
                }
            }
            
            
            if (newLocation.speed > 3.6 && self.driving == NO){
                

                
                
                [self ShowDrivingFrm];
                self.driving = YES;
                
            }
            if(newLocation.speed < 3.6 && self.driving == YES){
                [self HideDrivingFrm];
                self.driving = NO;
                
                
                
            }
            
            if(self.driving){
                
                double mph = newLocation.speed * 2.23694;
                
                NSString *currsp = [NSString stringWithFormat:@"%.1f",mph];
                
              currsp = [currsp stringByAppendingString:@" MPH"];
                
                [vDriving UpdateSpeed:currsp];
                
                
            }
            
            
            self.lon = [NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude];
            self.lat = [NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude];
            
            NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
            [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [df_utc setDateFormat:@"MM/dd/yyyy,HH:mm:ss"];
            
            
            double maxdist = 5;
            
            if(newLocation.speed >30){
                maxdist=240;
            } else if (newLocation.speed >26){
                maxdist=160;
            } else if (newLocation.speed >22){
                maxdist=100;
                
            } else if (newLocation.speed >17){
                maxdist=60;
                
            } else if (newLocation.speed >13){
                maxdist=30;
                
            } else if (newLocation.speed >9){
                maxdist=20;
                
            }
            
            
            
            
            //double distance = [oldLocation distanceFromLocation: newLocation];
            
            
            
            
            // if(distance < 40){
            
            
            // _location = newLocation;
            
            double lastlat = [[self Getlat] doubleValue];
            double lastlon = [[self GetLon] doubleValue];
            
            
            double lastdist = [self distanceBetweenLat1:lastlat lon1:lastlon lat2:newLocation.coordinate.latitude lon2:newLocation.coordinate.longitude];
            
            
            Boolean speedZero = NO;
            if(newLocation.speed == 0 && isstopped == NO){
                isstopped = YES;
                speedZero = YES;
                NSLog(@"Stopped");
                
            }
            if(newLocation.speed == 0){
                
                NSString *ssst = @"";
                
            }
            
            if (lastdist > maxdist || speedZero){
                
                
                if (newLocation.speed > 5){
                    isstopped = NO;
                    
                }
                
                [self SaveLat:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
                [self SaveLon:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
                
                
                
                NSString *gpsStr = @"&t=0&data=";
                
                
                gpsStr = [gpsStr stringByAppendingString:[df_utc stringFromDate:eventDate]];
                gpsStr = [gpsStr stringByAppendingString:@","];
                gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
                gpsStr = [gpsStr stringByAppendingString:@","];
                gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
                gpsStr = [gpsStr stringByAppendingString:@","];
                gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",newLocation.course]];
                gpsStr = [gpsStr stringByAppendingString:@","];
                gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",newLocation.speed]];
                gpsStr = [gpsStr stringByAppendingString:@","];
                gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",lastdist]];
                
                
                NSString *custGps = @"&lat=";
                
                custGps = [custGps stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
                custGps = [custGps stringByAppendingString:@"&lng="];
                custGps = [custGps stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
                
                //[self toastScreenAsync:@"GPS" withMessage:custGps];
                if(newLocation.course >0){
                    
                    NSLog(@"gps received");
                    [self SaveGPSFile:gpsStr];
                }
                [self saveLastlatLng:custGps];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                
                NSString *appFile1 = [documentsDirectory stringByAppendingPathComponent:@"ArriveTime"];
                
                [[self CurrentTime] writeToFile:appFile1 atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                //gpsStr = [gpsStr stringByAppendingString:@"\n"];
                //[self.locationManager stopUpdatingLocation];
                
                
            }
            //textView.text = [textView.text stringByAppendingString:gpsStr];
            
            //}
            
            //Optional: turn off location services once we've gotten a good location
            // [manager stopUpdatingLocation];
        }
        
        
        
        
    }
    
    
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{

    if (alertView == alertGPS) {
       
      //NSString *appurl = [(NSString) ];
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TechnicianApp"]];

        NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
     //   if ([[UIApplication sharedApplication] canOpenURL:settings])
            [[UIApplication sharedApplication] openURL:settings];
        
    }
    
    
    if(alertView == alertCall){
        
        if(buttonIndex==1){
            
            [self CallNowPressed:CustPhn];
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    //[alertView dismissWithClickedButtonIndex:0 animated:YES];
}


-(double) distanceBetweenLat1:(double)lat1 lon1:(double)lon1
                         lat2:(double)lat2 lon2:(double)lon2 {
    //degrees to radians
    double lat1rad = lat1 * M_PI/180;
    double lon1rad = lon1 * M_PI/180;
    double lat2rad = lat2 * M_PI/180;
    double lon2rad = lon2 * M_PI/180;
    
    //deltas
    double dLat = lat2rad - lat1rad;
    double dLon = lon2rad - lon1rad;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad);
    double c = 2 * asin(sqrt(a));
    double R = 6372.8;
    return R * c*1000;
    
}

-(void)saveLastlatLng:(NSString *)str{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    //NSString *appFile = [[NSBundle mainBundle]
    //				  pathForResource:@"chemicalsused"
    //				  ofType:@"html"];
    // the path to write file
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"LatLng"];
    
    [str writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    
    
    
}



-(void)SaveLat:(NSString *)lat {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"lat.tw"];
    
    [lat writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
}
-(void)SaveLon:(NSString *)lon {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"lon.tw"];
    
    [lon writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
}

-(NSString*)GetLon{
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"lon.tw"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        return @"0";
    }
    else {
        
        return [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
    }
    
    
    
    
}
-(NSString*)Getlat{
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"lat.tw"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        return @"0";
    }
    else {
        
        return [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
    }
    
    
    
    
}

-(void)SaveGPSFile:(NSString *)url {
    
    
    
    @try {
        
        
        NSString *name = [self CurrentTimeLabel];
        
        
        
        
        
        
        
        
        
        
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
        //documentsDirectory = [documentsDirectory stringByAppendingString:@"/send/"];
        //NSString *appFile = [[NSBundle mainBundle]
        //				  pathForResource:@"chemicalsused"
        //				  ofType:@"html"];
        // the path to write file
        
        NSString *Fname = @"";
        
        //NSString *inStr = [NSString stringWithFormat:@"%d", CurrentFile];
        
        Fname = [Fname stringByAppendingString:name];
        Fname = [Fname stringByAppendingString:@".gps"];
        
        
        
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:Fname];
        
        NSError *error1 = [[NSError alloc] init];
        
        [url writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:&error1];
        
        //CurrentFile = CurrentFile + 1;
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    [viewOne sendFilesToServerAsync];
    
}


-(NSDate*)ConvertToDate:(NSString *)stringDate{
    
    
    NSString *dateString = stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM/dd/yyy HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
    
    
    
    
}
-(NSString*)CurrentDate{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}

-(NSString*)CurrentTime{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}

-(NSString*)CurrentTimeLabel{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-HH-mm-ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}
-(NSString*)CurrentTimeUrl{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyy%20HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}

-(NSString*)CurrentTimeTimeOnly{
    
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm tt"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    
    return dateString;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"DidRegisterUserNotificationSettings");
    //register to receive notifications
    [[UIApplication sharedApplication]  registerForRemoteNotifications];
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
  // NSString *tkn = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    NSString *tkn = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   // tkn = [tkn stringByReplacingOccurrencesOfString:@"<" withString:@""];
   // tkn = [tkn stringByReplacingOccurrencesOfString:@">" withString:@""];
    //tkn = [tkn stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUUID *deviceIdUUID;

    deviceIdUUID = [UIDevice currentDevice].identifierForVendor;

    NSString *deviceId = [deviceIdUUID UUIDString];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [viewPayrollDetailReports updatePushToken:deviceToken :deviceId];
    
  //  UIDevice *deviceInfo = [UIDevice currentDevice];
    
  //  NSLog(@"Device name:  %@", deviceInfo.name);
    
    //NSString *sampleUrl = @"http://www.google.com/search.jsp?params=Java Developer";
 //   NSString *di = [deviceInfo.name stringByAddingPercentEscapesUsingEncoding:
  //                          NSUTF8StringEncoding];
    
  //  NSString *Surl = @"http://98.190.138.211:5226/HH/devices.php?did=";
  // Surl = [Surl stringByAppendingString:deviceId];
 //  Surl = [Surl stringByAppendingString:@"&tkn="];
 //   Surl = [Surl stringByAppendingString:tkn];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"1" message:tkn delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    
   // NSURL *url = [ NSURL URLWithString: Surl];
    
   // NSURLRequest *req = [ NSURLRequest requestWithURL:url
    //                                      cachePolicy:NSURLRequestReloadIgnoringCacheData
    //                                  timeoutInterval:10.0 ];
   // NSError *err;
   // NSURLResponse *res;
   // NSData *d = [ NSURLConnection sendSynchronousRequest:req
    //                                   returningResponse:&res
    //                                               error:&err ];
    
    

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
   // if (state == UIApplicationStateActive) {
        alertCall = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Call Now",nil];
        CustPhn = notification.alertTitle;
        
        [alertCall show];
 //   }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}


-(void) CallNowPressed:(NSString *)PhoneNumber{
    
    NSString *phn = PhoneNumber;
    
    NSString *UrlStr = @"https://ipadapp.bulwarkapp.com/phones/clicktocall.aspx?mp=";
    
    NSString *techPhone =  [[_phone componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                            componentsJoinedByString:@""];
    
    UrlStr = [UrlStr stringByAppendingString:techPhone];
    UrlStr = [UrlStr stringByAppendingString:@"&d="];
    UrlStr = [UrlStr stringByAppendingString:phn];
    UrlStr = [UrlStr stringByAppendingString:@"&o="];
    UrlStr = [UrlStr stringByAppendingString:_office];
    
    NSURL *qurl = [NSURL URLWithString:UrlStr];
    
  
    NSString *myStr = [NSString stringWithContentsOfURL:qurl encoding:NSUTF8StringEncoding error:nil];
    

    
    NSLog(@"%@", myStr);
    
    
    
    
}





-(void)ShowDrivingFrm{
    
       CGRect nframe = CGRectMake(0, 20, 768, 956);
      vDriving = [[viewDriving alloc] initWithNibName:@"viewDriving" bundle:nil];
    //vDriving = [[viewDriving alloc] initWithFrame:nframe];
    vDriving.view.frame = nframe;
     //[self addChildViewController:vDriving];                 // 1
    // 2
         [window addSubview:[vDriving view]];

        
        [UIView transitionWithView:vDriving.view duration:0.7
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self->window addSubview:[self->vDriving view]]; }
                        completion:nil];

    
    
}
-(void)HideDrivingFrm{
    
    
    [UIView animateWithDuration:0.7
                     animations:^{self->vDriving.view.alpha = 0.0;}
                     completion:^(BOOL finished){ [self->vDriving.view removeFromSuperview]; }];
    
    //[vDriving.view removeFromSuperview];
    
    
    
    
}

-(void)refreshSchedule{
    
    [viewSched getSchedule];
    
    
    
    
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
	if (!url) { return NO;}
	
    NSString *strUrl = [url absoluteString];
    
    if([strUrl hasPrefix:@"bulwarktwreports"]){
        [viewRpt handleOpenURL:url];
        
    }else if([strUrl hasPrefix:@"bulwarktwmap"]){
        
        
        [viewSched handleOpenURL:url];
        
       /* if(self.mapinit.length == 0){
            
            NSString *URLString = [url absoluteString];
            
            NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
            
            NSString *urlParamater = [paramater objectAtIndex: 2];

            
            self.mapDate = urlParamater;
            
            NSURL *url1 = [NSURL URLWithString:@"bulwarktw://?44?test"];
            [viewOne handleOpenURL:url1];
            
            
        }else{
            [viewSched handleOpenURL:url];
            
        }
        */
        
        
        
        
    }else{
       [viewOne handleOpenURL:url];
        
    }
    
	
    
    
    
	return YES;
/*MF
 MailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"In app email..."];
	[controller setMessageBody:@"...a tutorial from mobileorchard.com" isHTML:NO];
	[self presentModalViewController:controller animated:YES];
	[controller release];	
	return YES;
	*/
		
	
	NSString *URLString = [url absoluteString];
	
	NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
	
	NSString *urlParamater = [paramater objectAtIndex: 2];
	
	NSString *spage =[paramater objectAtIndex: 1];
	
	double dpage = [spage doubleValue];
	// Example 1, loading the content from a URLNSURL
	//NSURL *urlz = [NSURL URLWithString:urlParamater];
	
	//NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
	//[webView loadRequest:request];		
	
	
	if (dpage==1)
	{
		// Example 1, loading the content from a URLNSURL
		NSURL *urlz = [NSURL URLWithString:urlParamater];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
		[webView loadRequest:request];		
		
	}
	else if (dpage==2){
	
		NSString *path = [[NSBundle mainBundle]
						  pathForResource:@"results"
						  ofType:@"html"]; 
		NSURL *urlq = [NSURL fileURLWithPath:path];
		
		
		
		NSString *theAbsoluteURLString = [urlq absoluteString];   
		
		NSString *queryString = [@"?" stringByAppendingString: urlParamater]; 
		
		NSString *absoluteURLwithQueryString = [theAbsoluteURLString stringByAppendingString: queryString];  
		
		NSURL *finalURL = [NSURL URLWithString: absoluteURLwithQueryString];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:(NSTimeInterval)10.0 ];
		
		[webView loadRequest:request];		
		
	}
	else if (dpage==3)
	{
		NSArray *paramater1 = [URLString componentsSeparatedByString:@"!"];
		
		NSString *urlParamater1 = [paramater1 objectAtIndex: 1];		
		
		NSURL *urlz = [NSURL URLWithString:urlParamater1];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:urlz];
		[webView loadRequest:request];
		
	}
	
	

	//UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network error" message: @"Error sending your info to the server" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	
	//[someError show];
	//[someError release];	
	
	return YES;
	
}

-(void)closeViewOne{
	//[viewOne performClose:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    NSLog(@"resign active");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    NSLog(@"enter background");
    
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
   
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [self checkGpsAndBackground];
    
    NSLog(@"forground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    NSLog(@"active");

    
	[viewOne sendFilesToServerAsync];
    
    
    bool payrollDetailReportAvailable = [viewPayrollDetailReports techHasPendingCommisionReport];
    if(payrollDetailReportAvailable){
        NSLog(@"Tech Has CommissionReport Available");
        [viewPayrollDetailReports openReport:window];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSLog(@"terminate");
    
    //NSString* addr = @"bulwarktw://?32?";
  
   // NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //[[UIApplication sharedApplication] openURL:url];
    
    [NSThread sleepForTimeInterval:2];
    
 NSLog(@"oApp Terminated Restart only on company ipads");
   // [self openSelfFromBackOrTerm];
    Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
          NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
          BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkappTW.TechApp"];

    
}

- (void)openSelfFromBackOrTerm {
 NSLog(@"openapp again");
         
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
              NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
              BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkappTW.TechApp"];
        NSLog(@"IsOpened");
    });
    
    //Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
     //     NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
     //     BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkappTW.TechApp"];

    

     // NSString* addr = @"bulwarktw://?32?";
    
     // NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     // [[UIApplication sharedApplication] openURL:url];
    
    
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   [[NSURLCache sharedURLCache] removeAllCachedResponses];   
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




@end
