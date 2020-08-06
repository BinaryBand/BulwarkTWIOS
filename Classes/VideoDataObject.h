//
//  VideoDataObject.h
//  BulwarkTW
//
//  Created by Kole on 2/18/16.
//
//

#import <Foundation/Foundation.h>
@interface VideoDataObject : NSObject

-(id)initWithJSONData:(NSDictionary*)data;

@property (strong) NSString *uniqueFileName;
@property (strong) NSString *title;
@property (strong) NSString *description;
@property (strong) NSString *category;



@end
