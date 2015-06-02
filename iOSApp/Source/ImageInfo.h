//
//  ImageInfo.h
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#define NOTIFY_IMAGE_FINISH_DOWNLOAD    @"com.ocean4.image.finish.download"
@interface ImageInfo : NSObject <ASIHTTPRequestDelegate>{
    CGSize m_destinationSize;
    
}
@property (retain) NSURL * sourceURL;
@property (nonatomic,strong) NSString * imageName;
@property (nonatomic,readwrite) int iRowIndex;
@property (nonatomic,readwrite,strong) id pOwner;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic,strong) NSString* imageType;
#ifdef USE_CHECK_DUPLICATE_DOWNLOAD_NAME
+(NSMutableArray*)arrayDownloadedImageName;
#endif
- (id)initWithSourceURL:(NSURL *)URL;
- (id)initWithSourceURL:(NSURL *)URL AndRowIndex:(int)iIndex;
- (id)initWithSourceURL:(NSURL *)URL AndOwner:(id)pOwner;
- (id)initWithSourceURL:(NSURL *)URL AndOwner:(id)pOwner AndSize:(CGSize)newSize;
- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i;
+ (UIImage *)resizeImage:(UIImage*)pImage newSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect;
-(UIImage*)convertImageToGreyscale;
-(UIImage*)imageGrayscale;
@end
