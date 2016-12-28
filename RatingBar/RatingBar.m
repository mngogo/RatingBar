//
//  RatingBar.m
//  easymarketing
//
//  Created by HailongHan on 15/1/1.
//  Copyright (c) 2015年 cubead. All rights reserved.
//

#import "RatingBar.h"

@interface RatingBar (){
    float starRating;
    float lastRating;
    
    float height;
    float width;
    
    
    UIImage *unSelectedImage;
    UIImage *halfSelectedImage;
    UIImage *fullSelectedImage;
    NSMutableArray *starsArray; // 保存生成的每一个星星
}
@property (nonatomic, strong) UIImageView *stars;

@property (nonatomic,weak) id<RatingBarDelegate> delegate;

@end

@implementation RatingBar

/**
 *  初始化设置未选中图片、半选中图片、全选中图片，以及评分值改变的代理（可以用
 *  Block）实现
 *
 *  @param deselectedName   未选中图片名称
 *  @param halfSelectedName 半选中图片名称
 *  @param fullSelectedName 全选中图片名称
 *  @param delegate          代理
 */
-(void)setImageDeselected:(NSString *)deselectedName halfSelected:(NSString *)halfSelectedName fullSelected:(NSString *)fullSelectedName andDelegate:(id<RatingBarDelegate>)delegate{
    
    self.delegate = delegate;
    
    unSelectedImage = [UIImage imageNamed:deselectedName];
    
    halfSelectedImage = halfSelectedName == nil ? unSelectedImage : [UIImage imageNamed:halfSelectedName];
    
    fullSelectedImage = [UIImage imageNamed:fullSelectedName];
    
    height = 0.0,width = 0.0;
    
    if (height < [fullSelectedImage size].height) {
        height = [fullSelectedImage size].height;
    }
    if (height < [halfSelectedImage size].height) {
        height = [halfSelectedImage size].height;
    }
    if (height < [unSelectedImage size].height) {
        height = [unSelectedImage size].height;
    }
    if (width < [fullSelectedImage size].width) {
        width = [fullSelectedImage size].width;
    }
    if (width < [halfSelectedImage size].width) {
        width = [halfSelectedImage size].width;
    }
    if (width < [unSelectedImage size].width) {
        width = [unSelectedImage size].width;
    }
    
    //控件宽度适配
    CGRect frame = [self frame];
    
    CGFloat viewWidth = width * _starsNum;
    if (frame.size.width > viewWidth) {
        viewWidth = frame.size.width;
    }
    frame.size.width = viewWidth;
    frame.size.height = height;
    [self setFrame:frame];
    
    starRating = 0.0;
    lastRating = 0.0;
    
    // 如果没有设置星星的数量，则默认为5
    if(_starsNum == 0){
        _starsNum = 5;
    }
    starsArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < _starsNum; i++){
        _stars = [[UIImageView alloc] initWithImage:unSelectedImage];
        //星星图片之间的间距
        CGFloat space = (CGFloat)(viewWidth - width * _starsNum)/(_starsNum + 1);
        CGFloat startX = space;
        [_stars setFrame:CGRectMake(startX + i * (width + space), 0, width, height)];
        [_stars setUserInteractionEnabled:NO];
        [starsArray addObject:_stars];
        [self addSubview:_stars];
    }
}

/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
-(void)displayRating:(float)rating{
    
    for(int i = 0; i < _starsNum; i++){
        [starsArray[i] setImage:unSelectedImage];
    }
    
    // 根据分数来显示不同的图片
    int score = floor(rating);
    for(int k = 0; k < score; k++){
        [starsArray[k] setImage:fullSelectedImage];
        
    }
    if(rating > score){
        [starsArray[score] setImage:halfSelectedImage];
    }
    
    starRating = rating;
    lastRating = rating;
    [_delegate ratingBar:self ratingChanged:rating];
}

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
-(float)rating{
    return starRating;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesRating:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesRating:touches];
}

//触发
- (void)touchesRating:(NSSet *)touches{
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    //星星图片之间的间距
    CGFloat space = (CGFloat)(self.frame.size.width - width * _starsNum)/(_starsNum + 1);
    float newRating = 0;

    // 根据点击的x轴的位置来得到对应的分数
    if (point.x >= 0 && point.x <= self.frame.size.width) {
        int i = 0;
        int starsMax = 100;
        for(; i < starsMax; i++){
            int num = space * ceil((i + 1) / 2.0) + width * (0.5 * i);
            if(point.x <= num){
                newRating = 0.5 * i;
                break;
            }
        }        
    }
    
    if (newRating != lastRating){
        [self displayRating:newRating];
    }
}

@end
