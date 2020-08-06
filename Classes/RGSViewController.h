#import <UIKit/UIKit.h>
#import "RGSSystem.h"
#import "VideoTableView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"





// MPMoviePlayerViewController *moviePlayerView;
@interface RGSViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
        MBProgressHUD *HUD;

}

-(void)connectionWasASuccess:(NSData *)data;

@end
