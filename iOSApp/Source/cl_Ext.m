//
//  cl_UIViewController.m
//  KRLANGAPP
//
//  Created by Vu Hoang Son on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cl_Ext.h"
#import "cl_DataStructure.h"
#import "cl_DataManager.h"
#import "ImageInfo.h"
#import "cl_GameViewController.h"
#import "cl_SettingViewController.h"
#import "cl_OrganizationDetailViewController.h"
#import "cl_AppManager.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - cl_UIViewController
@implementation cl_UIViewController
-(void)refreshScreen
{
    
}
-(void)firstInit
{
    
}
-(void)closeScreen
{
    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
#pragma mark - cl_UILabel
@implementation cl_UILabel
-(void)setText:(id)text HiglightWord:(NSArray*)hlWords HighlightColor:(UIColor*)color
{    
    m_pHighlightColor = color;
    m_pHighlightWords = hlWords;
    //[self setText:text];
    [super setText:text];
}

-(void)drawRect:(CGRect)rect
{
    // create a font, quasi systemFontWithSize:24.0
    CTFontRef sysUIFont = CTFontCreateWithName(CFSTR("Arial"), self.font.pointSize, NULL);
    
    
	// pack it into attributes dictionary
	NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)sysUIFont, (id)kCTFontAttributeName,
                                    nil];
	// make the attributed string
    if (!self.text) {
        return;
    }
    NSAttributedString* stringBase = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDict];    
	NSMutableAttributedString *stringToDraw = [[NSMutableAttributedString alloc] initWithAttributedString:stringBase];
    
    [stringToDraw addAttribute:(id)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, self.text.length)];
    
    if (m_pHighlightWords) 
    {
        for (NSString* word in m_pHighlightWords) 
        {
            NSRange range = [self.text rangeOfString:word];
            [stringToDraw addAttribute:(id)kCTForegroundColorAttributeName value:(id)m_pHighlightColor.CGColor range:range];
        }
    }
    
    // layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (__bridge CFAttributedStringRef)stringToDraw);
    
	// left column form
	CGMutablePathRef leftColumnPath = CGPathCreateMutable();
	CGPathAddRect(leftColumnPath, NULL, 
                  CGRectMake(0, -5, 
                             self.bounds.size.width,
                             self.bounds.size.height));
    
	// left column frame
	CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, 
                                                    CFRangeMake(0, 0),
                                                    leftColumnPath, NULL);
    
	// flip the coordinate system
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	// draw
	CTFrameDraw(leftFrame, context);
	//CTFrameDraw(rightFrame, context);

    
	// clean up
	CFRelease(leftFrame);    
    CGPathRelease(leftColumnPath);
    //CFRelease(rightFrame);
	//CGPathRelease(rightColumnPath);
    CFRelease(framesetter);
	CFRelease(sysUIFont);
	//[stringToDraw release];
}


/*- (void)drawRect:(CGRect)rect
{
	NSString *longText = self.text;//@"Loremipsumdolorsiterelitlamet,consectetaurcilliumadipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                         initWithString:longText];
    
	// make a few words bold
	CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), 16.0, NULL);
	CTFontRef helveticaBold = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 14.0, NULL);
    
	[string addAttribute:(id)kCTFontAttributeName
                   value:(__bridge id)helvetica
                   range:NSMakeRange(0, [string length])];
    
	// layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (__bridge CFAttributedStringRef)string);
    
	// left column form
	CGMutablePathRef leftColumnPath = CGPathCreateMutable();
	CGPathAddRect(leftColumnPath, NULL, 
                  CGRectMake(0, 0, 
                             self.bounds.size.width/2.0,
                             self.bounds.size.height));
    
	// left column frame
	CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, 
                                                    CFRangeMake(0, 0),
                                                    leftColumnPath, NULL);
    
	// right column form
	CGMutablePathRef rightColumnPath = CGPathCreateMutable();
	CGPathAddRect(rightColumnPath, NULL, 
                  CGRectMake(self.bounds.size.width/2.0, 0, 
                             self.bounds.size.width/2.0,
                             self.bounds.size.height));
    
	NSInteger rightColumStart = CTFrameGetVisibleStringRange(leftFrame).length;
    
	// right column frame
	CTFrameRef rightFrame = CTFramesetterCreateFrame(framesetter,
                                                     CFRangeMake(rightColumStart, 0),
                                                     rightColumnPath,
                                                     NULL);
    
	// flip the coordinate system
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	// draw
	CTFrameDraw(leftFrame, context);
	//CTFrameDraw(rightFrame, context);
    
	// cleanup
	CFRelease(leftFrame);
	CGPathRelease(leftColumnPath);
	CFRelease(rightFrame);
	CGPathRelease(rightColumnPath);
	CFRelease(framesetter);
	CFRelease(helvetica);
	CFRelease(helveticaBold);
	//[string release];
}*/

@end
#pragma mark - cl_UIToggleBar
#define TOGGLE_COLOR_1  [UIColor colorWithRed:176/255.0 green:232/255.0 blue:255/255.0 alpha:0.0]
#define TOGGLE_COLOR_2  [UIColor colorWithRed:176/255.0 green:232/255.0 blue:255/255.0 alpha:0.3]
@implementation cl_UIToggleBar
@synthesize SelectedButtonIndex,delegate;
-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
}
-(void)refreshAfterDidLoad
{
    SelectedButtonIndex = -1;
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)view;
            button.backgroundColor = TOGGLE_COLOR_1;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if(SelectedButtonIndex==-1)SelectedButtonIndex = button.tag;
        }
    }
    UIButton* currentButton = (UIButton*)[self viewWithTag:SelectedButtonIndex];
    [currentButton setEnabled:FALSE];
    currentButton.backgroundColor = TOGGLE_COLOR_2;
}
-(void)onClick:(id)sender
{
    UIButton* obj = (UIButton*)sender;
    if (obj.tag!=SelectedButtonIndex) 
    {
        [obj setEnabled:FALSE];
        obj.backgroundColor = TOGGLE_COLOR_2;
        UIButton* oldButton = (UIButton*)[self viewWithTag:SelectedButtonIndex];
        [oldButton setEnabled:TRUE];
        oldButton.backgroundColor = TOGGLE_COLOR_1;
        SelectedButtonIndex = obj.tag;
         
    }
    if (delegate) {
        
        [delegate onClick:sender];
    }
}
@end
#pragma mark - cl_UIPageControl
@implementation cl_UIPageControl
@synthesize pageIndicator = m_pageIndicator;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        m_pageIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pageIndicator"]];
        m_pageIndicator.frame = CGRectMake(0, 0, 36, 11);
        m_pageIndicator.tag = 999;
        [self addSubview:m_pageIndicator];
        
        
    }
    return self;
}
-(void)updateCurrentPageDisplay
{
    [super updateCurrentPageDisplay];
    m_iIndicatorIndex = [self.subviews indexOfObject:m_pageIndicator];
    m_pageIndicatorY = -1;
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* view = [self.subviews objectAtIndex:i];
//        NSLog(@"before-page(%i)=%f-%f - %@ tag=%i--current=%i--indi=%i",i,view.frame.origin.x,view.frame.origin.y,NSStringFromClass([view class]),view.tag,self.currentPage,m_iIndicatorIndex);
        if (i == self.currentPage)
        {
            if (i>=m_iIndicatorIndex) {
                view = [self.subviews objectAtIndex:i+1];
//                    NSLog(@"after-page(%i)=%f-%f - %@ tag=%i--current=%i",i+1,view.frame.origin.x,view.frame.origin.y,NSStringFromClass([view class]),view.tag,self.currentPage);
            }
            CGRect rect = m_pageIndicator.frame;
            m_pageIndicatorY = view.frame.origin.y-(rect.size.height)-6;
            
            rect.origin = CGPointMake(view.frame.origin.x+(view.frame.size.width-rect.size.width)*0.5, m_pageIndicatorY);
            m_pageIndicator.frame = rect;
            
            
            break;
        }
    }
}
-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    if (self.numberOfPages>0) {
        m_pageIndicator.hidden = FALSE;
        [self updateCurrentPageDisplay];
    }
    else
    {
        m_pageIndicator.hidden = TRUE;
    }
}
@end
#pragma mark - Star Rating Control
@implementation cl_StarRating
@synthesize ProgressValue = m_fProgressValue;
-(id)initWithImage:(UIImage*)imageProgress andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        m_pImageSource = imageProgress;
        m_fProgressValue = 0;
        m_rectImageSize.size.width = CGImageGetWidth(m_pImageSource.CGImage);
        m_rectImageSize.size.height = CGImageGetHeight(m_pImageSource.CGImage);
    }
    return self;
}
-(void)setImage:(UIImage*)imageProgress andFrame:(CGRect)frame
{
    self.frame = frame;
    m_pImageSource = imageProgress;
    m_fProgressValue = 0;
    m_rectImageSize.size.width = CGImageGetWidth(m_pImageSource.CGImage);
    m_rectImageSize.size.height = CGImageGetHeight(m_pImageSource.CGImage);
}
-(void)setProgess:(float)value
{
    m_fProgressValue = (value>5)?5:value;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    CGRect imageDrawRegion = CGRectMake(0, 0, (m_fProgressValue*m_rectImageSize.size.width)/5.f, m_rectImageSize.size.height);
    CGImageRef image = CGImageCreateWithImageInRect(m_pImageSource.CGImage, imageDrawRegion);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    CGRect drawRect = imageDrawRegion;
    drawRect.size.width *= 0.5f;
    drawRect.size.height *= 0.5f;
    CGContextDrawImage(context, drawRect, image);
}
@end
#pragma mark - cl_UIBaseCell
@implementation cl_UIBaseCell

@synthesize SelectedImage = m_pSelectedBG;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        m_pSelectedBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG_selection.png"]];
        [m_pSelectedBG setFrame:CGRectMake(0, 0, 320, 39)];
        m_pSelectedBG.hidden = YES;
        [self addSubview:m_pSelectedBG];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end

#pragma mark - cl_CellStyle1

@interface cl_CellStyle1()
-(IBAction)buttonDisclosure;
-(void)buttonMore;
@end
@implementation cl_CellStyle1
@synthesize delegate,LablePrice = m_labelPrice;
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        UIView* cell_border = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 312, 124)];
//        [self addSubview:cell_border];
//        
//        UIImageView* cell_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_box.png"]];
//        [cell_bg setFrame:CGRectMake(0, 0, 312, 124)];
//        [cell_border addSubview:cell_bg];
//        
//        m_pMainImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_photo.png"]];
//        [m_pMainImage setFrame:CGRectMake(6, 6, 145, 112)];
//        [m_pMainImage setBackgroundColor:[UIColor whiteColor]];
//        [cell_border addSubview:m_pMainImage];
//    
//        
//        CGRect rectToAlign = m_pMainImage.frame;
//        
//        m_labelPartnerName = [[UILabel alloc] initWithFrame:CGRectMake(rectToAlign.origin.x+rectToAlign.size.width+5, 8, self.frame.size.width-rectToAlign.size.width-4, 18)];
//        m_labelPartnerName.backgroundColor = [UIColor clearColor];
//        m_labelPartnerName.textColor = [UIColor whiteColor];
//        [m_labelPartnerName setFont:FONT_GOTHAM_1];
//        [cell_border addSubview:m_labelPartnerName];
//        
//        m_pHeartImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_full.png"]];
//        m_pHeartImage.frame = CGRectMake(m_labelPartnerName.frame.origin.x, m_labelPartnerName.frame.origin.y+m_labelPartnerName.frame.size.height+8, 10, 10);
//        [cell_border addSubview:m_pHeartImage];
//        
//        m_labelReviews = [[UILabel alloc] initWithFrame:CGRectMake(m_pHeartImage.frame.origin.x+m_pHeartImage.frame.size.width+5, m_pHeartImage.frame.origin.y-3, 50, 18)];
//        m_labelReviews.backgroundColor = [UIColor clearColor];
//        [m_labelReviews setFont:[UIFont systemFontOfSize:14.f]];
//        m_labelReviews.textColor = [UIColor whiteColor];
//        [cell_border addSubview:m_labelReviews];
//        
//        UIImageView* imagePointBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"points_btn.png"]];
//        imagePointBg.frame = CGRectMake(rectToAlign.origin.x+rectToAlign.size.width, cell_border.frame.size.height - 35, 77, 35);
//        [cell_border addSubview:imagePointBg];
//        
//        m_labelPoints = [[UILabel alloc] initWithFrame:CGRectMake(imagePointBg.frame.origin.x+5, imagePointBg.frame.origin.y +10, 120, 18)];
//        m_labelPoints.backgroundColor = [UIColor clearColor];
//        [m_labelPoints setFont:FONT_GOTHAM_1];
//        m_labelPoints.textColor = [UIColor whiteColor];
//        [cell_border addSubview:m_labelPoints];
//        
//        m_buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
//        m_buttonMore.frame = CGRectMake(imagePointBg.frame.origin.x+imagePointBg.frame.size.width, imagePointBg.frame.origin.y, 77, 35);
//        [m_buttonMore setImage:[UIImage imageNamed:@"more_btn.png"] forState:UIControlStateNormal];
//        [cell_border addSubview:m_buttonMore];
//
//        m_buttonDisclosure = [UIButton buttonWithType:UIButtonTypeCustom];
//        m_buttonDisclosure.frame = CGRectMake(cell_border.frame.size.width-53, (cell_border.frame.size.height-50)*0.5, 50, 50);
//        [m_buttonDisclosure addTarget:self action:@selector(buttonDisclosure) forControlEvents:UIControlEventTouchUpInside];
//        [m_buttonDisclosure setImage:[UIImage imageNamed:@"arrows_active.png"] forState:UIControlStateNormal];
//        [cell_border addSubview:m_buttonDisclosure];
//    }
//    return self;
//}

-(void)awakeFromNib
{
    [m_labelPartnerName setFont:FONT_GOTHAM_1];
    [m_labelPoints setFont:FONT_GOTHAM_1];
    [m_starReview setImage:[UIImage imageNamed:@"progress_star.png"] andFrame:m_starReview.frame];
}
-(void)updateDataWithObject:(id)objectData
{
    if (!objectData) {
        [m_labelPartnerName setText:@"Unknow Name"];
        [m_labelPoints setText:@"+0"];
        [m_labelReviews setText:@"no review"];
    }
    cl_PartnerObject* partner = (cl_PartnerObject*)objectData;
    if (partner.pImageInfo.image) {
        [m_pMainImage setImage:partner.pImageInfo.image];
    }
    else
        [m_pMainImage setImage:[UIImage imageNamed:partner.sThumbnailPhoto]];
    [m_labelPartnerName setText:partner.sName];
    [m_labelPoints setText:[NSString stringWithFormat:@"%.02f mile",partner.fDistance]];
    if (partner.iDataSourceType == DATA_SOURCE_TYPE_FOURSQUARE)
    {
        [m_labelReviews setText:[NSString stringWithFormat:@"%i",partner.iReview]];
        m_starReview.hidden = TRUE;
        m_pHeartImage.hidden = !m_starReview.hidden;
        m_labelReviews.hidden = !m_starReview.hidden;
    }
    else
    {
        [m_starReview setProgess:partner.iReview];
        m_starReview.hidden = FALSE;
        m_pHeartImage.hidden = !m_starReview.hidden;
        m_labelReviews.hidden = !m_starReview.hidden;
    }
    CGSize newSize = [partner.sName sizeWithFont:m_labelPartnerName.font constrainedToSize:CGSizeMake(self.frame.size.width-m_pMainImage.frame.size.width-2, 999)];
    [m_labelPartnerName setLineBreakMode:NSLineBreakByWordWrapping];
    m_labelPartnerName.numberOfLines = 0;
    m_labelPartnerName.frame = CGRectMake(m_labelPartnerName.frame.origin.x, m_labelPartnerName.frame.origin.y, newSize.width, newSize.height);
    if (partner.iDataSourceType == DATA_SOURCE_TYPE_FOURSQUARE)
    {
        m_pHeartImage.frame = CGRectMake(m_pHeartImage.frame.origin.x, m_labelPartnerName.frame.origin.y+m_labelPartnerName.frame.size.height+5,m_pHeartImage.frame.size.width , m_pHeartImage.frame.size.height);
        m_labelReviews.frame = CGRectMake(m_pHeartImage.frame.origin.x+m_pHeartImage.frame.size.width+5, m_pHeartImage.frame.origin.y-5, m_labelReviews.frame.size.width, m_labelReviews.frame.size.height);
    }
    else
        m_starReview.frame = CGRectMake(m_starReview.frame.origin.x,m_labelPartnerName.frame.origin.y+m_labelPartnerName.frame.size.height+5,m_starReview.frame.size.width,m_starReview.frame.size.height);
    [m_labelPrice setText:[NSString stringWithFormat:@"$%.02f\nAvg/night",partner.pAverageNighlyRate.value]];
}
-(void)buttonDisclosure
{
    if (delegate) {
        [delegate disclosureButtonOnClick:self];
    }
}
-(void)buttonMore
{
    if(delegate)
    {
        [delegate moreButtonOnClick:self];
    }
}
@end

@implementation cl_CellStyle2
@synthesize labelPartnerName=m_labelPartnerName,labelPoint=m_labelPoints,imageThumnail=m_pMainImage;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib
{
    [m_labelPartnerName setFont:FONT_GOTHAM_1];
    [m_labelPoints setFont:FONT_GOTHAM_1];
}
-(void)updateDataWithObject:(id)objectData
{
    if (!objectData) {
        [m_labelPartnerName setText:@"Unknow Name"];
        [m_labelPoints setText:@"+0"];
    }
    cl_QuestObject* partner = (cl_QuestObject*)objectData;
    if (partner.pImageInfo.image) {
        [m_pMainImage setImage:partner.pImageInfo.image];
    }
    
    [m_labelPartnerName setText:[partner.sName uppercaseString]];
    [m_labelPoints setText:[NSString stringWithFormat:@"+%i pts",partner.iPoint]];
}
@end

@implementation cl_CellStyle3
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_labelTaskName = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 150, 20)];
        [m_labelTaskName setFont:[UIFont boldSystemFontOfSize:12.f]];
        [self addSubview:m_labelTaskName];
        
        CGRect rect = m_labelTaskName.frame;
        rect.size.width = 280;
        rect.origin.y = rect.origin.y + rect.size.height+3;
        m_labelContent = [[UILabel alloc] initWithFrame:rect];
        [m_labelContent setFont:[UIFont systemFontOfSize:11.f]];
        [m_labelContent setLineBreakMode:NSLineBreakByWordWrapping];
        m_labelContent.numberOfLines = 0;
        [self addSubview:m_labelContent];
        
        rect = m_labelTaskName.frame;
        rect.size.width = 100;
        rect.origin.x = self.frame.size.width - rect.size.width - 8;
        m_labelPoint = [[UILabel alloc] initWithFrame:rect];
        [m_labelPoint setFont:[UIFont boldSystemFontOfSize:12.f]];
        [self addSubview:m_labelPoint];
    }
    return self;
}
-(void)updateDataWithObject:(id)objectData
{
    cl_TaskObject* pReview = (cl_TaskObject*)objectData;
    [m_labelTaskName setText:pReview.sName];
    [m_labelPoint setText:[NSString stringWithFormat:@"%i pts",pReview.iPoint]];
    
    CGSize newSize = [pReview.sDetail sizeWithFont:m_labelContent.font constrainedToSize:CGSizeMake(m_labelContent.frame.size.width, 999)];
    CGRect rect = m_labelContent.frame;
    rect.size = newSize;
    m_labelContent.frame = rect;
    [m_labelContent setText:pReview.sDetail];
}
@end
@implementation cl_CellStyle4
@synthesize CoinButton = m_CoinButton,HeroAvatar = m_HeroAvatar,HeroName = m_HeroName;
-(void)updateDataWithObject:(id)objectData
{
    cl_UserInfo* userInfo = (cl_UserInfo*)objectData;
    m_HeroName.text = [userInfo.sHeroName isEqualToString:@""]?[[userInfo.facebookInfo objectForKey:@"username" ] uppercaseString]:[userInfo.sHeroName uppercaseString];
    [m_CoinButton setTitle:[NSString stringWithFormat:@"%i",userInfo.iPoint] forState:UIControlStateNormal];
}

@end

@implementation cl_CellStyle5
@synthesize CoinButton = m_CoinButton;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self.textLabel setTextColor:[UIColor whiteColor]];
//        [self.textLabel setFont:FONT_GOTHAM_2];
    }
    return self;
}
-(void)updateDataWithObject:(id)objectData
{
    cl_QuestObject* quest =(cl_QuestObject*)objectData;
    self.textLabel.text = quest.sName;
    [m_CoinButton setTitle:[NSString stringWithFormat:@"%i",quest.iPoint] forState:UIControlStateNormal];
}

@end
#pragma mark - Virtual Quest
@implementation cl_CellPacket
@synthesize delegate;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
//        [self.textLabel setTextColor:[UIColor whiteColor]];
        //        [self.textLabel setFont:FONT_GOTHAM_2];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishDownloadImage:) name:NOTIFY_FINISH_LOADING_IMAGE object:nil];
        m_bInitQuest = FALSE;
        m_arrayQuest = [[NSMutableArray alloc] init];
        
    }
    return self;
}
//-(void)updateFinishDownloadImage:(NSNotification*)notif
//{
//    ImageInfo* imgInfo = (ImageInfo*)notif.object;
//    if (imgInfo.pOwner!=self) {
//        return;
//    }
//    packetImageView.image = imgInfo.image;
//}
-(void)updateWithUserData:(id)userData
{
    
    NSArray* arrayUnlockQuest = (NSArray*)userData;

//    for (UIView* view in self.subviews) {
//        NSLog(@"%@",NSStringFromClass([view class]));
//    }
    UIView* view = [self.subviews objectAtIndex:0];
//    NSLog(@"===========%i===============%f",[view.subviews count],[[[UIDevice currentDevice] systemVersion] floatValue]);
    
    NSArray* subViewArray;
    if ([view.subviews count]>2)//IOS 6
//    if([[[UIDevice currentDevice] systemVersion] floatValue]<=6)
    {
        subViewArray = [view subviews];
    }
    else//IOS 7
    {
        for (UIView* obj in view.subviews) {
            if (obj.subviews.count>0) {
                subViewArray = obj.subviews;
                break;
            }
        }
//        subViewArray = [[view.subviews objectAtIndex:0] subviews];
    }
    int iCount = arrayUnlockQuest.count;
    for (UIView* view in subViewArray) {
        if ([view isKindOfClass:[cl_CellQuestView class]]) {
            cl_CellQuestView* questView = (cl_CellQuestView*)view;
//            for (cl_VirtualQuest* quest in arrayUnlockQuest)
            for(int i=0;i<iCount;i++)
            {
                cl_VirtualQuest* quest = [arrayUnlockQuest objectAtIndex:i];
                
                int iID = [questView.labelQuestId.text intValue];

                if (iID == quest.virtualQuestId )
                {
                    if(quest.virtualQuestIsUnlocked)
                        [questView unlockQuest];
                    break;
                }
                else
                {
                    [questView lockQuest];
//                    NSLog(@"lock quest = %i-%i",iID,quest.virtualQuestId);

                }
            }
        }
    }
    
    

    
}
-(void)updateDataWithObject:(id)objectData
{
    packetTitleLabel.layer.cornerRadius = 5.f;
    packetTitleLabel.layer.masksToBounds = TRUE;
    [packetTitleLabel setFont:FONT_GOTHAM_3];
    cl_Packet* packet = (cl_Packet*)objectData;
//    packetImageView.image = packet.packetImage.image;
    packetTitleLabel.text = packet.packetTitle;
    if (!m_bInitQuest)/* Init quest view the first time */
    {
        int iCount = 3;//packet.packetQuests.count;
        for (int i=0;i<iCount;i++)
        {
            cl_CellQuestView* pQuestView = [[[NSBundle mainBundle] loadNibNamed:@"nibCustomView" owner:self options:nil] objectAtIndex:1];
            pQuestView.delegate = self;
            
            [self.contentView addSubview:pQuestView];
            [m_arrayQuest addObject:pQuestView];
            pQuestView.frame = CGRectMake(i*(pQuestView.frame.size.width+1), packetTitleLabel.frame.origin.y+packetTitleLabel.frame.size.height, pQuestView.frame.size.width, pQuestView.frame.size.height);
        }
        m_bInitQuest = TRUE;
    }
    
    int iTrackingId = 0;
    int iCount = packet.packetQuests.count;
    for (int i=0; i<iCount; i++) {
        iTrackingId++;
        cl_VirtualQuest* quest = [packet.packetQuests objectAtIndex:i];
//        cl_CellQuestView* pQuestView = [m_arrayQuest objectAtIndex:i];
        if (i>=m_arrayQuest.count) {
            continue;
        }
        
        cl_CellQuestView* pQuestView = [m_arrayQuest objectAtIndex:i];
        pQuestView.hidden = false;
//        [pQuestView lockQuest:quest];
        pQuestView.labelQuestId.text = [NSString stringWithFormat:@"%i",quest.virtualQuestId];
        pQuestView.labelQuestTitle.text = [NSString stringWithFormat:@"%@",quest.virtualQuestName];
        pQuestView.questData = quest;
        if (!quest.virtualQuestImage.image) {
            quest.virtualQuestImage = [[ImageInfo alloc] initWithSourceURL:[NSURL URLWithString:quest.virtualQuestImageURL] AndOwner:pQuestView];
        }
        else
        {
            pQuestView.imageQuest.image = quest.virtualQuestImage.image;
        }

    }
    
    if (iTrackingId<3) {
        for (int i=iTrackingId; i<3; i++) {
            cl_CellQuestView* pQuestView = [m_arrayQuest objectAtIndex:i];
            pQuestView.hidden = true;
        }
    }
}
-(void)cellQuestViewOnClick:(id)sender
{
    if (delegate) {
        [delegate cellPacketOnClick:sender];
    }
}
@end

@implementation cl_CellQuestView
@synthesize labelActivity = m_labelActivity,labelCoin = m_labelCoin, labelDonation = m_labelDonation,labelQuestId = m_labelQuestId, labelQuestTitle = m_labelQuestTitle;
@synthesize viewLock = m_lockView,delegate,isLock = m_bIsLock,imageQuest = m_imageQuest,questData;
-(id)init
{
    if (self = [super init]) {
        m_bIsLock = FALSE;
    }
    return self;
}
-(void)unlockQuest
{
//    [self sendSubviewToBack:m_lockView];
//    m_lockView.hidden = TRUE;
//    m_labelQuestTitle.hidden = FALSE;
    m_bIsLock = FALSE;
//    m_imageQuest.alpha = 1;
    m_imageQuest.image = questData.virtualQuestImage.image;
    m_imageQuest.layer.cornerRadius = 34.5f;
    m_imageQuest.layer.masksToBounds = YES;
    
//    NSLog(@"status: %i", );
    if ([[[[cl_DataManager shareInstance] ArrayQuestStatus] objectAtIndex:questData.virtualQuestId - 1] virtualQuestStatus] == 1) {
        [m_CompetedQuestImageView setBackgroundColor:[UIColor colorWithRed:0.169f green:0.78f blue:0.409f alpha:1.0f]];
    }else{
        [m_CompetedQuestImageView setBackgroundColor:[UIColor clearColor]];
    }
    m_CompetedQuestImageView.layer.cornerRadius = 35.0f;
    m_CompetedQuestImageView.layer.masksToBounds = YES;
    
}
-(void)lockQuest
{
//    [self bringSubviewToFront:m_lockView];
//    m_lockView.hidden = FALSE;
//    m_labelQuestTitle.hidden = TRUE;
    m_bIsLock = TRUE;
//    m_imageQuest.alpha = 0.5f;
//    m_imageQuest.image = [UIImage imageNamed:@"quest_lock.png"];
    m_imageQuest.image = questData.virtualQuestImage.imageGrayscale;
    m_imageQuest.layer.cornerRadius = 34.5f;
    m_imageQuest.layer.masksToBounds = YES;
    
    [m_CompetedQuestImageView setBackgroundColor:[UIColor clearColor]];
    m_CompetedQuestImageView.layer.cornerRadius = 35.0f;
    m_CompetedQuestImageView.layer.masksToBounds = YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_bIsLock) {
        return;
    }
//    NSLog(@"you touch on %i",self.tag - TAG_QUEST_UIVIEW);
    if (delegate) {
        [delegate cellQuestViewOnClick:self];
    }
}
@end

#pragma mark - implement cl_CellProfile
@implementation cl_CellProfile
-(void)cellProfileOnClick:(id)sender{
    
}
-(void)setProfileTitle:(NSString *)title {
    [profileTitleLabel setFont:FONT_GOTHAM_3];
    profileTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    profileTitleLabel.text = title;
}
-(void)setProfileImage:(NSString *)imageName {
    [backgroundImageView setImage:[UIImage imageNamed:@"wide_empty_icon.png"]];
    
    UIImage *image = [UIImage imageNamed:imageName];
    [profileImageView setImage:image];
    
}
-(void)setPlayerAvatar {
    NSDictionary* fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
    
    profilePictureView.layer.cornerRadius = 18.f;
    profilePictureView.layer.masksToBounds = TRUE;
    profileImageView.layer.cornerRadius = 18.f;
    profileImageView.layer.masksToBounds = TRUE;
    
    [backgroundImageView setImage:[UIImage imageNamed:@"avatar_empty.png"]];

    if(![[cl_DataManager shareInstance] bGetAvatarFB]){
//        [profileImageView setImage:[UIImage imageNamed:@"fb_avatar@2x.png"]];
        [profileImageView setImage:[[[[cl_DataManager shareInstance] UserInfo] sAvatarUrl] image]];
    }else{
        [profileImageView setImage:[UIImage imageNamed:@"wide_empty_button.png"]];
        [profileImageView setBackgroundColor:[UIColor clearColor]];
        profilePictureView.profileID = [fbInfo objectForKey:@"id"];
    }

    
}
- (IBAction)buttonSwitch:(id)sender {
    
    if (switchView.on) {

        [[OALSimpleAudio sharedInstance] setEffectsMuted:false];
        [[OALSimpleAudio sharedInstance] setBgMuted:false];
        [[cl_DataManager shareInstance] setTurnOnSound:false];
        
    }else{
        [[OALSimpleAudio sharedInstance] setEffectsMuted:true];
        [[OALSimpleAudio sharedInstance] setBgMuted:true];
        [[cl_DataManager shareInstance] setTurnOnSound:true];
    }

}
-(void)setProfileLine{
    [beginLineImageView setBackgroundColor:[UIColor blackColor]] ;
}
-(void)setProfileNonLine{
    [beginLineImageView setBackgroundColor:[UIColor clearColor]] ;
}
-(void)setProfileBeginLine{
    [lineImageView setBackgroundColor:[UIColor blackColor]] ;
}
-(void)setProfileNonBeginLine{
    [lineImageView setBackgroundColor:[UIColor clearColor]] ;
    
}
-(void)setProfileSwitch{
    switchView.hidden = NO;
    if([[cl_DataManager shareInstance] turnOnSound] == false){
        switchView.on = true;
    }else{
        switchView.on = false;
    }
}
-(void)setProfileNonSwitch{
    switchView.hidden = YES;
}

-(void)setReportLabel:(NSString *)reportString AndPhoneNumberString:(NSString *)phoneNumber{
    reportLabel.text = reportString;
    phoneNumberLabel.text = phoneNumber;
}
@end

#pragma mark- Current Quest Cell
@implementation cl_CellCurrentQuest
-(void)cellCurrentQuestOnClick:(id)sender{

}

-(void)updateDataWithObject:(id)objectData
{
    
    cl_Condition *currentQuest = (cl_Condition *)objectData;

    currentQuestLabel.text = currentQuest.conditionTitle;
    [currentQuestLabel setFont:FONT_GOTHAM_3];
    
    UIImage *image ;
    
    if (currentQuest.conditionIsFinished == 1) {
        image = [UIImage imageNamed:@"complete-quest-icon.png"];
    
        if (currentQuest.conditionType!=0) {
            currentQuestLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
        }
        else
        {
            currentQuestLabel.textColor = [UIColor whiteColor];
        }
    }else{
        image = [UIImage imageNamed:currentQuest.conditionImageName];
        currentQuestLabel.textColor = [UIColor whiteColor];
    }
    [currentQuestImage setImage:image];
    
}

@end

#pragma mark- Activity Cell
@implementation cl_CellActivity
-(void)cellActivityOnClick:(id)sender{
    
}
-(void)updateDataWithObject:(id)objectData andIndex:(int)index
{
    
    cl_Activities *activities = (cl_Activities *)objectData;
    
    [activityTitleLabel setFont:FONT_GOTHAM_3];
    activityTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    activityTitleLabel.text = activities.activityTitle;
    
//    [activityPointsLabel setFont:FONT_GOTHAM_3];
//    activityPointsLabel.font = [UIFont systemFontOfSize:18.0f];
    activityPointsLabel.text = activities.activityDescription;//[NSString stringWithFormat:@"%i", activities.activityPoints];
    if(activities.isNullImage == 0){
        UIImage *image = [UIImage imageNamed:@"white-bg.png"];
        [activityImageView setImage:image];
    }else{
        activityImageView.image = activities.activityImage.image;
    }
    activityImageView.layer.cornerRadius = 23.0f;
    activityImageView.layer.masksToBounds = YES;
    
    int activityActionId = [activities activityActionId];
    switch (activityActionId) {
        case 1:
            [activityButton setTitle:@"Share on Facebook" forState:UIControlStateNormal];
            break;
        case 2:
            [activityButton setTitle:@"Sign up for Your newsletter" forState:UIControlStateNormal];
            break;
        case 3:
            [activityButton setTitle:@"Like our facebook pages" forState:UIControlStateNormal];
            break;
        case 4:
            [activityButton setTitle:@"Add to user calendar" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [activityButton setTag:index];
    [activityButton addTarget:self action:@selector(ActivityFunctionButton:) forControlEvents:UIControlEventTouchUpOutside];
}
- (IBAction)ActivityFunctionButton:(id)sender {
    
    cl_Activities *activity = [[[cl_DataManager shareInstance] m_arrayActivity] objectAtIndex:[sender tag]];
    [[cl_DataManager shareInstance] setSelectedActivity:activity];
    
    NSString* activityString = [NSString stringWithFormat:@"%@", [[sender titleLabel] text]];
//    NSLog(@"title: %@", activityString);
    
    if ([activityString isEqualToString:@"Share on Facebook"]) {
        alertShareFB = [[UIAlertView alloc] initWithTitle:@"Share on Facebook?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertShareFB show];
    }else if ([activityString isEqualToString:@"Sign up for Your newsletter"]) {
        alertSignupNewsleter = [[UIAlertView alloc] initWithTitle:@"Sign up for their newsletter?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertSignupNewsleter show];
    }else if ([activityString isEqualToString:@"Like our facebook pages"]) {
        alertRegisterCalendar = [[UIAlertView alloc] initWithTitle:@"Add to your calendar?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertRegisterCalendar show];
    }else if ([activityString isEqualToString:@"Add to user calendar"]) {
        alertRegisterCalendar = [[UIAlertView alloc] initWithTitle:@"Add to your calendar?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertRegisterCalendar show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertShareFB) {
        if (buttonIndex == 1) {
//            NSDictionary* fbInfo = [[[cl_DataManager shareInstance] UserInfo] facebookInfo];
            NSString *sPlayerName = [[[cl_DataManager shareInstance] UserInfo] sHeroName];
//            if ([sPlayerName isEqual:[NSNull null]]) {
//                NSLog(@"sName: %@", sPlayerName);
//            }
            NSString *message = [NSString stringWithFormat:@"%@ had attended %@", sPlayerName, [[[cl_DataManager shareInstance] SelectedActivity] activityActionContent]];
//            if ([[FBSession activeSession] isOpen]) {
                [self shareFBInfo:message andOrganizationUrl:webUrl];
            
                // Save points for user
                [[cl_DataManager shareInstance] requestSavePoint:[[[cl_DataManager shareInstance] SelectedActivity] activityPoints]];
            
//            }
        }
    }
    else if(alertView == alertRegisterCalendar){
        if (buttonIndex == 1) {
            NSString *message = [[[cl_DataManager shareInstance] SelectedActivity] activityActionContent];
            
            [self registerCalendar:message];
            UIAlertView *notif = [[UIAlertView alloc] initWithTitle:@"Success" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notif show];//this is so you can access this event later
            
            // Save points for user
            [[cl_DataManager shareInstance] requestSavePoint:[[[cl_DataManager shareInstance] SelectedActivity] activityPoints]];
        }
        
    }
    else if(alertView == alertSignupNewsleter){
        if (buttonIndex == 1) {
            [self signupNewsletter];
            
            // Save points for user
            [[cl_DataManager shareInstance] requestSavePoint:[[[cl_DataManager shareInstance] SelectedActivity] activityPoints]];
        }
        
    }
    cl_OrganizationDetailViewController *controller = [[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController"  bundle:nil];
    [controller refreshScreen];
}
-(void)registerCalendar:(NSString *)title{
    
    store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = title;
        event.startDate = [NSDate date]; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60*24];  //set 24 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //        NSString *savedEventId = event.eventIdentifier;
        
    }];
}

-(void)shareFBInfo:(NSString *)message andOrganizationUrl:(NSString *)url
{
    
    NSDictionary* postContent = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", url, @"link",nil];
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 // Publish the story if permission was granted
                                                 [[cl_AppManager shareInstance] publishStory:postContent];
                                             }
                                         }];
        
    } else {
        // If permissions present, publish the story
        [[cl_AppManager shareInstance] publishStory:postContent];
    }
}


-(void)signupNewsletter{
    
    [[cl_DataManager shareInstance] setIsGotoNewsletter:true];
    [[cl_AppManager shareInstance] SwitchView:SCREEN_WEB_BROWSER_ID];
}
@end

#pragma mark- Award Cell
@implementation cl_CellAward
-(void)cellAwardOnClick:(id)sender{
    
}
-(void)updateDataWithObject:(id)objectData andIndex:(int)index
{
    cl_Award *award = (cl_Award *)objectData;

    awardTitleLabel.text = award.awardTitle;
    
    [awardImageButton setBackgroundImage:award.awardImage.image forState:UIControlStateNormal];
    awardImageButton.layer.cornerRadius = 27.2f;
    awardImageButton.layer.masksToBounds = YES;
    
}
@end

#pragma mark- Donation Cell
@implementation cl_CellDonation
-(void)cellDonationOnClick:(id)sender{
    
}

-(void)updateDataWithObject:(id)objectData andIndex:(int)index
{
    
    cl_Donation *donation = (cl_Donation *)objectData;
    
    [donationTitleLabel setFont:FONT_GOTHAM_3];
    donationTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    donationTitleLabel.text = donation.donationTitle;
    
    donationPointsLabel.text = donation.donationDescription;//[NSString stringWithFormat:@"%i", donation.donationPoints];
    if(donation.isNullImageD == 0){
        onlineButton.hidden = true;
//        donationButton.hidden = false;
        shareFBButton.hidden = false;

        organizationTitle.hidden = true;

        UIImage *image = [UIImage imageNamed:@"white-bg.png"];
        [donationImageView setImage:image];
    }else if(donation.isNullImageD == -1){
        
        onlineButton.hidden = true;
        donationButton.hidden = true;
        shareFBButton.hidden = true;
        
        organizationTitle.hidden = false;
        
    }else if(donation.isNullImageD == 1){
        
        onlineButton.hidden = true;
        donationButton.hidden = true;
        shareFBButton.hidden = true;
        
        organizationTitle.hidden = true;

        [onlineButton setTitle:@"Get Directions Here" forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"DonateAtAddress_Icon.png"];
        [donationImageView setImage:image];
    }else if(donation.isNullImageD == 2){
        onlineButton.hidden = false;
        donationButton.hidden = true;
        shareFBButton.hidden = true;
        
        organizationTitle.hidden = true;
        [onlineButton setTitle:@"Donate Online" forState:UIControlStateNormal];

        UIImage *image = [UIImage imageNamed:@"DonateOnline_Icon.png"];
        [donationImageView setImage:image];
    }else{
        onlineButton.hidden = true;
//        donationButton.hidden = false;
        shareFBButton.hidden = false;
        
        organizationTitle.hidden = true;

        donationImageView.image = donation.donationImage.image;
    }
    
    donationImageView.layer.cornerRadius = 23.0f;
    donationImageView.layer.masksToBounds = YES;
    
//    [donationButton set]
//    [donationButton setTitle:[NSString stringWithFormat:@"donate %i points", [donation donationPoints]] forState:UIControlStateNormal];
    [donationButton setTag:index];
    [donationButton addTarget:self action:@selector(donationFunctionButton:) forControlEvents:UIControlEventTouchUpOutside];

    [shareFBButton setTag:index];
    [shareFBButton addTarget:self action:@selector(shareFBButton:) forControlEvents:UIControlEventTouchUpOutside];
    
    [onlineButton setTag:index];
    [onlineButton addTarget:self action:@selector(homeButton:) forControlEvents:UIControlEventTouchUpOutside];
}

- (IBAction)donationFunctionButton:(id)sender {
    // Use this check click button
    bClicked = true;
    NSLog(@"tag: %i", [sender tag]);

    cl_Donation *donation = [[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:[sender tag]];
    [[cl_DataManager shareInstance] setSelectedDonation:donation];
    
    NSString *message = [NSString stringWithFormat:@"You have donated %i points we will donate $%i to %@", [[[cl_DataManager shareInstance] SelectedDonation] donationPoints], [[[cl_DataManager shareInstance] SelectedDonation] donationPoints], [[[cl_DataManager shareInstance] SelectedOrganization] organizationTitle]];
    donationAlertView = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
    [donationAlertView show];
}

- (IBAction)shareFBButton:(id)sender {
    cl_Donation *donation = [[[cl_DataManager shareInstance] ArrayDonations] objectAtIndex:[sender tag]];
    [[cl_DataManager shareInstance] setSelectedDonation:donation];

    alertShareFB = [[UIAlertView alloc] initWithTitle:@"Share on Facebook?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
    [alertShareFB show];
}

- (IBAction)homeButton:(id)sender {
    
    if ([sender tag] == 1) {
        alertSignupNewsleter = [[UIAlertView alloc] initWithTitle:@"Visit donate website?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertSignupNewsleter show];
    }else{
        alertShowMap = [[UIAlertView alloc] initWithTitle:@"Show organization's address in map?" message:@"" delegate:self cancelButtonTitle:@"Cannel" otherButtonTitles:@"OK", nil];
        [alertShowMap show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == donationAlertView) {
        if (buttonIndex == 1) {
            
            // Check: Have user enough points?
//            if ([[[cl_DataManager shareInstance] UserInfo] iPoint] < [[[cl_DataManager shareInstance] SelectedDonation] donationPoints]) {
//                UIAlertView *notif = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Sorry, you don't have enough points!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [notif show];
//                return;
//            }
            
            // Save points for user
            [[cl_DataManager shareInstance] requestInsertMedal:[[[cl_DataManager shareInstance] SelectedDonation] donationMedalId]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertFinishMedal:) name:NOTIFY_SAVE_MEDAL_SUCCESS object:nil];

      
        }
    }
    cl_CellActivity *activityDetail = [[cl_CellActivity alloc] init];
    if (alertView == alertShareFB) {
        if (buttonIndex == 1) {
            NSString *message = [NSString stringWithFormat:@"%@: %@.\n%@", [[[cl_DataManager shareInstance] SelectedOrganization] organizationTitle], [[[cl_DataManager shareInstance] SelectedDonation] donationDescription], [[[cl_DataManager shareInstance] SelectedOrganization] organizationWebsiteUrl]];
            
            NSString *webUrl = [[[cl_DataManager shareInstance] SelectedOrganization] organizationWebsiteUrl];
            [activityDetail shareFBInfo:message andOrganizationUrl:webUrl];
            
        }
    }
    else if(alertView == alertSignupNewsleter){
        if (buttonIndex == 1) {
            [[cl_DataManager shareInstance] setIsVisitDonateWebsite:true];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_WEB_BROWSER_ID];
        }
        
    }
    else if(alertView == alertShowMap){
        if (buttonIndex == 1) {
            [[cl_DataManager shareInstance] setIsAdressInShowMap:true];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_WEB_BROWSER_ID];
        }
        
    }
}
-(void)insertFinishMedal:(NSNotification*)notif
{
    if (bClicked) {
        bClicked = false;

        UIAlertView *notifAlertView;
        if ([[cl_DataManager shareInstance] iSaveMedalStatus] == 1) {
           
            notifAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [[cl_DataManager shareInstance] requestSavePoint:([[[cl_DataManager shareInstance] SelectedDonation] donationPoints])];
            
            cl_OrganizationDetailViewController *controller = [[cl_OrganizationDetailViewController alloc] initWithNibName:@"cl_OrganizationDetailViewController"  bundle:nil];
            [controller refreshScreen];
        }else{
            notifAlertView = [[UIAlertView alloc] initWithTitle:@"Thank you" message:@"You had donated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [notifAlertView show];
    }
    
}
@end

#pragma mark- Organization Cell
@implementation cl_CellOrganization
-(void)cellOrganizationOnClick:(id)sender{
    
}


-(void)updateDataWithObject:(id)objectData
{
    
    cl_Organization *organization = (cl_Organization *)objectData;
    
    [organizationTitleLabel setFont:FONT_GOTHAM_3];
    organizationTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    organizationTitleLabel.text = organization.organizationTitle;
    
    NSString *nameOrganization = @"";
    NSMutableString *nameOrg = [NSMutableString stringWithString:organization.organizationTitle];
    for (int index = 0; index < nameOrg.length; index++){
        if (index == 0) {
            nameOrganization = [NSString stringWithFormat:@"%c", [nameOrg characterAtIndex:index]];
        }
        if ([nameOrg characterAtIndex:index] == ' ') {
            nameOrganization = [nameOrganization stringByAppendingString:[NSString stringWithFormat:@"%c", [nameOrg characterAtIndex:index+1]]];
            break;
        }
    }
    nameOrganization = [nameOrganization uppercaseString];
    
    if(organization.isNullImage == 0){
        UIImage *image = [UIImage imageNamed:@"white-bg.png"];
        [organizationImage setImage:image];
        textNameLabel.text = nameOrganization;
    }else{
        organizationImage.image = organization.organizationImage.image;
        textNameLabel.text = @"";
    }
    organizationImage.layer.cornerRadius = 19.5f;
    organizationImage.layer.masksToBounds = YES;
}
@end

#pragma mark- Avatar Cell
@implementation cl_CellAvatar
-(void)cellAvatarOnClick:(id)sender{
    
}
-(void)updateDataWithObject:(id)objectData andIndex:(int)index
{
    cl_UserInfo *userInfo = (cl_UserInfo *)objectData;
    
    avatarNameLabel.text = userInfo.sAvatarName;
    
    [avatarImageButton setBackgroundImage:userInfo.sAvatarUrl.image forState:UIControlStateNormal];
    avatarImageButton.layer.cornerRadius = 27.2f;
    avatarImageButton.layer.masksToBounds = YES;
    
    [backgroundImageView setImage:[UIImage imageNamed:userInfo.sAvatarImageName]];
    
    [avatarImageButton setTag:index];
    [avatarImageButton addTarget:self action:@selector(ChangePlayerAvatar:) forControlEvents:UIControlEventTouchUpOutside];
}
- (IBAction)ChangePlayerAvatar:(id)sender {
    m_bNotifSuccess = false;
    
    m_iAvatarId = [sender tag];
    if ([[[cl_DataManager shareInstance] UserInfo] iAvatarId] == m_iAvatarId) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Same Avatar"
                                                          message:@"You are using this avatar"
                                                         delegate:self cancelButtonTitle:nil
                                                        otherButtonTitles:nil, nil];
        [message show];
        [self performSelector:@selector(dismissAlertview:) withObject:message afterDelay:1.5];
    }else{
        notifAlertview = [[UIAlertView alloc] initWithTitle:@"Change avatar"
                                                    message:@"Would you like to change your avatar?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
        [notifAlertview show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == notifAlertview) {
        if (buttonIndex == 1) {
            // Use this check if player want login FB
            if (m_iAvatarId == 0) {
                notifLoginFBAlertview = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"Please login your Facebook account"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok", nil];
                [notifLoginFBAlertview show];
                
            }else{
                [[[cl_DataManager shareInstance] UserInfo] setIAvatarId:m_iAvatarId];
                [[cl_DataManager shareInstance] requestUpdatePlayerAvatar:@"0"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinishPlayerAvatar:) name:NOTIFY_UPDATE_PLAYER_AVATAR_SUCCESS object:nil];
            }
        }
        
    }
    if (alertView == notifLoginFBAlertview) {
        if (buttonIndex == 1) {
            [FBSession.activeSession closeAndClearTokenInformation];
//            [[[cl_DataManager shareInstance] UserInfo] setSHeroName:@""];
//            [[[cl_DataManager shareInstance] UserInfo] setIPoint:0];
            [[cl_DataManager shareInstance] setBChangeAvatarFB:true];
            [[cl_DataManager shareInstance] setPlayerName:@""];
             [[[cl_DataManager shareInstance] UserInfo] setIAvatarId:m_iAvatarId];
            [[cl_AppManager shareInstance] SwitchView:SCREEN_LOGIN_ID];
        }
    }
}

- (void)updateFinishPlayerAvatar:(NSNotification *)notif{
    
    if ([[[cl_DataManager shareInstance] UserInfo] iAvatarId] != 0 && !m_bNotifSuccess) {
        
        [[cl_DataManager shareInstance] requestGetPlayerAvatar];
        [[cl_DataManager shareInstance] requestGetPlayerAvatarList];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Changed success your avatar"
                                                         delegate:self
                                                cancelButtonTitle:nil otherButtonTitles:nil];
        [message show];
        [self performSelector:@selector(dismissAlertview:) withObject:message afterDelay:1.5];
        cl_SettingViewController *settingViewController = [[cl_SettingViewController alloc] init];
        [settingViewController refreshScreen];
        
        m_bNotifSuccess = true;
    }
}
-(void)dismissAlertview:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
}
@end



















































