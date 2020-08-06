//
//  VideoTableView.m
//  BulwarkTW
//
//  Created by Kole on 2/18/16.
//
//

#import "VideoTableView.h"
#import "RGSViewController.h"
#import "VideoDataObject.h"
#import "VideoTableCell.h"
#import <UIKit/UIKit.h>
#import "BulwarkTWAppDelegate.h"

@interface VideoTableView ()

@end

@implementation VideoTableView : UITableView
{
    BulwarkTWAppDelegate *delegate;
}
- (void)viewDidLoad {
    
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        //init stuff here
      //    [self setDataSource:self];
    }
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    [super setDelegate:self];
    self.delegate = self;
    [self setDataSource:self];
    self.allowsMultipleSelection = false;
    self.allowsSelection = true;
    self.allowsSelectionDuringEditing = false;
    self.allowsMultipleSelectionDuringEditing = false;
    NSParameterAssert(self.allowsSelection);
    delegate.videoTableView = self;
    selectedNumber = -1;
    
    HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    [HUD hide:YES];
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.rowHeight = 200;
    [self setSeparatorColor:[UIColor blackColor]];
   // [self setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [self setSeparatorEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] ];
     return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   /* if ([indexPath row] == selectedNumber) {
        return  tableView.frame.size.height * 0.9;
        
        

    }*/
   // else
        return 100;
    
  
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //We check against table to make sure we are displaying the right number of cells
    // for the appropriate table. This is so that things will work even if one day you
    //decide that you want to have two tables instead of one.
    if(tableView == delegate.videoTableView){
        return([delegate.placesArray count]);
    }
    return 0;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    if(row == selectedNumber) return YES;
 
    return YES;
    
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        VideoDataObject *currentPlace = [delegate.placesArray objectAtIndex:indexPath.row];
    VideoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[currentPlace uniqueFileName]];
       // VideoTableCell *cell = [tableView //dequeueReusableCellWithIdentifier:indexPath];
    if(cell)
    {
        //set your configuration of your cell
    } else{
    
        cell = [[VideoTableCell alloc] initWithClass:currentPlace reuseWithIndentifier:[currentPlace uniqueFileName]];
        cell->index = indexPath.row;
        cell->indexPath = indexPath;
       // cell == [[VideoTableCell alloc] initWithNibName:@"VideoTableCell" bundle:nil];
        //      [[[NSBundle mainBundle] loadNibNamed:@"firstView" owner:self options:nil] firstObject];
    }
    //The beauty of this is that you have all your data in one object and grab WHATEVER you like
    //This way in the future you can add another field without doing much.
    
    if([delegate.placesArray count] == 0){
        cell.textLabel.text = @"no places to show";
    }
    else{
       /*
        VideoDataObject *currentPlace = [placesArray objectAtIndex:indexPath.row];
        cell = [[VideoTableCell alloc] initWithClass:currentPlace];
        cell->index = indexPath.row;
        cell->indexPath = indexPath;
        
        */
        
        
        
        // VideoDataObject *currentPlace = [placesArray objectAtIndex:indexPath.row];
       // cell.textLabel.text = [currentPlace title];
       
       // cell.textLabel.font = [ cell.textLabel.font fontWithSize:12];
        
      //  cell.textLabel.tag = [currentPlace uniqueFileName];
        
        
      //  [cell addSubview:<#(UIView *)#>]
        
      //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                                      action:@selector(handleTap:)];

      //  [cell.textLabel addGestureRecognizer:tap];
        // in the future you can grab whatever data you need like this
        //[currentPlace placeName], or [currentPlace placeDay];
    }
    

    return(cell);
}
//int selectedNumber = -1;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    //if(row == selectedNumber) return;
    selectedNumber = row;
    
  //  [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]
  //                   atScrollPosition:UITableViewScrollPositionTop animated:NO];
     /*    [UIView setAnimationsEnabled:NO];
    self.allowsSelection = false;
    [tableView beginUpdates];
    [tableView endUpdates];
    self.allowsSelection = true;
    
    [UIView setAnimationsEnabled:YES];
        
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    CGPoint point = tableView.contentOffset;
    point .y -= tableView.rowHeight;
    tableView.contentOffset = point;
    [tableView beginUpdates];
    [tableView endUpdates];*/
  //  [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:true];
    


    
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

   // if(selectedNumber == -1) return;
    
    //selectedNumber = -1;
    
//[tableView beginUpdates];
   //[tableView endUpdates];
    
}

-(void)DownloadVideo:(NSString *)url vid:(VideoDataObject*)vid cellReference:(VideoTableCell*)tableCell
{
    [HUD show:YES];
    //download the file in a seperate thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSString *urlToDownload = url;
        NSURL  *url1 = [NSURL URLWithString:urlToDownload];
        NSLog(@"%@", urlToDownload);
        NSData *urlData = [NSData dataWithContentsOfURL:url1];
        if ( urlData )
        {
            
            NSLog(@"%@", urlToDownload);
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[vid uniqueFileName]];
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                [tableCell setDownloadIcon:1];
                [self playDownloadedVideo:vid cellReference:tableCell];
                
                NSLog(@"File Saved !");
                [HUD hide:YES];
            });
        }
        
    });
}

static bool isVideoSetup = NO;
static bool videoPlayerAddedToView = NO;
RGSSystem *ss;
RGSSystem *ss2;
UIView *videoPopup;
UIButton *aButton;

MPMoviePlayerViewController *videoPlayer;

NSString *videoURLString = @"https://www.bulwarktechnician.com/videos/videos-Technician/";

-(void)showVideo:(VideoDataObject *)vid cellReference:(VideoTableCell*)tableCell{
    
    if([self doesVideoExistLocally:vid] == NO){
        
        [tableCell setDownloadIcon:2];
        
           NSURL *videoURL = [NSURL URLWithString:[videoURLString stringByAppendingString:[vid uniqueFileName]]];
        
        [self DownloadVideo:[videoURLString stringByAppendingString:[vid uniqueFileName]] vid:vid cellReference:tableCell];
        
        
        
        
    } else{
        [self playDownloadedVideo:vid cellReference:tableCell];
    }
    
    
    
}

-(void)playDownloadedVideo:(VideoDataObject *)vid cellReference:(VideoTableCell*)tableCell{
    
    
    [tableCell setDownloadIcon:1];
    
    
    if (isVideoSetup == NO) {
        ss  = [[RGSSystem alloc]init];
        ss2 = [[RGSSystem alloc]init];
        videoPopup = [[UIView alloc] init];
        videoPopup.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15f];
        isVideoSetup = YES;
        [delegate.videoTableView addSubview:videoPopup];
        
        videoPlayer = [[MPMoviePlayerViewController alloc] init];
        videoPlayer.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        videoPlayer.moviePlayer.shouldAutoplay = NO;
        
        videoPlayer.moviePlayer.view.backgroundColor =[[UIColor greenColor] colorWithAlphaComponent:0.05f];
        videoPlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        
        
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setTitle:@"X" forState:UIControlStateNormal];
        // [aButton addTarget:self action:@selector(tapped:)     forControlEvents:UIControlEventTouchUpInside];
        
        aButton.backgroundColor = [UIColor redColor];
        aButton.tag = 4;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self           action:@selector(handleTap:)];
        
        [tap setCancelsTouchesInView:NO];
        [aButton addGestureRecognizer:tap];
        [videoPopup addSubview:aButton];
    }
    if(videoPopup.isHidden == YES){
        [videoPopup  setHidden:NO];
    }
    
    
    [ss createPoints:delegate.videoTableView];
    
    videoPopup.frame = CGRectMake([ss oneTwentiethLeft] , [ss oneTwentiethTop], [ss eighteenTwentiethsLeft],[ss eighteenTwentiethsTop]);
    
    [ss2 createPoints:videoPopup];
    
    if(videoPlayerAddedToView == NO){
        [videoPopup addSubview:videoPlayer.moviePlayer.view];
        videoPlayerAddedToView = YES;
    }
    
    videoPlayer.moviePlayer.view.frame = CGRectMake([ss2 oneTwentiethLeft] , [ss2 oneTwentiethTop] , [ss2 eighteenTwentiethsLeft],[ss2 eighteenTwentiethsTop]);
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[vid uniqueFileName]];
    NSURL *movieURL = [NSURL fileURLWithPath:filePath];
    
    [videoPlayer.moviePlayer setContentURL:movieURL];
    
    [videoPlayer.moviePlayer prepareToPlay];
    [videoPlayer.moviePlayer play];
    
    
    aButton.frame = CGRectMake(videoPopup.bounds.origin.x, videoPopup.bounds.origin.y, 30, 30);// adjust with respect to bounds
    
    
    
}


-(BOOL)doesVideoExistLocally:(VideoDataObject *)vid{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[vid uniqueFileName]];
    
    //NSString *pathForFile;
    
    if ([fileManager fileExistsAtPath:filePath]){
        return YES;
    } else return NO;
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSInteger *tag = recognizer.view.tag;
    
    if(tag == 4){
        
        [videoPlayer.moviePlayer setFullscreen:NO];
        [videoPlayer.moviePlayer stop];
        [videoPlayer.moviePlayer.view removeFromSuperview];
        
        [videoPopup setHidden:YES];
        
        videoPlayerAddedToView = NO;
        
    }
    
}

@end
