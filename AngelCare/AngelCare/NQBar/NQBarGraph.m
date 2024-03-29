//
//  NQBarGraph.m
//  NQBarGraphExample
//
//  Created by AhmedElnaqah on 6/2/13.
//  Copyright (c) 2013 elnaqah. All rights reserved.
//
//The MIT License (MIT)
//
//Copyright (c) 2013 ahmed elnaqah
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


#import "NQBarGraph.h"
#import "NQData.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define BAR_WIDTH_MAX 100
#define BAR_WIDTH_MIN 3
#define BAR_WIDTH_DEFAULT 20
#define BAR_SPACES_DEFAULT 10
#define HORIZONTAL_PADDING 20
#define VERTICAL_PADDING 20
#define HORIZONTAL_START_LINE 0.2 //控制畫面左右的位置
#define VERTICAL_START_LINE 0.2
//#define VERTICALE_DATA_SPACES 32.5 //y軸的間隔
#define VERTICALE_DATA_SPACES 22.5 //y軸的間隔
#define LABEL_DIM 20

@interface NQBarGraph()
@property CGPoint contentScroll;
@property int maxHeight;
@property int maxWidth;
@end
@implementation NQBarGraph
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.barWidth=BAR_WIDTH_DEFAULT;
        self.spaceBetweenBars=BAR_SPACES_DEFAULT;
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
        self.linesColor= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        self.numbersColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        self.numbersTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        self.dateColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.ContentScroll=CGPointZero;
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=YES;
        //最大是多少
        self.numberOfVerticalElements=10;
        //直方圖的顏色
        self.barColor=[UIColor colorWithRed:252/255.0 green:206/255.0 blue:2/255.0 alpha:1];
        self.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.dottedLineColor= [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.barOuterLine=[UIColor colorWithRed:252/255.0 green:206/255.0 blue:2/255.0 alpha:1];
        self.datesBarText=@"Date";
        self.tasksBarText=@"";
        self.fontName=@"Helvetica";
        self.dateFontSize=12;
        self.titlesFontSize=20;
        self.range = 1.0;
        self.verticale_data_space = 22.5;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float minOfTwo=MIN(self.bounds.size.width, self.bounds.size.height);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    
    CGFloat dashPattern[]= {6.0, 5};
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0.0, dashPattern, 2);
    ///draw font
    
    UIFont * font=[UIFont fontWithName:self.fontName size:self.dateFontSize];
    {
        if ([self.type isEqualToString:@"hr"]) {
            [self drawString:@"Hour" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -15) WithFont:font WithColor:self.dateColor WithContext:context];
            [self drawString:@"Day" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -30) WithFont:font WithColor:self.dateColor WithContext:context];
            
            [self drawString:@"Month" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -45) WithFont:font WithColor:self.dateColor WithContext:context];
        }
        else{
            [self drawString:@"Day" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -15) WithFont:font WithColor:self.dateColor WithContext:context];
            
            [self drawString:@"Month" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -30) WithFont:font WithColor:self.dateColor WithContext:context];
        }
        
        
        //write tasks and date
        font=[UIFont fontWithName:self.fontName size:self.titlesFontSize];
        
//        [self drawString:self.datesBarText atPoint:CGPointMake(self.bounds.size.width/2, 7) WithFont:font WithColor:self.textColor WithContext:context];
        
        CGAffineTransform transform=CGAffineTransformMakeTranslation(25, self.bounds.size.height / 2.f);
        CGFloat rotation = M_PI / 2.f;
        transform = CGAffineTransformRotate(transform,rotation);
    //    NSLog(@"height %f",self.bounds.size.height/2.f);
        CGContextSaveGState(context);
        CGContextConcatCTM(context, transform);
        [self drawString:self.tasksBarText atPoint:CGPointMake(0, 0) WithFont:font WithColor:self.textColor WithContext:context];
        
        CGContextRestoreGState(context);
    
    
        font=[UIFont fontWithName:self.fontName size:self.dateFontSize];
        //vertical numbers
        for (int i=0; i<=self.numberOfVerticalElements; i++) {
            int height=self.verticale_data_space* i;
            float verticalLine=height+VERTICAL_START_LINE*minOfTwo-self.contentScroll.y;
            if (verticalLine>VERTICAL_START_LINE*minOfTwo) {
                [self.dottedLineColor set];
                CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, verticalLine);
                CGContextAddLineToPoint(context, self.bounds.size.width, verticalLine);
                CGContextStrokePath(context);
                int range = (int)self.range;
                NSString * numberString=[NSString stringWithFormat:@"%d",i*range];
                [self.numbersColor set];
                //取消原有的白色正方形
//                CGContextFillRect(context, CGRectMake((HORIZONTAL_START_LINE*minOfTwo)/2-4, verticalLine-8, 15, 15));
                
                [self drawString:numberString atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)/2+2, verticalLine-8) WithFont:font WithColor:self.numbersTextColor WithContext:context];
            }
        }
    }
    
    //set the line solid
    CGFloat  normal=1;
    
    CGContextSetLineDash(context,0,&normal,0);
    
    int index=0;
    
    NSString * yearString=@"";
    for (NQData * dataObject in self.dataSource) {
        float height=self.verticale_data_space* [dataObject.number intValue] / self.range;
        
        if (VERTICAL_START_LINE*minOfTwo-self.contentScroll.y <VERTICAL_START_LINE*minOfTwo) {
            height-=self.contentScroll.y;
        }
        float xPosition=HORIZONTAL_START_LINE*minOfTwo+(index+1)* self.spaceBetweenBars + index * self.barWidth+self.contentScroll.x;
        
        if (xPosition>=HORIZONTAL_START_LINE*minOfTwo && xPosition<self.bounds.size.width ){
            [self.dateColor set];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dataObject.date];
            NSInteger day = [components day];
            NSInteger month = [components month];
            NSInteger year=[components year];
            
            NSString * dayString=[NSString stringWithFormat:@"%ld",(long)day];
            NSString * monthString=[NSString stringWithFormat:@"%ld",(long)month];
            yearString=[NSString stringWithFormat:@"%ld",(long)year];
            
            //draw date for each samples
            if ([self.type isEqualToString:@"hr"]) {
                // draw hr
                [self drawString:dataObject.hr atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo - 15) WithFont:font WithColor:self.numbersTextColor WithContext:context];
                [self drawString:dayString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo-30) WithFont:font WithColor:self.numbersTextColor WithContext:context];
                
                [self drawString:monthString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo -45) WithFont:font WithColor:self.numbersTextColor WithContext:context];
            }
            else{
                [self drawString:dayString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo-15) WithFont:font WithColor:self.numbersTextColor WithContext:context];
                
                [self drawString:monthString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo -30) WithFont:font WithColor:self.numbersTextColor WithContext:context];
            }
            
        }

        
        if (height>0) {
            
            if (xPosition>=HORIZONTAL_START_LINE*minOfTwo && xPosition<self.bounds.size.width ) {
                //在目前可視畫面上
                CGRect barRect=CGRectMake(xPosition, VERTICAL_START_LINE*minOfTwo, self.barWidth, height);
                [self.barOuterLine set];
                CGContextStrokeRect(context, barRect);
                [self.barColor set];
                UIRectFill(barRect);
                //draw number
                NSString *vString = [NSString stringWithFormat:@"%d",[dataObject.number intValue]];
                [self drawString:vString atPoint:CGPointMake(xPosition + self.barWidth/2, VERTICAL_START_LINE*minOfTwo + height) WithFont:font WithColor:[UIColor redColor] WithContext:context];
            }
            else if(xPosition+self.barWidth >HORIZONTAL_START_LINE*minOfTwo  && xPosition<HORIZONTAL_START_LINE*minOfTwo )
            {   //不在目前可視畫面上
                
                [self.barColor set];
                UIRectFill(CGRectMake(HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo, self.barWidth-(HORIZONTAL_START_LINE*minOfTwo-xPosition), height));
                
            }
            
            
            
        }
        
        index++;
    }
    
    //draw year
//    [self drawString:yearString atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -45) WithFont:font WithColor:self.numbersTextColor WithContext:context];
    
    // draw axis
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo);
    [self.linesColor set];
    // y axis 長度
    CGContextAddLineToPoint(context, HORIZONTAL_START_LINE*minOfTwo, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo);
    CGContextAddLineToPoint(context, self.bounds.size.width, VERTICAL_START_LINE*minOfTwo);
    CGContextStrokePath(context);
    
    
    
}


#pragma mark setDataSource
-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource=dataSource;
    
    //calculate the limit of height
    _maxHeight=0;
    for (NQData * dataObject in _dataSource) {
//        int height=VERTICALE_DATA_SPACES* [dataObject.number intValue];
        int height= [dataObject.number intValue];
        _maxHeight=MAX(height, _maxHeight);
        
    }
    NSLog(@"_maxHeight = %d",_maxHeight);
    BOOL flag = YES;
    int max = 1;
    int min = 1;
    while (flag) {
        if (_maxHeight > max) {
            min = max;
            max = max * 10;
        }
        else{
            NSLog(@"max = %d, min = %d",max,min);
            for (int i = min; min < max; i = i + min) {
                if (i > _maxHeight) {
                    max = i;
                    break;
                }
            }
            flag = NO;
        }
    }
    NSLog(@"max = %d",max);
    self.range = max / 10;
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
////    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
    _maxHeight = 0;
    
    //calculate the limit of width
    _maxWidth=([_dataSource count]-1)*(self.barWidth+self.spaceBetweenBars);


    
    _contentScroll.x = -self.maxWidth + BAR_WIDTH_DEFAULT * 6;
//    [self setNeedsDisplay];
//    _contentScroll.y = self.maxHeight;
}
#pragma mark touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@",event);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
    float xDiffrance=touchLocation.x-prevouseLocation.x;
    float yDiffrance=touchLocation.y-prevouseLocation.y;
    
    _contentScroll.x+=xDiffrance;
    _contentScroll.y+=yDiffrance;
    
    //到最左邊了
    if (_contentScroll.x >0) {
        _contentScroll.x=0;
    }
    //到最下面了
    if(_contentScroll.y<0)
    {
        _contentScroll.y=0;
    }
    
    if (-_contentScroll.x>self.maxWidth) {
        _contentScroll.x=-self.maxWidth;
    }
    if (_contentScroll.y>self.maxHeight) {
        _contentScroll.y=self.maxHeight;
    }
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


#pragma mark draw attributed string
-(void) drawString:(NSString *) string atPoint:(CGPoint) point WithFont:(UIFont *) font WithColor:(UIColor *) color WithContext:(CGContextRef) context
{
    
    NSDictionary * attribut=@{NSForegroundColorAttributeName:color,NSFontAttributeName:font};
    
    CGSize sizeOfStr=[string sizeWithAttributes:attribut];
    CGPathRef path=CGPathCreateWithRect(CGRectMake(point.x-(sizeOfStr.width/2), point.y, sizeOfStr.width, sizeOfStr.height+2), &CGAffineTransformIdentity);
    //debug
    //    CGContextFillRect(context, CGRectMake(point.x-(sizeOfStr.width/2), point.y, sizeOfStr.width, sizeOfStr.height+2));
    
    NSAttributedString * dateAttString=[[NSAttributedString alloc] initWithString:string attributes:attribut];
    
    
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)dateAttString);
    CTFrameRef frame =CTFramesetterCreateFrame(framesetter,CFRangeMake(0, [dateAttString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    //release
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}
@end
