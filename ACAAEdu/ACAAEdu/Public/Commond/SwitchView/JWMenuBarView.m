//
//  JWMenuBarView.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/29.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "JWMenuBarView.h"

#define BUTTONITEMWIDTH   70

@interface JWMenuBarView (){
    NSMutableArray        *_mButtonArray;
    NSMutableArray        *mItemInfoArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
    UIView                *bottomView;
}
/**
 存放button的数组
 */
@property (nonatomic, strong) NSMutableArray * buttonsArray;

@end


@implementation JWMenuBarView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (bottomView == nil) {
            bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = AEThemeColor;
        }
        if (_mButtonArray == nil) {
            _mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:titles];
    }
    return self;
}


-(void)createMenuItems:(NSArray *)aItemsArray{
    int i = 0;
    float menuWidth = 0.0;
    for (NSDictionary *lDic in aItemsArray) {
        NSString *vNormalImageStr = [lDic objectForKey:NOMALKEY];
        NSString *vHeligtImageStr = [lDic objectForKey:HEIGHTKEY];
        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];
        float vButtonWidth = [[lDic objectForKey:TITLEWIDTH] floatValue];
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vButton setBackgroundImage:[UIImage imageNamed:vNormalImageStr] forState:UIControlStateNormal];
        [vButton setBackgroundImage:[UIImage imageNamed:vHeligtImageStr] forState:UIControlStateSelected];
        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        [vButton setTitleColor:AEColorLightText forState:UIControlStateNormal];
        [vButton setTitleColor:AEThemeColor forState:UIControlStateHighlighted];
        [vButton setTitleColor:AEThemeColor forState:UIControlStateSelected];
        [vButton setTag:i];
        vButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        [mScrollView addSubview:vButton];
        [_mButtonArray addObject:vButton];
        
        menuWidth += vButtonWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于屏幕宽度则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}

//MARK: 其他辅助功能
//MARK:  取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in _mButtonArray) {
        vButton.selected = NO;
    }
}

//MARK: 模拟选中第几个button
-(void)clickMenuAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [_mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

//MARK: 改变第几个button为选中状态，不发送delegate
-(void)changeMenuStateAtIndex:(NSInteger)aIndex{
    
    UIButton *vButton = [_mButtonArray objectAtIndex:aIndex];
    NSDictionary *dict = [mItemInfoArray objectAtIndex:aIndex];
    CGSize strSize = STRING_FONT_SIZE([dict objectForKey:TITLEKEY],[UIFont systemFontOfSize:12.0f]);
    [bottomView removeFromSuperview];
    bottomView.frame = CGRectMake((vButton.width - strSize.width)/2, vButton.height - 1.0f, strSize.width, 1.0f);
    [vButton addSubview:bottomView];
    
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

//MARK: 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
    //宽度小于屏幕宽度肯定不需要移动
    if (mTotalWidth <= SCREEN_WIDTH) {
        return;
    }
    
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - SCREEN_WIDTH, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
    }
}

//MARK: 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeMenuStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(clickMenuBarViewButtonAtIndex:)]) {
        [_delegate clickMenuBarViewButtonAtIndex:aButton.tag];
    }
}


//MARK: 内存相关
-(void)dealloc{
    [_mButtonArray removeAllObjects];_mButtonArray = nil;
}







@end
