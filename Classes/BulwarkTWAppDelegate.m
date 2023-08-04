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
#import "viewSettings.h"
//#import "PayrollDetailReportsService.h"
#import "BulwarkTW-Swift.h"
#import <notify.h>



@implementation BulwarkTWAppDelegate{
    
    Boolean isstopped;
    NSString *CustPhn;
    Boolean SendingtoServer;
    BulwarkTWAppDelegate* _workspace;
    long gpsRequested;
    //NSString *Vin;
    //NSString *Odo;
    NSString *DtcDist;
    //NSDate *lastObdRead;
    Boolean isConnectedToObd;
    long obdsecs;
    int cntping;
    BOOL updatesettingsvin;
    Boolean SendingFilesToServer;

    Boolean islocked;
    NSDate *lastReadTime;
    
    //viewDashboard *viewDash;
}
//viewDashboard *viewDash;
@synthesize window;
@synthesize viewController;
//@synthesize Mcontroller;
@synthesize viewOne;
@synthesize viewRpt;
@synthesize viewMap;
@synthesize viewSched;
@synthesize viewsett;
//@synthesize viewDash;



NSString *kGCMMessageIDKey = @"";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    islocked = false;
    updatesettingsvin = false;
    isConnectedToObd = NO;
    cntping = 0;
    // Example 1, loading the content from a URLNSURL
    isstopped = NO;
    self.driving = NO;
    _lat = [self Getlat];
    _lon = [self GetLon];
    _mapDate = @"";
    _mapinit = @"";

    _Vin = @"";
    _Odo = @"";
    DtcDist = @"";
    SendingFilesToServer = false;
    _obdTroubleCodes = @"";
    
 
    _lastSavedLat = [_lat doubleValue];
    _lastSavedLon = [_lon doubleValue];
    
    
    _appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1970];
    _lastObdRead = [[NSCalendar currentCalendar] dateFromComponents:comps];
    obdsecs = 0;
 
    lastReadTime =[[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    int cacheSizeMemory = 16*1024*1024; // 4MB
    int cacheSizeDisk = 64*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    [self registerAppforDetectLockState];
    
    @try{
        [FIRApp configure];
        [FIRMessaging messaging].delegate = self;
        
        //if ([UNUserNotificationCenter class] != nil) {
            // iOS 10 or later
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self; UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
                  
                }];
        
        
        
         // } else {
            // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
          //  UIUserNotificationType allNotificationTypes =
          //  (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
          //  UIUserNotificationSettings *settings =
          //  [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
          //  [application registerUserNotificationSettings:settings];
          //}
        
        
        [application registerForRemoteNotifications];
        [self configureFireBase];
    }@catch(NSException *exc){
        NSString *logmessage = [NSString stringWithFormat:@"Error %s: %@", "Configuring Firebase ", [exc reason]];
        NSLog(@"%@", logmessage);
    }
 
    
    [self getSettings];

 
        
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
   if (localNotification) {
        application.applicationIconBadgeNumber = 0;
       
       
       [self CallNowPressed:localNotification.alertTitle];
       
       
       
    }
	
	
	NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    
    
    
    
   // alertGPS.delegate = self;
    //alertCall.delegate = self;
    
    if(self.locationManager==nil){
        self.locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        self.locationManager.delegate=self;
        //_locationManager.purpose = @"Gps is used to find customer locations";
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        //self.locationManager.distanceFilter = 3;
        
 
        
        self.locationManager.allowsBackgroundLocationUpdates = YES;
     
        
        
        [self.locationManager setPausesLocationUpdatesAutomatically:YES];
        
        NSMutableArray<CBUUID*>* ma = [NSMutableArray array];
            [@[ @"FFF0", @"FFE0", @"BEEF" , @"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"] enumerateObjectsUsingBlock:^(NSString* _Nonnull uuid, NSUInteger idx, BOOL * _Nonnull stop) {
                [ma addObject:[CBUUID UUIDWithString:uuid]];
            }];
            _serviceUUIDs = [NSArray arrayWithArray:ma];
        
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdapterChangedState:) name:LTOBD2AdapterDidUpdateState object:nil];
        
       // [self connect];
        
  

        
    }
    
    
    
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    
    gpsRequested = 0;
    
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:@"gpsR"]){

         gpsRequested = [prefs integerForKey:@"gpsR"];
    }
    
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:@"lastObd"]){

         obdsecs = [prefs integerForKey:@"lastObd"];
        
        
        _lastObdRead = [NSDate dateWithTimeIntervalSince1970:obdsecs];
    }
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:@"odometer"]){

         _Odo = [prefs stringForKey:@"odometer"];
       
    }
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:@"vin"]){

         _Vin = [prefs stringForKey:@"vin"];
       
    }
    
    
//odometer
    
    
    
    
    
    [self checkGpsAndBackground];
    
    
    

        vDriving = [[viewDriving alloc] initWithNibName:@"viewDriving" bundle:nil];
    

            viewPayrollDetailReports = [[PayrollDetailReportsService alloc] init];
    
    
    [NSTimer scheduledTimerWithTimeInterval:600.0 target:self selector:@selector(CheckOBDCnt) userInfo:nil repeats:YES];
    
    //[self connect];
	return YES;
	
	
}

- (void)CheckOBDCnt {
    if(cntping == 10){
        if(isConnectedToObd == false){
            cntping = 0;
            
        }
    }
}
-(void)getSettings{
    
    
    
    self.hrEmpId = @"12345";
    self.name = @"";
    //delegate.password = @"";
    self.license = @"";
    self.office = @"";
    self.phone = @"";
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    
    NSString *myPathDocs2 =  [documentsDirectory2 stringByAppendingPathComponent:@"settings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
        
    }
    else {
        
        
        NSString *settingsFile = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
        
        NSArray *paramater2 = [settingsFile componentsSeparatedByString:@"$"];
        
        self.name = [paramater2 objectAtIndex: 0];
        
        self.hrEmpId = [paramater2 objectAtIndex: 1];
        
        //delegate.password = [paramater2 objectAtIndex: 2];
        @try {
            self.license = [paramater2 objectAtIndex: 3];
            
            self.office = [paramater2 objectAtIndex: 4];
            self.phone = [paramater2 objectAtIndex: 5];
        }
        @catch (NSException * e) {
            //NSString *except =    @"office";
            
            
        }
        
        
        
    }

    if([self.office length] == 0){
        self.office = @"ME";
    }
    if([self.name length] == 0){
        self.name = @"";
    }
    if([self.hrEmpId length] == 0){
        self.hrEmpId = @"12345";
    }
    if([self.license length] == 0){
        self.license = @"";
    }
    if([self.phone length] == 0){
        self.phone = @"";
    }
    
    NSDictionary *keysAndValues =
        @{@"office_key" : self.office,
          @"hrempid_key" : self.hrEmpId,
          @"name_key" : self.name,
          @"phone_key" : self.phone,
          @"license_key" : self.license,
          @"appbuild_key" : self.appBuild
        };

    
    [[FIRCrashlytics crashlytics] setCustomKeysAndValues:keysAndValues];
    
    
}


-(void) checkGpsAndBackground{
    
    

    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App Settings" message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > TechnicianApp> Background App Refresh" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //NSString *strTemp = UIApplicationOpenSettingsURLString;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
          
        }]];
    

        
        [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        

        
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App Settings" message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > TechnicianApp> Background App Refresh" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
           // NSString *strTemp = UIApplicationOpenSettingsURLString;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
          
        }]];
        
        
        
        [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        
    }

    
    //CLLocationManager *manager = [[CLLocationManager alloc] init];

    //if([CLLocationManager locationServicesEnabled]){
        
        //NSLog(@"Location Services Enabled");
        //NSLog(@"%d", CLLocationManager.authorizationStatus);
        //NSLog(@"%d", kCLAuthorizationStatusRestricted);
        //NSLog(kCLAuthorizationStatusNotDetermined);
        //NSLog(@"%d", kCLAuthorizationStatusAuthorizedAlways);
        //NSLog(@"%d", kCLAuthorizationStatusAuthorizedWhenInUse);
     
        
        
        
        
        if([self.locationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
            
        }else if([self.locationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
              
            }]];
            
            
            
            [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        } else if([self.locationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
              
            }]];
            
            
            
            [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        } else if([self.locationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
              
            }]];
            
            
            
            [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        }
            
        
        //if (@available(iOS 14.0, *)) {
            CLAccuracyAuthorization aa = self.locationManager.accuracyAuthorization;
            
            if(aa != CLAccuracyAuthorizationFullAccuracy){
                
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Enable Precise Locations" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                  
                }]];
                
                
                
                [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
                
            }
            
      //  } else {
            // Fallback on earlier versions
      //  }
        
          
        

        
   // }else{
        
      
   //         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
   //         [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
               // NSString *strTemp = UIApplicationOpenSettingsURLString;
   //             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
              
   //         }]];
            
            
            
  //          [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
        
        
        
   // }

    
  
    
    
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

- (void) locationManagerDidChangeAuthorization:(CLLocationManager *)manager{


    
    
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
    // We only need to start updating location for iOS 8 -- iOS 7 users should have already
    // started getting location updates
    
    
    CLAuthorizationStatus status = [manager authorizationStatus];
    
    
    if (status == kCLAuthorizationStatusAuthorizedAlways){
        
        //  if (self.blunoDev.bReadyToWrite){
        
        //   }else{
        [manager startUpdatingLocation];
        //   }
        
        
    } else {
        
        if ( status == kCLAuthorizationStatusAuthorizedWhenInUse){
            
            if(gpsRequested == 0){
               
                
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

                // saving an NSString
                [prefs setInteger:1 forKey:@"gpsR"];
                [prefs synchronize];
                gpsRequested = 1;
                
                [self.locationManager requestAlwaysAuthorization];
                
            }else{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                   // NSString *strTemp = UIApplicationOpenSettingsURLString;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                  
                }]];
                
                
                
                [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
                
            }
            
          //  alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services, TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
           // [alertGPS show];
            
        }else{
        
        
        if(status == kCLAuthorizationStatusNotDetermined){
            [manager requestWhenInUseAuthorization];
        }else{
            
           // alertGPS = [[UIAlertView alloc] initWithTitle:@"GPS Is Required" message:@"Please Go to Settings,Privacy,Location Services TechnicianApp, and Select Location Always" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
           // [alertGPS show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GPS Required" message:@"Please Go to Settings,Privacy,Location Services, Service Pro Tools, and Select Location Always" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
               // NSString *strTemp = UIApplicationOpenSettingsURLString;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
              
            }]];
            
            
            
            [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
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





//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = locations.lastObject;
    
    
    
    //CLLocation *oldLocation;
    //if (locations.count > 1) {
    //    oldLocation = locations[locations.count - 2];
    //}
    
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (howRecent > -15.0)
    {
        //Location timestamp is within the last 15.0 seconds, let's use it!
        
        
       
        
        if(newLocation.horizontalAccuracy<500.0){
            //Location seems pretty accurate, let's use it!
            
            
            if (newLocation.speed > 4.5){
                
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
                {
                   
                    [self openSelfFromBackOrTerm];
                    

                    
                    
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
            
            double mph = newLocation.speed * 2.23694;
            
            if(self.driving){
                
                
                
               
                
                long secsSinceLast = [[NSDate date] timeIntervalSinceDate:lastReadTime];
                
                if(secsSinceLast > 600){
                    isConnectedToObd = false;
                }
                
                
                //if(mph > 10.0){
                    
                    if(!isConnectedToObd)
                   {
                       if(secsSinceLast > 180){
                           [self connect];
                       }
                    }
                   
                    
                //}
                NSString *currsp = [NSString stringWithFormat:@"%.1f",mph];
                
              currsp = [currsp stringByAppendingString:@" MPH"];
                
                [vDriving UpdateSpeed:currsp];
                [vDriving UpdateVin:self->_Vin];
                [vDriving UpdateODO:self->_Odo];
                
                
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
                
                //Optionally for time zone conversions
                  [formatter setTimeZone:[NSTimeZone localTimeZone]];

                NSString *stringFromDate = [formatter stringFromDate:_lastObdRead];
         
                NSString *str = [@"Last Read: " stringByAppendingString:stringFromDate];
                [vDriving UpdateReadTime:str];
                
                
                
                
            }
            
            double lastlat = [_lat doubleValue];
            double lastlon = [_lon doubleValue];

           // double currlat = newLocation.coordinate.latitude;
            //double currlon = newLocation.coordinate.longitude;
            
            
            self.lon = [NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude];
            self.lat = [NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude];
            
            //NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
            //[df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            //[df_utc setDateFormat:@"MM/dd/yyyy,HH:mm:ss"];
            
            
            double maxdist = 3;
            
            if(mph >68){
                maxdist=200;
            }else if (mph >63){
                maxdist=160;
            }else if (mph >55){
                maxdist=130;
            }else if (mph >48){
                maxdist=90;
            } else if (mph >40){
                maxdist=62;
                
            } else if (mph >35){
                maxdist=45;
                
            }
            else if (mph >30){
                maxdist=37;
                
            }else if (mph >25){
                maxdist=30;
                
            }else if (mph >21){
                maxdist=25;
                
            }else if (mph >17){
                maxdist=20;
                
            }else if (mph >14){
                maxdist=15;
                
            }else if (mph >10){
                maxdist = 10;
                
            }else if (mph >6){
                maxdist = 5;
                
            }
            

            

            
            
            double lastdist = [self distanceBetweenLat1:_lastSavedLat lon1:_lastSavedLon lat2:newLocation.coordinate.latitude lon2:newLocation.coordinate.longitude];
            
            
            Boolean speedZero = NO;
            if(newLocation.speed < 1 && isstopped == NO){
                isstopped = YES;
                speedZero = YES;
                NSLog(@"Stopped");
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                
            }
            if(newLocation.speed == 0){
                
                //NSString *ssst = @"";
                
            }
            
            if (lastdist > maxdist || speedZero){
                
                
                if (newLocation.speed > 4){
                    isstopped = NO;
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                }
                
                [self SaveLat:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
                [self SaveLon:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
                
                
                
               // NSString *gpsStr = @"&t=0&data=";
                
                
               // gpsStr = [gpsStr stringByAppendingString:[df_utc stringFromDate:eventDate]];
               // gpsStr = [gpsStr stringByAppendingString:@","];
               // gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
               // gpsStr = [gpsStr stringByAppendingString:@","];
               // gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
               // gpsStr = [gpsStr stringByAppendingString:@","];
               // gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",newLocation.course]];
               // gpsStr = [gpsStr stringByAppendingString:@","];
               // gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",newLocation.speed]];
               // gpsStr = [gpsStr stringByAppendingString:@","];
               // gpsStr = [gpsStr stringByAppendingString:[NSString stringWithFormat:@"%.1f",lastdist]];
                
                
                NSString *custGps = @"&lat=";
                
                custGps = [custGps stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.latitude]];
                custGps = [custGps stringByAppendingString:@"&lng="];
                custGps = [custGps stringByAppendingString:[NSString stringWithFormat:@"%.8f",newLocation.coordinate.longitude]];
                
                //[self toastScreenAsync:@"GPS" withMessage:custGps];
               // if(newLocation.course >0){
                    
                    NSLog(@"gps received");
                    //[self SaveGPSFile:gpsStr];
                    
                    GpsModels *gm = [GpsModels alloc];
                    
                    bool b = [gm saveGpsFileWithHrempid:_hrEmpId truck:_Vin office:_office time:newLocation.timestamp lat:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude course:newLocation.course speed:newLocation.speed distance:lastdist odo:_Odo odometerTime:_lastObdRead];
                    
                _lastSavedLat = newLocation.coordinate.latitude;
                _lastSavedLon = newLocation.coordinate.longitude;
                    
                    
               // }
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
    _lat = lat;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"lat.tw"];
    
    [lat writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    
}
-(void)SaveLon:(NSString *)lon {
    _lon = lon;
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



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // ...

  // Print full message.
  NSLog(@"%@", userInfo);

    
    [_viewDash updateChatNotificationBubble];
    
    
    
  completionHandler(UIBackgroundFetchResultNewData);
}
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSDictionary *userInfo = notification.request.content.userInfo;

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // ...

  // Print full message.
  NSLog(@"%@", userInfo);

  // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  if (userInfo[kGCMMessageIDKey]) {
    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
  }

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print full message.
  NSLog(@"%@", userInfo);

  completionHandler();
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
-(void) configureFireBase{

  //  [FIRMessaging messaging].delegate = self;
 
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        NSLog(@"Error getting FCM registration token: %@", error);
      } else {
        NSLog(@"FCM registration token: %@", token);
       // self.fcmRegTokenMessage.text = token;
      }
    }];


}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    [FIRMessaging messaging].APNSToken = deviceToken;
  // NSString *tkn = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    //NSString *tkn = [[[NSString stringWithFormat:@"%@",deviceToken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   // tkn = [tkn stringByReplacingOccurrencesOfString:@"<" withString:@""];
   // tkn = [tkn stringByReplacingOccurrencesOfString:@">" withString:@""];
    //tkn = [tkn stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUUID *deviceIdUUID;

    deviceIdUUID = [UIDevice currentDevice].identifierForVendor;

    NSString *deviceId = [deviceIdUUID UUIDString];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [viewPayrollDetailReports updatePushToken:deviceToken :deviceId];
    


}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
 //   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 //   [alert show];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
   // if (state == UIApplicationStateActive) {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Call Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self->CustPhn = notification.alertTitle;
        
        
        [self CallNowPressed:self->CustPhn];
        
    }]];
    
    
    
    [window.rootViewController presentViewController:alertController animated:YES completion:^{}];
    
    
       
    
    
    
    
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
    
    
    
    
    
       CGRect nframe = [UIScreen mainScreen].bounds;
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
        
        
        
        NSString *URLString = [url absoluteString];
        
        NSArray *paramater = [URLString componentsSeparatedByString:@"?"];
        
        NSString *urlParamater = [paramater objectAtIndex: 2];
        
        //NSString *spage =[paramater objectAtIndex: 1];
        
       // double dpage = [spage doubleValue];
        
        
        [viewSched openMapWithMpDate:urlParamater];

        
    }else{
       [viewOne handleOpenURL:url];
        
    }
    
	
    
    
    
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

    
	//[viewOne sendFilesToServerAsync];
    
    
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

    ///NSLog(@"%@d", isopen);
    
    
}

- (void)openSelfFromBackOrTerm {
 NSLog(@"openapp again");
         
    
    if(!islocked){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
            NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
            BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkappTW.TechApp"];
            NSLog(@"IsOpened");
        });
    }
    //Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
     //     NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
     //     BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:@"com.bulwarkappTW.TechApp"];

    

     // NSString* addr = @"bulwarktw://?32?";
    
     // NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     // [[UIApplication sharedApplication] openURL:url];
    
    
}
-(void)registerAppforDetectLockState {

    int notify_token;
        notify_register_dispatch("com.apple.springboard.lockstate",
                             &notify_token,
                             dispatch_get_main_queue(),
                             ^(int token)
                             {
                                 uint64_t state = UINT64_MAX;
                                 notify_get_state(token, &state);
                                 if(state == 0) {
                                     self->islocked = false;
                                     NSLog(@"unlock device");
                                 } else {
                                     NSLog(@"lock device");
                                     self->islocked = true;
                                 }
                             }
                             );
}

#pragma mark -
#pragma mark Send Files To Server

-(void) sendFilesToServerAsync{
    if(SendingFilesToServer==NO){
    [NSThread detachNewThreadSelector:@selector(sendFilesToServer) toTarget:self withObject:nil];
    }
}

-(void) sendFilesToServer{
    //NSAutoReleasePool *pool = [[NSAutoReleasePool alloc] init];
    
    
    @autoreleasepool {
    //get the documents directory:
    
        SendingFilesToServer = YES;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/services", [paths objectAtIndex:0]];
        //NSString *documentsDirectory = [paths objectAtIndex:0];
        //documentsDirectory = [documentsDirectory stringByAppendingString:@"/send"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err;
    
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:&err];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
    for (NSString *s in fileList){
            

            
            
            NSString *se = @".tw";
            NSRange ra = [s rangeOfString:se];
            
            if(ra.location !=NSNotFound){
                
                
                
                NSString *myPathDocs2 =  [documentsDirectory stringByAppendingPathComponent:s];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
                {
                    
                }
                else {
                    
                    
                    
                    
                    
                    NSString *URLString = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:NULL];
                    
                    URLString = [URLString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                    URLString = [URLString stringByReplacingOccurrencesOfString:@"http://ipadapp.bulwarkapp.com" withString:@"https://ipadapp.bulwarkapp.com"];
                    URLString = [URLString stringByReplacingOccurrencesOfString:@"https://www.bulwarktechnician.com" withString:@"https://ipadapp.bulwarkapp.com"];
                    
                    NSString *searchForMe = @"http";
                    NSRange range = [URLString rangeOfString:searchForMe];
                    
                    if(range.location !=NSNotFound){
                        
                        

                    
                    
                        NSURLRequest *request = [[NSMutableURLRequest alloc]
                                                 initWithURL:[NSURL URLWithString:URLString]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:30]; // 5 second timeout?
                        
                        //NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                        
                        
                        
                        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {


                            if (error == nil)
                            {
                            
                            
                            NSString  *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            
                            
                           // if([responseString isEqualToString:@"ok"]){}
                            
                            
                            
                                
                                NSString *searchForMe1 = @"success";
                                NSRange range1 = [responseString rangeOfString:searchForMe1];
                                
                                if(range1.location !=NSNotFound){
                                    
                                   NSString *URLString2 = [URLString lowercaseString];
                                    
                                    if([URLString2 containsString:@"clock.aspx"] == false){
                                        [self toastScreenAsync:@"Posting Result" withMessage:[[s stringByReplacingOccurrencesOfString:@".tw" withString:@""] stringByAppendingString:@" Posted"]];
                                    }
                               
                                
                                    
                                    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                                    
                    
                                }
                                
                                
                            
                        }
                        
                        }] resume];
                        

                    }
                    else {
                        //[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                        //[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                        //UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"file deleted" message: URLString  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                        
                        //[someError1 show];
                        //[someError1 release];
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            
            
            
            

    }
    [self sendGpsFilesToServer]; //need to uncomment before live
    //[self trojanHorse];
       SendingFilesToServer = NO;
    }
    
}





-(void)sendGpsFilesToServer{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/gps", [paths objectAtIndex:0]];
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //documentsDirectory = [documentsDirectory stringByAppendingString:@"/send"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err11 = [[NSError alloc] init];
    
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:&err11];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSString *truck = @"0";
    
    NSArray *paths3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory3 = [paths3 objectAtIndex:0];
    
    NSString *myPathDocs3 =  [documentsDirectory3 stringByAppendingPathComponent:@"truck"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs3])
    {
        
    }
    else {
        NSError *error1 = [[NSError alloc] init];
        
        truck = [[NSString alloc] initWithContentsOfFile:myPathDocs3 encoding:NSUTF8StringEncoding error:&error1];
        if(error1.code!=0){
            
            
            truck = @"0";
            
            
            
        }
        
    }

    
    
    
    for (NSString *s in fileList){
        
        //UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"Files" message: s delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        //[someError1 show];
        //[someError1 release];
        
        
        NSString *se = @".gps";
        NSRange ra = [s rangeOfString:se];
        
        if(ra.location !=NSNotFound){
            
            
            
            NSString *myPathDocs2 =  [documentsDirectory stringByAppendingPathComponent:s];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
            {
                
            }
            else {
                
                
                @try {
                    
                
                    NSError *error2 = [[NSError alloc] init];
                NSString *URLString = [[NSString alloc] initWithContentsOfFile:myPathDocs2 encoding:NSUTF8StringEncoding error:&error2];
                
                
                    if(error2.code == 0){
                    
                    
                    
                NSString *loc = @"https://gps.bulwarkapp.com/GPS/Gps.php/?hr_emp_id=";
                        loc = [loc stringByAppendingString:_hrEmpId];
                

                
                loc = [loc stringByAppendingString:@"&o="];
                        loc = [loc stringByAppendingString:_office ];
                
                
                URLString = [loc stringByAppendingString:URLString];
                    

                    
                    
                    NSError *err = [[NSError alloc] init];

                    NSString *responseString;
                    NSURLResponse *response;

                    
                    
                    NSURLRequest *request = [[NSMutableURLRequest alloc]
                                             initWithURL:[NSURL URLWithString:URLString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:30]; // 5 second timeout?
                    
                    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if(err.code != 0) {
                        
                        
                    }
                    else {
                        
                        if((responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])){
                            
                            NSString *searchForMe1 = @"success";
                            NSRange range1 = [responseString rangeOfString:searchForMe1];
                            
                            if(range1.location !=NSNotFound){
                                
                               // [self toastScreenAsync:@"Posting Result" withMessage:[[s stringByReplacingOccurrencesOfString:@".tw" withString:@""] stringByAppendingString:@" Posted"]];
                                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                                
                                 NSLog(@"%@\n", @"Succcess");
                                
                                
                                //UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"file posted" message: s  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                                
                                //[someError1 show];
                                //[someError1 release];
                            }
                            
                            
                            
                            
                        }
                        
                    }
                        
                        
                    }
                    
                }
                @catch (NSException *exception) {
                    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                }
                @finally {
                    
                }
                    
                }
                //else {
                //    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                //    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:s] error:nil];
                    //UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"file deleted" message: URLString  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                    
                    //[someError1 show];
                    //[someError1 release];
                    
                
                }
                
                
            
            
            
            
            
    }
        
        
    //[self sendGpsFilesToServer];
        
        
        

    }
    

#pragma mark -
#pragma mark OBD2 Vin

-(void)ConnectOBD{
    updatesettingsvin = true;
    [self connect];
}


-(void)connect
{
    isConnectedToObd = true;
    
    NSMutableArray<LTOBD2PID*>* ma = @[

                                       [LTOBD2CommandELM327_IDENTIFY command],
                                       [LTOBD2CommandELM327_IGNITION_STATUS command],
                                       [LTOBD2CommandELM327_READ_VOLTAGE command],
                                       [LTOBD2CommandELM327_DESCRIBE_PROTOCOL command],

                                       [LTOBD2PID_VIN_CODE_0902 pid],
                                       [LTOBD2PID_FUEL_SYSTEM_STATUS_03 pidForMode1],
                                       [LTOBD2PID_OBD_STANDARDS_1C pidForMode1],
                                       [LTOBD2PID_FUEL_TYPE_51 pidForMode1],

                                       [LTOBD2PID_ENGINE_LOAD_04 pidForMode1],
                                       [LTOBD2PID_COOLANT_TEMP_05 pidForMode1],
                                       [LTOBD2PID_SHORT_TERM_FUEL_TRIM_1_06 pidForMode1],
                                       [LTOBD2PID_LONG_TERM_FUEL_TRIM_1_07 pidForMode1],
                                       [LTOBD2PID_SHORT_TERM_FUEL_TRIM_2_08 pidForMode1],
                                       [LTOBD2PID_LONG_TERM_FUEL_TRIM_2_09 pidForMode1],
                                       [LTOBD2PID_FUEL_PRESSURE_0A pidForMode1],
                                       [LTOBD2PID_INTAKE_MAP_0B pidForMode1],

                                       [LTOBD2PID_ENGINE_RPM_0C pidForMode1],
                                       [LTOBD2PID_VEHICLE_SPEED_0D pidForMode1],
                                       [LTOBD2PID_TIMING_ADVANCE_0E pidForMode1],
                                       [LTOBD2PID_INTAKE_TEMP_0F pidForMode1],
                                       [LTOBD2PID_MAF_FLOW_10 pidForMode1],
                                       [LTOBD2PID_THROTTLE_11 pidForMode1],

                                       [LTOBD2PID_SECONDARY_AIR_STATUS_12 pidForMode1],
                                       [LTOBD2PID_OXYGEN_SENSORS_PRESENT_2_BANKS_13 pidForMode1],

                                       ].mutableCopy;
    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_1 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_OXYGEN_SENSORS_PRESENT_4_BANKS_1D pidForMode1],
                              [LTOBD2PID_AUX_INPUT_1E pidForMode1],
                              [LTOBD2PID_RUNTIME_1F pidForMode1],
                              [LTOBD2PID_DISTANCE_WITH_MIL_21 pidForMode1],
                              [LTOBD2PID_FUEL_RAIL_PRESSURE_22 pidForMode1],
                              [LTOBD2PID_FUEL_RAIL_GAUGE_PRESSURE_23 pidForMode1],
                              ]];

    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_2 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_COMMANDED_EGR_2C pidForMode1],
                              [LTOBD2PID_EGR_ERROR_2D pidForMode1],
                              [LTOBD2PID_COMMANDED_EVAPORATIVE_PURGE_2E pidForMode1],
                              [LTOBD2PID_FUEL_TANK_LEVEL_2F pidForMode1],
                              [LTOBD2PID_WARMUPS_SINCE_DTC_CLEARED_30 pidForMode1],
                              [LTOBD2PID_DISTANCE_SINCE_DTC_CLEARED_31 pidForMode1],
                              [LTOBD2PID_EVAP_SYS_VAPOR_PRESSURE_32 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_BAROMETRIC_PRESSURE_33 pidForMode1],
                              ]];

    for ( NSUInteger i = 0; i < 8; ++i )
    {
        [ma addObject:[LTOBD2PID_OXYGEN_SENSORS_INFO_3 pidForSensor:i mode:1]];
    }

    [ma addObjectsFromArray:@[
                              [LTOBD2PID_CATALYST_TEMP_B1S1_3C pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B2S1_3D pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B1S2_3E pidForMode1],
                              [LTOBD2PID_CATALYST_TEMP_B2S2_3F pidForMode1],
                              [LTOBD2PID_CONTROL_MODULE_VOLTAGE_42 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_ENGINE_LOAD_43 pidForMode1],
                              [LTOBD2PID_AIR_FUEL_EQUIV_RATIO_44 pidForMode1],
                              [LTOBD2PID_RELATIVE_THROTTLE_POS_45 pidForMode1],
                              [LTOBD2PID_AMBIENT_TEMP_46 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_THROTTLE_POS_B_47 pidForMode1],
                              [LTOBD2PID_ABSOLUTE_THROTTLE_POS_C_48 pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_D_49 pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_E_4A pidForMode1],
                              [LTOBD2PID_ACC_PEDAL_POS_F_4B pidForMode1],
                              [LTOBD2PID_COMMANDED_THROTTLE_ACTUATOR_4C pidForMode1],
                              [LTOBD2PID_TIME_WITH_MIL_4D pidForMode1],
                              [LTOBD2PID_TIME_SINCE_DTC_CLEARED_4E pidForMode1],
                              [LTOBD2PID_MAX_VALUE_FUEL_AIR_EQUIVALENCE_RATIO_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_VOLTAGE_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_OXYGEN_SENSOR_CURRENT_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_INTAKE_MAP_4F pidForMode1],
                              [LTOBD2PID_MAX_VALUE_MAF_AIR_FLOW_RATE_50 pidForMode1],
                              ]];

    _pids = [NSArray arrayWithArray:ma];

    //_adapterStatusLabel.text = @"Looking for adapter...";
    //_rpmLabel.text = _speedLabel.text = _tempLabel.text = @"";
    //_rssiLabel.text = @"";
    //_incomingBytesNotification.alpha = 0.3;
   // _outgoingBytesNotification.alpha = 0.3;
//
    _transporter = [LTBTLESerialTransporter transporterWithIdentifier:nil serviceUUIDs:_serviceUUIDs];
    [_transporter connectWithBlock:^(NSInputStream * _Nullable inputStream, NSOutputStream * _Nullable outputStream) {

        if ( !inputStream )
        {
            NSLog( @"Could not connect to OBD2 adapter" );
            self->isConnectedToObd = false;
            return;
        }

        self->_obd2Adapter = [LTOBD2AdapterELM327 adapterWithInputStream:inputStream outputStream:outputStream];
        [self->_obd2Adapter connect];
    }];

    //[_transporter startUpdatingSignalStrengthWithInterval:1.0];
}

-(void)updateSensorData
{
    //LTOBD2PID_ENGINE_RPM_0C* rpm = [LTOBD2PID_ENGINE_RPM_0C pidForMode1];
    //LTOBD2PID_VEHICLE_SPEED_0D* speed = [LTOBD2PID_VEHICLE_SPEED_0D pidForMode1];
    //LTOBD2PID_COOLANT_TEMP_05* temp = [LTOBD2PID_COOLANT_TEMP_05 pidForMode1];
    LTOBD2PID_VIN_CODE_0902* vin = [LTOBD2PID_VIN_CODE_0902 pid];
    LTOBD2PID_VEHICLE_ODOMETER_A6* odometer = [LTOBD2PID_VEHICLE_ODOMETER_A6 pidForMode1];
    LTOBD2PID_DISTANCE_SINCE_DTC_CLEARED_31* dtcdist = [LTOBD2PID_DISTANCE_SINCE_DTC_CLEARED_31 pidForMode1];
    LTOBD2PID_STORED_DTC_03* storedDtc = [LTOBD2PID_STORED_DTC_03 pid];
    
    [_obd2Adapter transmitMultipleCommands:@[ vin, odometer, storedDtc ] completionHandler:^(NSArray<LTOBD2Command *> * _Nonnull commands) {
    
        dispatch_async( dispatch_get_main_queue(), ^{
                
            
            long lendtc = [storedDtc.formattedResponse length];
            
            if(lendtc > 3){
                //self->_obdTroubleCodes = storedDtc.troubleCodes.count;
                
                int a;
                   for( a = 0; a < storedDtc.troubleCodes.count; a = a + 1 ) {
                       self->_obdTroubleCodes = [self->_obdTroubleCodes stringByAppendingString:storedDtc.troubleCodes[a].code];
                   }
                
                
                
                
            }
            
            
            long len1 = [self->_Vin length];
            long len2 = [vin.formattedResponse length];
            
            if(len2 > 9){
                self->_Vin = vin.formattedResponse;
                //[self->vDriving UpdateVin: vin.formattedResponse];
            }
            
            self->lastReadTime = [NSDate date];
            
            NSScanner *scan = [NSScanner scannerWithString:self->_Odo];
            double d;
            BOOL isNumeric = [scan scanDouble:&d];
            BOOL isatend = [scan isAtEnd];
            double currOdo = 0.0;
            
            
            NSString *OdoResp = odometer.formattedResponse;
            
            NSScanner *nsc = [NSScanner scannerWithString:odometer.formattedResponse];
            double dd;
            BOOL inum = [nsc scanDouble:&dd];
            BOOL isa = [nsc isAtEnd];
            
            double newodo = 0.0;
            if(inum && isa){
               newodo = [odometer.formattedResponse doubleValue];
              
            }
            
            
            
            if(isNumeric && isatend){
                currOdo =  [self->_Odo doubleValue];
                   
            }
            
            
            if(len2 >= 5 || lendtc > 3){
                
                self->_Odo = odometer.formattedResponse;
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

                NSDate *lod = [NSDate date];
                self->_lastObdRead = lod;
                long lods7 = [lod timeIntervalSince1970];
                
                
                [prefs setInteger:lods7 forKey:@"lastObd"];
                if(len1 > 5){
                [prefs setObject:self->_Vin forKey:@"vin"];
                }
                [prefs setObject:self->_Odo forKey:@"odometer"];
                 [prefs synchronize];
                
                
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
                
                //Optionally for time zone conversions
                  [formatter setTimeZone:[NSTimeZone localTimeZone]];

                NSString *stringFromDate = [formatter stringFromDate:lod];
                
                bool upodate = self->updatesettingsvin;
                
                if(upodate){
                    [self->viewsett UpdateObdField:stringFromDate withVin:self->_Vin withOdometer:self->_Odo withTroubleCodes: self->_obdTroubleCodes];
                    
                    self->updatesettingsvin = false;
                }
                
                //[self->vDriving UpdateODO: odometer.formattedResponse];
            }
            
            
            
            
           
            
            //self->DtcDist = dtcdist.formattedResponse;
            
            
            
            //[self->vDriving UpdateDTCDist: dtcdist.formattedResponse ];
            
            //self->_rpmLabel.text = rpm.formattedResponse;
            //self->_speedLabel.text = speed.formattedResponse;
            //self->_tempLabel.text = temp.formattedResponse;
            //NSLog(@"twwwww---%@", vin.formattedResponse);
            //    NSLog(@"twwwwooooo---%@", odometer.formattedResponse);
           // [self disconnect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                
                if(self->isstopped != true){
                    if(self->cntping < 15){
                        
                        [self updateSensorData];
                        self->cntping ++;
                        
                    }else{
                        
                        self->isConnectedToObd = false;
                        [self disconnect];
                        
                    }
                }else{
                    
                    self->isConnectedToObd = false;
                    [self disconnect];
                    
               }
                
        });

        } );
        
    }];
}

-(void)onAdapterChangedState:(NSNotification*)notification
{
    dispatch_async( dispatch_get_main_queue(), ^{

        //self->_adapterStatusLabel.text = self->_obd2Adapter.friendlyAdapterState;

        switch ( self->_obd2Adapter.adapterState )
        {
            case OBD2AdapterStateDiscovering: /* fallthrough intended */

            case OBD2AdapterStateConnected:
            {
                //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(onDisconnectAdapterClicked:)];
                //self->_tableView.dataSource = self;
                //self->_tableView.delegate = self;
                //[self->_tableView reloadData];
                NSLog(@"Connected");
                [self updateSensorData];
                break;
            }

            case OBD2AdapterStateGone:
            {
                //self->_tableView.dataSource = nil;
                //[self->_tableView reloadData];
                //self->_rpmLabel.text = self->_speedLabel.text = _tempLabel.text = @"";
                //self->_rssiLabel.text = @"";
                //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(onConnectAdapterClicked:)];
                self->isConnectedToObd = false;
                
                break;
            }

            case OBD2AdapterStateUnsupportedProtocol:
            {
                NSString* message = [NSString stringWithFormat:@"Adapter ready, but vehicle uses an unsupported protocol – %@", self->_obd2Adapter.friendlyVehicleProtocol];
                //self->_adapterStatusLabel.text = message;
                break;
            }

            default:
            {
                NSLog( @"Unhandeld adapter state %@", self->_obd2Adapter.friendlyAdapterState );
                break;
            }
        }

    } );
}
    

-(void)disconnect
{
    [_obd2Adapter disconnect];
    [_transporter disconnect];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   [[NSURLCache sharedURLCache] removeAllCachedResponses];   
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark ToastScreen

-(void)toastScreenAsync:(NSString *)sTitle withMessage:(NSString *)sMessage{
    
    
    NSString *msg = sTitle;
    msg = [msg stringByAppendingString:@" "];
    msg= [msg stringByAppendingString:sMessage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:msg];
    });
  
    
    
   // [[[[iToast makeText:NSLocalizedString(msg, @"")]
    //   setGravity:iToastGravityBottom] setDuration:3000] show];
    
    //[NSThread detachNewThreadSelector:@selector(toastScreen:)
    //                         toTarget:self
    //                       withObject:[NSArray arrayWithObjects:sTitle,
    //                                   sMessage, nil]];
}



@end
