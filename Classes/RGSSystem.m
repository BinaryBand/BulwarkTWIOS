#import "RGSSystem.h"

@implementation RGSSystem

-(void)createPoints:(UIView *)withView
{
    CGRect screenRect = [withView bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //VERTICAL
    [self setOneTwentiethTop: 1*screenHeight/20];
    [self setTwoTwentiethsTop :2*screenHeight/20];
    [self setThreeTwentiethsTop: 3*screenHeight/20];
    [self setFourTwentiethsTop: 4*screenHeight/20];
    [self setFiveTwentiethsTop: 5*screenHeight/20];
    [self setSixTwentiethsTop: 6*screenHeight/20];
    [self setSevenTwentiethsTop: 7*screenHeight/20];
    [self setEightTwentiethsTop: 8*screenHeight/20];
    [self setNineTwentiethsTop: 9*screenHeight/20];
    [self setTenTwentiethsTop :10*screenHeight/20];
    [self setElevenTwentiethsTop :11*screenHeight/20];
    [self setTwelveTwentiethsTop :12*screenHeight/20];
    [self setThirteenTwentiethsTop: 13*screenHeight/20];
    [self setFourteenTwentiethsTop :14*screenHeight/20];
    [self setFifteenTwentiethsTop: 15*screenHeight/20];
    [self setSixteenTwentiethsTop: 16*screenHeight/20];
    [self setSeventeenTwentiethsTop: 17*screenHeight/20];
    [self setEighteenTwentiethsTop: 18*screenHeight/20];
    [self setNineteenTwentiethsTop: 19*screenHeight/20];
    [self setTwentyTwentiethsTop: 20*screenHeight/20];

    
    //HORIZONTAL
    [self setOneTwentiethLeft:1*screenWidth/20];
    [self setTwoTwentiethsLeft : 2*screenWidth/20];
    [self setThreeTwentiethsLeft : 3*screenWidth/20];
    [self setFourTwentiethsLeft: 4*screenWidth/20];
    [self setFiveTwentiethsLeft : 5*screenWidth/20];
    [self setSixTwentiethsLeft : 6*screenWidth/20];
    [self setSevenTwentiethsLeft : 7*screenWidth/20];
    [self setEightTwentiethsLeft : 8*screenWidth/20];
    [self setNineTwentiethsLeft : 9*screenWidth/20];
    [self setTenTwentiethsLeft :10*screenWidth/20];
    [self setElevenTwentiethsLeft : 11*screenWidth/20];
    [self setTwelveTwentiethsLeft : 12*screenWidth/20];
    [self setThirteenTwentiethsLeft: 13*screenWidth/20];
    [self setFourteenTwentiethsLeft :14*screenWidth/20];
    [self setFifteenTwentiethsLeft: 15*screenWidth/20];
    [self setSixteenTwentiethsLeft: 16*screenWidth/20];
    [self setSeventeenTwentiethsLeft: 17*screenWidth/20];
    [self setEighteenTwentiethsLeft: 18*screenWidth/20];
    [self setNineteenTwentiethsLeft: 19*screenWidth/20];
    [self setTwentyTwentiethsLeft: 20*screenWidth/20];
    
    //CUSTOM
    //E.G. 
    [self setFiftySixPercentLeft:56*screenWidth/100];
    
}


@end
