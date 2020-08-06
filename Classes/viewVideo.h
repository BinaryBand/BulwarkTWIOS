//
//  viewVideo.h
//  BulwarkTW
//
//  Created by Terry Whipple on 10/25/14.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface viewVideo : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    
    IBOutlet UIProgressView *progressView;
    IBOutlet UIButton *btnDownload;
    IBOutlet UITextView *description;
    IBOutlet UILabel *gtitle;
    
    IBOutlet UITableView *tbl;
    
}

@property (nonatomic,strong) MPMoviePlayerController* mc;
@property (nonatomic,strong) NSNumber* filesize;

@end
