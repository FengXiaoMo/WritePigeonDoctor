//
//  UMComSimplicityUserCenterViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/19.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSimplicityUserCenterViewController.h"
#import "UMComTools.h"
#import <UIKit/UIKit.h>
#import "UMComDataRequestManager.h"
#import "UMComModelObjectHeader.h"
#import "UMComShowToast.h"
#import "UMComSimpleFeedTableViewController.h"
#import "UMComMacroConfig.h"
#import "UMComChangeBorderBtn.h"
#import "UMComUserCenterDataController.h"
#import "UMComSession.h"


#import "UMComImageView.h"
#import "UMComFeedListDataController.h"

#define g_userCenter_count_template @"动态 %lu"

@interface UMComSimplicityUserCenterViewController ()<UMImageViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *statusBarView; //status bar的占位view
@property (weak, nonatomic) IBOutlet UILabel *countLabel; //关注动态
@property (weak, nonatomic) IBOutlet UMComImageView *medal;  //勋章
@property (weak, nonatomic) IBOutlet UIButton *backBtn;   //返回按钮
@property (weak, nonatomic) IBOutlet UMComImageView *protrainImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *userName;     //用户名
@property (weak, nonatomic) IBOutlet UIImageView *gender;   //性别
@property (weak, nonatomic) IBOutlet UMComChangeBorderBtn *reportBtn;   //举报
@property (weak, nonatomic) IBOutlet UIView *userInfoView;  //整个userinfo的view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medalWidthConstraint;


@property(nonatomic,strong)NSString* uid;
-(void)refreshUserInfo:(UMComUser*)user;
-(void)handleBackBtn:(id)target;
-(void)handleReportBtn:(id)target;
@end

@implementation UMComSimplicityUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0"))
    {
        
    }
    else
    {
        //版本小于7.0的时候,去掉statusBarView控件所有的约束
        [self.statusBarView removeFromSuperview];
    }
    
    
    //如果登陆用户的个人中心,就不显示举报
    if ([self.user.uid isEqualToString:[UMComSession sharedInstance].loginUser.uid]) {
         [self.reportBtn removeFromSuperview];
    }
    
    
    //初始化控件
//    [self.backBtn setImage:UMComSimpleImageWithImageName(@"um_com_backwardwhite") forState:UIControlStateNormal];
    [self.backBtn setImage:UMComSimpleImageWithImageName(@"um_forum_back_gray") forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(handleBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置举报控件
    [self.reportBtn.layer setCornerRadius:6];
    [self.reportBtn.layer setBorderWidth:1];
    UIColor* normalColor = UMComColorWithColorValueString(@"FFFFFF");
    UIColor* highlightedColor  = UMComColorWithColorValueString(@"#469ef8");
    self.reportBtn.normalBorderColor  = normalColor;
    self.reportBtn.highlightedBorderColor = highlightedColor;
    [self.reportBtn.layer setBorderColor:normalColor.CGColor];
    
    self.reportBtn.titleLabel.textColor = UMComColorWithColorValueString(@"FFFFFF");
    self.reportBtn.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    self.reportBtn.backgroundColor = [UIColor clearColor];
    [self.reportBtn setTitleColor:UMComColorWithColorValueString(@"999999") forState:UIControlStateHighlighted];
    [self.reportBtn setTitleColor:UMComColorWithColorValueString(@"FFFFFF") forState:UIControlStateNormal];
    [self.reportBtn addTarget:self action:@selector(handleReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置头像
    self.protrainImageView.layer.cornerRadius =  self.protrainImageView.bounds.size.width/2;
    self.protrainImageView.clipsToBounds = YES;
    self.protrainImageView.image = UMComSimpleImageWithImageName(@"um_com_defaultAvatar");
    
    //设置名字
    self.userName.font = UMComFontNotoSansLightWithSafeSize(14);
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.textColor = UMComColorWithColorValueString(@"FFFFFF");
    
    //设置动态
    self.countLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    self.countLabel.textColor = UMComColorWithColorValueString(@"FFFFFF");
    
    UMComSimpleFeedTableViewController *feedVc = [[UMComSimpleFeedTableViewController alloc] init];
    feedVc.dataController = [[UMComFeedListOfTimeLineController alloc] initWithCount:UMCom_Limit_Page_Count userID:self.user.uid timeLineFeedListType:UMComUserTimeLineFeedType_Default];
    
    [self.view addSubview:feedVc.view];
    [self addChildViewController:feedVc];

    UIView *feedView = feedVc.view;
    [feedView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(feedView, _userInfoView);
    NSDictionary *metrics = @{@"hPadding":@0,@"vPadding":@0};
    NSString *vfl = @"|-hPadding-[feedView]-hPadding-|";
    NSString *vfl0 = @"V:|-vPadding-[_userInfoView]-0-[feedView]-vPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict1]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict1]];

    //请求用户信息
    if (self.uid || self.user ) {
        __weak typeof(self) weakself = self;
        
        NSString* uid = self.uid;
        if (!uid) {
            uid = self.user.uid;
        }
        
        [UMComUserCenterDataController fecthUserProfileWithUid:uid source:nil source_uid:nil completion:^(id responseObject, NSError *error) {
            
            if (responseObject && [responseObject isKindOfClass:[UMComUser class]] && !error) {

                weakself.user = responseObject;
                [weakself refreshUserInfo:weakself.user];
            }
            else{
                [UMComShowToast showFetchResultTipWithError:error];
            }
        }];
        
        //直接调用基类UMComDataRequestManager的方法
//        [[UMComDataRequestManager defaultManager] fecthUserProfileWithUid:uid source:nil source_uid:nil completion:^(NSDictionary *responseObject, NSError *error) {
//            
//            if (responseObject) {
//                weakself.user =  [responseObject valueForKey:UMComModelDataKey];
//                [weakself refreshUserInfo:weakself.user];
//            }
//            else{
//                [UMComShowToast showFetchResultTipWithError:error];
//            }
//        }];
    }
    [self refreshUserInfo:self.user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - private method

-(void)refreshUserInfo:(UMComUser*)user
{
    [self.protrainImageView setImageURL:user.icon_url.small_url_string placeHolderImage:[UIImage imageNamed:@"user_image"]];
    
    if (user.feed_count > 0) {
        self.countLabel.text = [[NSString alloc] initWithFormat:g_userCenter_count_template,user.feed_count.longValue];
    }
    else{
        self.countLabel.text = [[NSString alloc] initWithFormat:g_userCenter_count_template,(long)0];
    }

    
    self.userName.text = user.name;
    
    if (user.gender.integerValue == 0) {
        self.gender.image = UMComSimpleImageWithImageName(@"um_com_female");
    }
    else{
        self.gender.image = UMComSimpleImageWithImageName(@"um_com_male");
    }
    
    if (user.medal_list.count > 0) {
       self.medal.hidden = NO;
       UMComMedal* medal =  user.medal_list.firstObject;
        if (medal && [medal isKindOfClass:[UMComMedal class]]) {
            self.medal.delegate = self;
            self.medal.isAutoStart = YES;
            [self.medal setImageURL:medal.icon_url placeHolderImage:[UIImage imageNamed:@"user_image"]];
        }
        else{
            [self.medal setImageURL:nil placeHolderImage:[UIImage imageNamed:@"user_image"]];
        }
    }
    else
    {
         self.medal.hidden = YES;
    }
    
}

-(void)handleBackBtn:(id)target
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleReportBtn:(id)target
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[UMComDataRequestManager defaultManager] userSpamWitUID:self.user.uid completion:^(NSDictionary *responseObject, NSError *error) {
                
                [UMComShowToast spamUser:error];
                
            }];
        }

    }];
}

#pragma mark - UMImageViewDelegate

-(void) updateMedalWithImageView:(UMImageView *)imageView;
{
   CGFloat width =  imageView.bounds.size.width;
   CGFloat height =  imageView.bounds.size.height;
   CGSize imageSize =  imageView.image.size;
   width = imageSize.width * height/ imageSize.height;
   
   self.medalWidthConstraint.constant = width;
   [self.medal updateConstraintsIfNeeded];
}

- (void)imageViewLoadedImage:(UMImageView*)imageView
{
    NSLog(@"imageViewLoadedImage");
     [self updateMedalWithImageView:imageView];
}

@end
