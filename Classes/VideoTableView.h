//
//  VideoTableView.h
//  BulwarkTW
//
//  Created by Kole on 2/18/16.
//
//
#import <UIKit/UIKit.h>
#import "VideoDataObject.h"
#import "VideoTableCell.h"
#import "MBProgressHUD.h"

@interface VideoTableView : UITableView
{
@public NSInteger *selectedNumber;
    
    MBProgressHUD *HUD;
}

-(void)showVideo:(VideoDataObject*)vid cellReference:(VideoTableCell*)tableCell;

-(BOOL)doesVideoExistLocally:(VideoDataObject*)vid;


@end
