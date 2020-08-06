//
//  VideoTableCell.m
//  BulwarkTW
//
//  Created by Kole on 2/19/16.
//
//

#import "VideoTableView.h"
#import "VideoTableCell.h"
#import "RGSViewController.h"
#import "VideoDataObject.h"
#import "BulwarkTWAppDelegate.h"

@interface VideoTableCell ()

@end



@implementation VideoTableCell : UITableViewCell
{
    BulwarkTWAppDelegate *delegate;
    
  @private  UIView* cellView;
    @private   UILabel *label;
    @private   UILabel *description ;
    @private   RGSSystem *VideoCellSubSystem ;

@private UIImage *starImg;
    
    @private   BOOL selected;
}



//@private MPMoviePlayerViewController *videoPlayer;

- (id) initWithClass:(VideoDataObject *)vid{
    //self = [super init :reuseWithIndentifier];
    self =  [super init];
    if (self) {
        video = vid;
    delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
         NSString *ttt = @"init wclass: ";
          NSLog(@"%@",[ttt stringByAppendingString:[video title]]);
        
    // selected = false;
    
    cellView = [[UIView alloc] initWithFrame:self.contentView.frame];
    cellView.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] init];
    // [label setCenter:CGPointMake(conversation.frame.size.width / 2, conversation.frame.size.height / 2)];
    // [label sizeToFit];
    [cellView addSubview:label];
    
        //starImg= [[UIImage alloc] init]; //create ImageView
        
        //starImg = [UIImage imageNamed:@"Video.png"];
    
        //[cellView addSubview:starImg];
    
    description = [[UILabel alloc] init];
    
    // NSLog("Available fonts: %@", UIFont.);
    
    // [label setCenter:CGPointMake(conversation.frame.size.width / 2, conversation.frame.size.height / 2)];
    // [label sizeToFit];
    [cellView addSubview:description];
    
    // [homeFeedButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome-webfront" size:8]];
    //  NSString *str = [NSString stringWithFormat:@"%C", @"\f030"];
    
    //[[[UILabel alloc] initWithFrame:CGRectZero] setText:@"\uf030"];
    
        
        
        //////////////////////////
        
        
        //////////////////////////
        
        
        
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self           action:@selector(handleTap:)];
    
   [tap setCancelsTouchesInView:NO];
    [self.contentView addSubview:cellView];
    
       VideoCellSubSystem = [[RGSSystem alloc]init];
   // [self.contentView addGestureRecognizer:tap];
    }
    return self;
}
//MPMoviePlayerViewController *videoPlayer;





- (id) initWithClass:(VideoDataObject *)vid reuseWithIndentifier:(NSString*)reuseWithIndentifier{
    //self = [super init :reuseWithIndentifier];
    self =  [super initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseWithIndentifier];
    if (self) {
        video = vid;
  
    
        NSString *ttt = @"init wclass rwidentifier : ";
        NSLog(@"%@",[ttt stringByAppendingString:[video title]]);

        
   // selected = false;
    
    cellView = [[UIView alloc] initWithFrame:self.contentView.frame];
    cellView.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] init];
    // [label setCenter:CGPointMake(conversation.frame.size.width / 2, conversation.frame.size.height / 2)];
    // [label sizeToFit];
    [cellView addSubview:label];
    
    
    
    
    description = [[UILabel alloc] init];
 
    // NSLog("Available fonts: %@", UIFont.);
    
    // [label setCenter:CGPointMake(conversation.frame.size.width / 2, conversation.frame.size.height / 2)];
    // [label sizeToFit];
    [cellView addSubview:description];
    
    // [homeFeedButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome-webfront" size:8]];
    //  NSString *str = [NSString stringWithFormat:@"%C", @"\f030"];
    
    //[[[UILabel alloc] initWithFrame:CGRectZero] setText:@"\uf030"];
    
    
       VideoCellSubSystem = [[RGSSystem alloc]init];
    
        
        
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ////
        
        
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
       //label.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.05f];
        [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:24]];
        label.text = [video title];
        
        
        
        description.textColor = [UIColor darkGrayColor];
        
        
        
        
        
        [description setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        
        //description.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.08f];
        description.numberOfLines = 0;
        description.lineBreakMode = UILineBreakModeWordWrap;
        
        NSString *t =  @"  "; //@"\uf24e   ";
       // description.text = [t stringByAppendingString:[video description]];
        
        [self setDownloadIcon:0];
     
        
 
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self           action:@selector(handleTap:)];
        
        [tap setCancelsTouchesInView:NO];
        
        
        

    [self.contentView addSubview:cellView];
    
    
    [self.contentView addGestureRecognizer:tap];
     }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
    }
    
    return self;
    
}



- (void)layoutSubviews {
    [super layoutSubviews];

      cellView.frame = self.contentView.frame;
    
        [VideoCellSubSystem createPoints:cellView];
    
 //   if(index !=  videoTableView->selectedNumber){
    

    
 
     //   if(videoPlayer.view.hidden == false) videoPlayer.view.hidden = true;
     //   if(videoPlayer.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) [videoPlayer.moviePlayer stop];
        
        

    

    
    
    label.frame = CGRectMake([VideoCellSubSystem oneTwentiethLeft] , [VideoCellSubSystem oneTwentiethTop], [VideoCellSubSystem thirteenTwentiethsLeft],[VideoCellSubSystem sixTwentiethsTop]);

    
    
    
    
    description.frame = CGRectMake([VideoCellSubSystem twoTwentiethsLeft] , [VideoCellSubSystem eightTwentiethsTop], [VideoCellSubSystem fourteenTwentiethsLeft],[VideoCellSubSystem elevenTwentiethsTop]);

    
    [description sizeToFit];
    

    


}


-(void)setDownloadIcon:(int)icon{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];

    if(icon != 2){
        
        if([delegate.videoTableView doesVideoExistLocally:video] == YES){
            attachment.image = [UIImage imageNamed:@"downloaded.PNG"];
            
        }else{
            
            attachment.image = [UIImage imageNamed:@"notdownloaded.PNG"];
            
        }
        
         }
    else{
          attachment.image = [UIImage imageNamed:@"downloading.PNG"];
    }
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@""];
        [myString appendAttributedString:attachmentString];
        
        NSMutableAttributedString *myString2= [[NSMutableAttributedString alloc] initWithString:[@"  " stringByAppendingString:[video description]]];
        
        
        [myString appendAttributedString:myString2];
        
        
        description.attributedText = myString;
   
    
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
delegate = (BulwarkTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.videoTableView showVideo:video cellReference:self];
    
  //  NSString *ttt = @"Tapped: ";
 //   NSLog(@"%@",[ttt stringByAppendingString:[video title]]);
   
    
  //  NSMutableArray *modifiedRows = [NSMutableArray array];
  //  [modifiedRows addObject:indexPath];

    
    //  NSString *tag = recognizer.view.tag;
   //videoTableView->selectedNumber = index;
//
 //   [videoTableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionTop];
    // [videoTableView beginUpdates];
    //[videoTableView endUpdates];
   // [videoTableView reloadRowsAtIndexPaths:modifiedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    //   [videoTableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionTop];
  
 //  videoTableView->selectedNumber = index;
 //   [videoTableView beginUpdates];
 //   [videoTableView endUpdates];
}





@end
