#import "RGSViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDataObject.h"
#import "BulwarkTWAppDelegate.h"

@interface RGSViewController ()

@end

@implementation RGSViewController{
    
RGSSystem *GSMainSystem;
    @public RGSSystem *GSSubSystem;
    UIView *someSampleBox;
    BulwarkTWAppDelegate *delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    

    [self createPoints];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*- (instancetype)init {
    
   //  [self createPoints];
    return self;
}
*/

/*
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        //init stuff here
        [self createPoints];
    }
    
    return self;
}
 */

-(void)createPoints
{
    
    GSMainSystem = [[RGSSystem alloc]init];
    //create one of these for each view you want to use the grid system on.
    [GSMainSystem createPoints:self.view]; //creates the grid values. [self view] is the view to use to calculate points for our fractions. EG tenTwentiethsLeft will be 10/12 across on the [self view] view
    
  
    
    
    
    
    
    someSampleBox = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 768 , 955)];
    [someSampleBox setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:someSampleBox];
    
    //Let's add a subivew using another Grid System
    GSSubSystem = [[RGSSystem alloc]init];
    [GSSubSystem createPoints:someSampleBox];
    
    //x,y,w,h
    NSString *videoURLString = @"https://www.bulwarktechnician.com/videos/f9f1a209-edc5-4625-aa3e-0c519abd0bf6-termite-story-720.mp4";
    NSURL *videoURL = [NSURL URLWithString:videoURLString];

    
       delegate.placesArray = [[NSMutableArray alloc] init];
    
    
    
    
    ////Video List box
    NSURL *url = [NSURL URLWithString:@"https://api.bulwarkapp.com/vsql3/handheld/uploadedvideos/getall?apikey=18111f78-7c2e-160c-0c1f-f303296d0c15"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
 
}




-(void)setupPlacesFromJSONArray:(NSData*)dataFromServerArray{
  
  //  NSMutableArray *placesArray = [[NSMutableArray alloc] init];
    
    NSError *e = nil;
    NSArray *arrayFromServer = [NSJSONSerialization JSONObjectWithData:dataFromServerArray options:0 error:&e];
    
    if(e){
        NSLog(@"error parsing the json data from server with error description - %@", [e localizedDescription]);
    }
    else {
        delegate.placesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *eachPlace in arrayFromServer)
        {
            VideoDataObject *place = [[VideoDataObject alloc] initWithJSONData:eachPlace];
            [delegate.placesArray addObject:place];
        }
        
        //Now you have your placesArray filled up with all your data objects
    }
 
    delegate.videoTableView = [[VideoTableView alloc]   initWithFrame:CGRectMake(0,0, 768, 955) ];
  
      [someSampleBox addSubview:delegate.videoTableView];


    //UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
   // [aButton setTitle:@"X" forState:UIControlStateNormal];
   // [aButton addTarget:self action:@selector(tapped:)     forControlEvents:UIControlEventTouchUpInside];
  //  aButton.frame = CGRectMake(someSampleBox.bounds.origin.x, someSampleBox.bounds.origin.y, 30, 30);// adjust with respect to bounds
  //  aButton.backgroundColor = [UIColor redColor];
  //
    
  //   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self           action:@selector(handleTap:)];
    
  //    [tap setCancelsTouchesInView:NO];
  //  [aButton addGestureRecognizer:tap];
  //  [someSampleBox addSubview:aButton];


}



- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    //[self.view setHidden:YES];
}


-(void)connectionWasASuccess:(NSData *)data{
//    [self setupPlacesFromJSONArray:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"videosJson";
    
  // const NSInteger currentLevel = ...;
    [preferences setObject:data forKey:currentLevelKey];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave)
    {
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    
    
    [self setupPlacesFromJSONArray:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"@ERROR: %@",[error localizedDescription]);
    
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"videosJson";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        //  Doesn't exist.
    }
    else
    {
        //  Get current level
       // const NSInteger currentLevel = [preferences integerForKey:currentLevelKey];
    
        [self setupPlacesFromJSONArray:[preferences objectForKey:currentLevelKey]];
    
    }
}



@end
