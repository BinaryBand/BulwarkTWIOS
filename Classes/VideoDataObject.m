//
//  VideoDataObject.m
//  BulwarkTW
//
//  Created by Kole on 2/18/16.
//
//

#import <Foundation/Foundation.h>


#import "VideoDataObject.h"
@implementation VideoDataObject
@synthesize uniqueFileName;
@synthesize description;
@synthesize title;
@synthesize category;

-(id)initWithJSONData:(NSDictionary*)data{
    self = [super init];
    if(self){
        //NSLog(@"initWithJSONData method called");
        self.uniqueFileName = [data objectForKey:@"Unique_File_Name"] ;
        self.title =  [data objectForKey:@"Title"];
        self.description = [data objectForKey:@"Description"];
        self.category = [data objectForKey:@"Category"];
    }
    return self;
}
@end