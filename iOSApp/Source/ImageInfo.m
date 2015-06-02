//
//  ImageInfo.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//
#import "cl_DataManager.h"
#import "ImageInfo.h"

#import <dispatch/dispatch.h>
//#import <QuartzCore/QuartzCore.h>
#ifdef USE_CHECK_DUPLICATE_DOWNLOAD_NAME
static NSMutableArray* m_arrayImageNameCached = nil;
#endif
@interface ImageInfo()
{
    NSString* m_sImageType;
}
@end
@implementation ImageInfo

@synthesize sourceURL;
@synthesize imageName;
@synthesize image;
@synthesize iRowIndex,pOwner,imageType = m_sImageType;
#ifdef USE_CHECK_DUPLICATE_DOWNLOAD_NAME
+(NSMutableArray *)arrayDownloadedImageName
{
    if (m_arrayImageNameCached == nil) {
        m_arrayImageNameCached = [[NSMutableArray alloc] init];
    }
    return m_arrayImageNameCached;
}
#endif
-(NSString*)getImageNameWithoutExtension:(NSString*)fileName
{
    return [[fileName stringByDeletingPathExtension] lastPathComponent];
}
-(NSString *)imageNameWithoutExtension
{
    return [self getImageNameWithoutExtension:imageName];
}
-(void)saveImage:(UIImage*)cacheImage
{
    [self saveImage:cacheImage WithName:[self getImageNameWithoutExtension:imageName]];
}
-(void)saveImage:(UIImage*)cacheImage WithName:(NSString*)sImageName
{
    //UIImage* originImage = [self screenshot];
    //UIImage* savedImage = [UIImage imageWithCGImage:[originImage CGImage] scale:1 orientation:UIImageOrientationRight];
    
    NSData *pngData = ([m_sImageType isEqualToString:@"jpg"])?UIImageJPEGRepresentation(cacheImage, 0.5):UIImagePNGRepresentation(cacheImage);//(cacheImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",sImageName,m_sImageType]]; //Add the file name
    
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_FINISH_DOWNLOAD object:self];
}
- (void)finishDownloadingImage:(ASIHTTPRequest*)request
{
    NSData *data = [request responseData];
    if (!CGSizeEqualToSize(m_destinationSize,CGSizeZero)) {
        image = [ImageInfo resizeImage:[[UIImage alloc] initWithData:data] newSize:m_destinationSize];
    }
    else
    {
        image = [UIImage imageWithData:data];
    }
    dispatch_async([[cl_DataManager shareInstance] BackgroundQueue], ^(void)
                   {
                       [self saveImage:image];
                       
                   });
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_FINISH_DOWNLOAD object:self];
}
- (void)getImage {
    
    //NSLog(@"Getting %@...", sourceURL);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setDidFinishSelector:@selector(finishDownloadingImage:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (id)initWithSourceURL:(NSURL *)URL {
    if ((self = [super init])) {
        
        m_sImageType = @"png";
        
        m_destinationSize = CGSizeZero;
        sourceURL = URL;
        imageName = [URL lastPathComponent];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self getImageNameWithoutExtension:imageName],m_sImageType]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])//check image exist
        {
            image = [UIImage imageWithContentsOfFile:filePath];
        }
        else
        {
#ifdef USE_CHECK_DUPLICATE_DOWNLOAD_NAME
            if ([self isAlreadyExistInCache:filePath]) {
                imageName = [NSString stringWithFormat:@"%@%i",[self getImageNameWithoutExtension:imageName],[[ImageInfo arrayDownloadedImageName] count]];
                filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName],m_sImageType];
                if ([[ImageInfo arrayDownloadedImageName] count]>20) {
                    [[ImageInfo arrayDownloadedImageName] removeAllObjects];
                }
            }
            [[ImageInfo arrayDownloadedImageName] addObject:filePath];
#endif
            [self getImage];
        }
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i {
    if ((self = [super init])) {
        
        m_sImageType = @"png";
        
        sourceURL = URL;
        imageName = name;
        image = i;
    }
    return self;
}
- (id)initWithSourceURL:(NSURL *)URL AndRowIndex:(int)iIndex
{
    if(self=[self initWithSourceURL:URL])
    {
        iRowIndex = iIndex;
    }
    return self;
}
-(id)initWithSourceURL:(NSURL *)URL AndOwner:(id)theOwner AndSize:(CGSize)newSize
{
    if (self = [self initWithSourceURL:URL AndOwner:theOwner]) {
        m_destinationSize = newSize;
    }
    return self;
}
-(id)initWithSourceURL:(NSURL *)URL AndOwner:(id)theOwner
{
    if(self=[self initWithSourceURL:URL])
    {
        pOwner = theOwner;
    }
    return self;
}
#ifdef USE_CHECK_DUPLICATE_DOWNLOAD_NAME
-(BOOL)isAlreadyExistInCache:(NSString*)theImageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getImageNameWithoutExtension:theImageName]]];
    
    NSArray* arr = [ImageInfo arrayDownloadedImageName];
    int iCount = arr.count;
    for (int i=0; i<iCount; i++) {
        if([filePath isEqualToString:[arr objectAtIndex:i]])
        {
            return TRUE;
        }
    }
    return FALSE;
}
#endif
+ (UIImage *)resizeImage:(UIImage*)pImage newSize:(CGSize)newSize
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = pImage.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect {
    NSParameterAssert(image != nil);
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, image.size)) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    [image drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

- (UIImage *)convertImageToGrayScale:(UIImage *)pImage
{
    //Fix CGContextfillRect invalid context => crash
    if (pImage == nil) {
        return pImage;
    }
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, pImage.size.width, pImage.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, pImage.size.width, pImage.size.height, 8, 0, colorSpace, kCGImageAlphaNone);//kCGImageAlphaNone
    
    
    //Fill background
    CGContextSetRGBFillColor(context, 14/255.0, 21/255.0, 32/255.00, 1);
    CGContextFillRect(context, imageRect);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [pImage CGImage]);
    
    
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
/*
- (UIImage *)convertImageToGrayScale:(UIImage *)pImage
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, pImage.size.width, pImage.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, pImage.size.width, pImage.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [pImage CGImage]);
    
    // changes start here
    // Create bitmap image info from pixel data in current context
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    
    // release the colorspace and graphics context
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    // make a new alpha-only graphics context
    context = CGBitmapContextCreate(nil, pImage.size.width, pImage.size.height, 8, 0, nil, kCGImageAlphaOnly);
    
    // draw image into context with no colorspace
    CGContextDrawImage(context, imageRect, [pImage CGImage]);
    
    // create alpha bitmap mask from current context
    CGImageRef mask = CGBitmapContextCreateImage(context);
    
    // release graphics context
    CGContextRelease(context);
    
    // make UIImage from grayscale image with alpha mask
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:pImage.scale orientation:pImage.imageOrientation];
    
    // release the CG images
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    
    // return the new grayscale image
    return grayScaleImage;
    
    //--> changes end here
}
*/
-(UIImage*)convertImageToGreyscale
{
    UIImage* newImage = [self convertImageToGrayScale:image];
    NSString* ss =[NSString stringWithFormat:@"%@_gray",[self imageNameWithoutExtension]];
    [self saveImage:newImage WithName:ss];
    return newImage;
}
-(UIImage *)imageGrayscale
{
    UIImage* imageGray;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_gray.%@",[self getImageNameWithoutExtension:imageName],m_sImageType]];
//    NSLog(@"%@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])//check image exist
    {
        imageGray = [UIImage imageWithContentsOfFile:filePath];
    }
    else
    {
        imageGray = [self convertImageToGreyscale];
//        NSLog(@"get image gray scale");
    }
    return imageGray;
}
@end
