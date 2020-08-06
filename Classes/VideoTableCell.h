//
//  VideoTableCell.h
//  BulwarkTW
//
//  Created by Kole on 2/19/16.
//
//

#import <UIKit/UIKit.h>
#import "VideoDataObject.h"
@class VideoTableCell;
@interface VideoTableCell : UITableViewCell{
    

VideoDataObject *video;
    @public NSInteger *index;
    
@public NSIndexPath *indexPath;
 
}

- (id) initWithClass:(VideoDataObject *)vid;
- (id) initWithClass:(VideoDataObject *)vid reuseWithIndentifier:(NSString*)reuseWithIndentifier;

-(void)setDownloadIcon:(int)icon;


/*

@property (strong, nonatomic)
IBOutlet UIView *view;

@property (strong, nonatomic)
IBOutlet UILabel *title;

@property (strong, nonatomic)
IBOutlet UILabel *description;


@property (strong, nonatomic)
IBOutlet UIImageView *videoIcon;

@property (strong, nonatomic)
IBOutlet UIImageView *downloadedIcon;*/

@end


