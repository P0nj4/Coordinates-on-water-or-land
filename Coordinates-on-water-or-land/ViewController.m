//
//  ViewController.m
//  Coordinates-on-water-or-land
//
//  Created by Germán Pereyra on 16/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)submitPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCoordinates;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}




- (BOOL)isWaterPixel:(UIImage *)image {
    
    
    CGRect sourceRect = CGRectMake(1, 1, 1.f, 1.f);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], sourceRect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    CGFloat r = buffer[0] / 255.f;
    CGFloat g = buffer[1] / 255.f;
    CGFloat b = buffer[2] / 255.f;
    CGFloat a = buffer[3] / 255.f;
    
    free(buffer);
    
    NSString *hexColor = [self getHexStringForColor:[UIColor colorWithRed:r green:g blue:b alpha:a]];
    
    return [@"BBB3FF" isEqualToString:hexColor];
}


- (NSString *)getHexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    NSLog(@"%@" , hexString);
    return hexString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPressed:(id)sender {
    
    //Water
    NSString *coordinates = @"-34.8957311,-56.0555083"; //DEFAULT COORDINATES (for test)
    
    //Street
    //NSString *coordinates = @"-34.8929801,-56.057868";
    
    //Sand
    //NSString *coordinates = @"-34.8931716,-56.0562622";
    
    //More water
    //NSString *coordinates = @"-34.8801446,-56.0908449";
    
    if (self.txtCoordinates.text.length > 0) {
        coordinates = self.txtCoordinates.text;
    }
    
    NSString *googURL =@"";
    
    googURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?scale=2&center=%@", coordinates];
    googURL = [googURL stringByAppendingString:@"&zoom=13&size=1x1&sensor=false&maptype=roadmap&style=feature:water%7Csaturation:100%7Chue:0x2200ff"];
    
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString:googURL]]];
    
    NSLog(@"%@", googURL);
    
    if([self isWaterPixel:myImage]){
        NSLog(@"ES AGUA");
        [[[UIAlertView alloc] initWithTitle:nil message:@"IS WATER" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else{
        NSLog(@"ES TIERRA");
        [[[UIAlertView alloc] initWithTitle:nil message:@"IS LAND" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}
@end
