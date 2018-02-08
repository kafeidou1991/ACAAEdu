//
//  AEAboutMeVC.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/8.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEAboutMeVC.h"

@interface AEAboutMeVC ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

@end

@implementation AEAboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.appNameLabel.text = AEAppName;
    self.appVersionLabel.text = [NSString stringWithFormat:@"iPhone V%@",AEVersion];
}



@end
