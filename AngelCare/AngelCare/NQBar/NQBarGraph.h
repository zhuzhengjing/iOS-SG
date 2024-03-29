//
//  NQBarGraph.h
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


#import <UIKit/UIKit.h>

@interface NQBarGraph : UIView

@property float spaceBetweenBars;
@property float barWidth;
@property (strong) UIColor * linesColor;
@property (strong) UIColor * numbersColor;
@property (strong) UIColor * numbersTextColor;
@property (strong) UIColor * dateColor;
@property (strong) UIColor * barColor;
@property (nonatomic,strong) NSArray * dataSource;
@property (strong) UIColor * textColor;
@property (strong) UIColor * dottedLineColor;
@property (strong) UIColor * barOuterLine;
@property int numberOfVerticalElements;
@property (strong) NSString * datesBarText;
@property (strong) NSString * tasksBarText;
@property (strong) NSString * fontName;
@property CGFloat dateFontSize;
@property CGFloat titlesFontSize;
//new add
@property float range;
@property NSString *type;
//VERTICALE_DATA_SPACES
@property int verticale_data_space;
@end
