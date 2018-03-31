//
//  AnswerCardCollectionCell.m
//  wyzc
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 北京我赢科技有限公司. All rights reserved.
//  答题卡cell

#import "AEAnswerCardCell.h"

@implementation AEAnswerCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _numLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _numLabel.backgroundColor = UIColorFromRGB(0x535353);
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.clipsToBounds = YES;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_numLabel];
        
    }
    return self;
}

- (void)setBackgroundColorWithStatus:(TestResultStatus)status
{
    if (status == TestResultStatusMark) {
        _numLabel.backgroundColor = UIColorFromRGB(0xfff2d1);
        _numLabel.layer.borderColor = UIColorFromRGB(0xFDB901).CGColor;
        _numLabel.layer.borderWidth = 0.5;
        _numLabel.textColor = UIColorFromRGB(0xFDB901);
    }else if (status == TestResultStatusFinished){
        _numLabel.backgroundColor = UIColorFromRGB(0xe2f0fd);
        _numLabel.layer.borderColor = UIColorFromRGB(0x58AEF5).CGColor;
        _numLabel.layer.borderWidth = 0.5;
        _numLabel.textColor = UIColorFromRGB(0x58AEF5);
    }else if (status == TestResultStatusUnfinished){
        _numLabel.backgroundColor = UIColorFromRGB(0xececec);
        _numLabel.layer.borderColor = UIColorFromRGB(0x969696).CGColor;
        _numLabel.layer.borderWidth = 0.5;
        _numLabel.textColor = UIColorFromRGB(0x969696);
    }
}

@end
