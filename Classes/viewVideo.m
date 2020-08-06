//
//  viewVideo.m
//  BulwarkTW
//
//  Created by Terry Whipple on 10/25/14.
//
//

#import "viewVideo.h"

@interface viewVideo ()

@end

@implementation viewVideo{
    NSArray *tableData;
    NSIndexPath *previousSelectedCellIndexPath;
    NSURLConnection *connection;
    NSMutableData *data;
    MPMoviePlayerController *controller;
    NSString *fileName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *newDirectory = [NSString stringWithFormat:@"%@/video", [paths objectAtIndex:0]];
    
    // Check if the directory already exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    
    NSURL *url = [NSURL URLWithString:@"http://ubuntu.bulwarkapp.com/techvideo/index.php"];
    NSError* error;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
   
    
   tableData= [content componentsSeparatedByString: @","];
    
    
    
     NSString *filepath = [[NSBundle mainBundle] pathForResource:@"5sec" ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    
   // NSURL *url = [NSURL URLWithString:videoLink];
    
    //  NSURL *url = [NSURL URLWithString:
    //              @"http://www.example.com/video.mp4"];
    controller = [[MPMoviePlayerController alloc]
                                           initWithContentURL:fileURL];
    
    self.mc = controller; //Super important
    
    //CGRectMake(193, 20, 399, 291)
    
    CGRect newRectangle = CGRectMake(240, 25, 520, 365);
    controller.view.frame = newRectangle;//self.view.bounds; //Set the size
    
    [self.view addSubview:controller.view]; //Show the view
   // [controller play]; //Start playing
    btnDownload.hidden = YES;
    description.hidden = YES;
    gtitle.hidden = YES;
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tbl.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string =@"Videos";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    
    
   // UIView *headerView =  [[UIView alloc] init...];
    tbl.tableHeaderView = view;
   // [headerView release];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make oreange cell
   // UITableViewCell *presentCell=(UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
   // [presentCell setBackgroundColor:[UIColor orangeColor]];
    
    //make your previous cellBackgrod to clear, you can make it white as per your requirement
//    if (previousSelectedCellIndexPath!=NULL) {
//        UITableViewCell *previouscell=(UITableViewCell*)[tableView cellForRowAtIndexPath:previousSelectedCellIndexPath];
 //       [previouscell setBackgroundColor:[UIColor clearColor]];
 //   }

    
    //save your selected cell index
    //previousSelectedCellIndexPath=indexPath;
    
    fileName = tableData[indexPath.row];
    
    
    NSString *videoLink = @"http://ubuntu.bulwarkapp.com/techvideo/video/";
    
    videoLink = [videoLink stringByAppendingString:fileName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/video", [paths objectAtIndex:0]];
    NSString *myPathDocs2 =  [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs2])
    {
       // NSString *filepath = [[NSBundle mainBundle] pathForResource:@"vid" ofType:@"mp4"];
        //NSURL *fileURL = [NSURL fileURLWithPath:filepath];
        
        [controller setContentURL:[NSURL URLWithString:myPathDocs2]];
        btnDownload.hidden = YES;
        
        NSURL *mediaURL = [NSURL URLWithString:videoLink]; // Your video's URL
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *track = [tracks objectAtIndex:0];
        //asset.commonMetadata;
        
        
        NSArray *meta =  asset.commonMetadata;
        
       NSLog(@"%@", meta);
        
        
        
    }else{
        
        [controller setContentURL:[NSURL URLWithString:videoLink]];
        btnDownload.hidden = NO;
        
        
    }
    //indexPath.row
    
    //
    
}


- (IBAction)download:(id)sender
{
    NSString *videoLink = @"http://ubuntu.bulwarkapp.com/techvideo/video/";
    
    videoLink = [videoLink stringByAppendingString:fileName];
    
    NSURL *url = [NSURL URLWithString:videoLink];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    connection = nil;
    btnDownload.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.filesize = [NSNumber numberWithUnsignedInteger:[response expectedContentLength]];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)recievedData {
    if (data==nil) {
        data =	[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:recievedData];
    NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[data length]]; //MAGIC
    float progress = [resourceLength floatValue] / [self.filesize floatValue];
    progressView.progress = progress;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    //[connection release];
    connection=nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/video", [paths objectAtIndex:0]];
    NSString *myPathDocs2 =  [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:myPathDocs2 atomically:YES];

    [controller setContentURL:[NSURL URLWithString:myPathDocs2]];
    
    data=nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Something went wrong ...
    NSLog(@" error => %@ ", [error userInfo] );
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
