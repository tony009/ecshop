//
//  H5ViewController.m
//  ecshop
//
//  Created by 吴狄 on 2017/3/6.
//  Copyright © 2017年 jsyh. All rights reserved.
//

#import "H5ViewController.h"

#import "AppDelegate.h"

#import "UserGuideViewController.h"
#import "SettingGesturePasswordViewController.h"


#import "OrderModel.h"
#import "GestureModel.h"
#import "Util.h"
#import "WXApiManager.h"

#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayApiManager.h"

#import "Util.h"
#import "NSString+Common.h"
#import "SettingManager.h"

@interface H5ViewController ()<UIWebViewDelegate,WXApiManagerDelegate,AlipayApiManagerDelegate,SettingGesturePasswordViewControllerDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UIView *netErrorView;

@property (nonatomic,strong) OrderModel *myOrderModel;


@property (nonatomic)  NSMutableURLRequest *lastRequst;


@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self request_Get_AppVersion_InAppStore];
    
    [self request_Set_Session];
    
    
    NSURLCache *urlCache = [[NSURLCache alloc]initWithMemoryCapacity:4 * 1024 *1024 diskCapacity:20 *1024 * 1024 diskPath:nil];
    
    [NSURLCache setSharedURLCache:urlCache];
    
    [self initViews];
    
    [WXApiManager sharedManager].delegate = self;
    [AlipayApiManager sharedManager].delegate = self;
    
}


-(UIView *)netErrorView{
    
    if (_netErrorView ==nil) {
        
        
        _netErrorView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _netErrorView.backgroundColor = [UIColor whiteColor];
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 200, 20)];
        label.text = @"啊哦，网络不太顺畅哦~";
        label.textAlignment = NSTextAlignmentCenter;
        //[label sizeToFit];
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, 120, 140, 40)];
        
        NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:@"重新加载" attributes:@{
                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                                          NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                          }];
        
        [button setAttributedTitle:attributedStr forState:UIControlStateNormal];
    
        
        [button addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [button setBackgroundImage:[Util imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        
        [aView addSubview:button];
        [aView addSubview:label];
        
        aView.center = _netErrorView.center;
    
        [_netErrorView addSubview:aView];
        
        [self.view addSubview:_netErrorView];
        
        _netErrorView.hidden = YES;
        
    }
    return _netErrorView;
}



//重新加载
-(void)reloadAction{
    
    [self.webView loadRequest:self.lastRequst];
    
}

-(void)request_Get_AppVersion_InAppStore{
    
    
    [[Ditiy_NetAPIManager sharedManager]request_VersionOfAppInAppStore:kAppId andBlock:^(id data, NSError *error) {
        
        
        DebugLog(@"version:%@",data[@"results"][0][@"version"]);
        
        
        NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
        
        NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
        
        NSString *iosVersion =  data[@"results"][0][@"version"];
        
        NSString *iosDownload = @"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8";
        
        if ([iosVersion compare:localVersion] == NSOrderedDescending ) {
            
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:[NSString stringWithFormat:@"检测到有新版本:v%@ \n",iosVersion] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // itms-apps://itunes.apple.com/cn/app/wang-yi-yun-yin-le-pao-bufm/id590338362?mt=8
                NSURL *url = [NSURL URLWithString:iosDownload];
                [[UIApplication sharedApplication] openURL:url];
            
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
            }];
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }
        
        
    }];
    
}



-(void)showUserGuiderVC{
    
    UserGuideViewController *ugVC = [UserGuideViewController new];
    
    
    [self addChildViewController:ugVC];
    
    
    [self.view addSubview:ugVC.view];
    
    
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)backAction{
    
    [self.webView goBack];
    
    
}


//[NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php"]

//#define kURL_Base  @"http://sitmarket.ditiy.com"
//#define kURL_Base  @"http://www.fxj2017.com"
//http://sitmarket.ditiy.com/mobile/weixinpay.php?out_trade_no=915


#define kURL_Index [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/"] //首页地址
//kURL_Base

#define kURL_Order_Submit [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/flow.php?step=checkout"] //立即购买

//需要添加is_app=y的链接  -- start

#define kURL_Order_Finished [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/flow.php?step=done"] //提交订单成功
#define kURL_Order_Finished2  [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/flow.php?step=checkout?is_app="]

#define kURL_My_Share  [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/v_user.php"] //我的分享
//需要添加is_app=y的链接  -- end

#define kURL_Order_PayWithWeixin [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/weixinpay.php?out_trade_no="] //微信支付 （包含）
#define kURL_Order_PayWithAlipay [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/pay/alipayapi.php?out_trade_no="] //支付宝支付 (包含)


#define kURL2 [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php"]

#define kURL_Order_PayFromUnpay [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php?act=order_detail&order_id"] // 代付款里面进入支付


#define kURL_UserLogin_Finish [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php?is_app="] //登录成功或失败跳转链接

#define kURL_UserUnlogin [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php?act=logout"] //退出完成


#define kURL_User_Set_GesturePassword [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/v_user_set_pattern_lock.php"] //用户设置手势密码


#define kURL_User_My [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/user.php"] //我的页面



//http://sitmarket.ditiy.com/admin/wxScanQrCode.php
#define kURL_ShareSettle_我要付款 [NSString stringWithFormat:@"%@%@",kURL_Base,@"/admin/wxScanQrCode.php"] //我要付款


//http://sitmarket.ditiy.com/mobile/space_station_offline_store.php?act=payconfirm

#define kURL_ShareSettle_确认支付 [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/space_station_offline_store.php?act=payconfirm"] //确认支付

#define kURL_ShareSettle_立即支付 [NSString stringWithFormat:@"%@%@",kURL_Base,@"/mobile/space_station_offline_store.php?act=paydone"] //立即支付


//http://sitmarket.ditiy.com/mobile/wwhl_xf_pay_submit.php

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    NSLog(@"shouldStartLoadWithRequest-----");
    
    self.lastRequst = request;
    
    NSMutableString *urlStr = [NSMutableString stringWithString:request.URL.absoluteString];
    
    NSLog(@"urlStr:%@",urlStr);
    
    
    if ([urlStr containsString:kURL_Order_PayFromUnpay] && [urlStr hasSuffix:@"is_pay=1"]) {
        
        
        _myOrderModel = [OrderModel new];
        
        NSString *payType  = [webView stringByEvaluatingJavaScriptFromString:@"get_pay_type_for_app()"];
        
        
        NSLog(@"get_pay_type_for_app():%@",payType);
        
        if ([payType isEqualToString:@""]) {
            
            return NO;
        }
        
        
        if ([payType isEqualToString:@"weixin"]) {
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithWeChat];
            
        }else if ([payType isEqualToString:@"alipay"]){
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithAlipay];
            
        }else{
            
            
            return YES;
            
        }
        
        
        _myOrderModel.order_id = [[Util getURLParameters:urlStr] objectForKey:@"order_id"];
        
        
        [self request_PayOrder_AppH5];
        
        return NO;
        
    }else if([urlStr isEqualToString:kURL_Order_Submit] || [urlStr isEqualToString:kURL_Order_Finished2] || [urlStr isEqualToString:kURL_My_Share] ||  [urlStr isEqualToString:kURL_ShareSettle_确认支付]) {
        

        if ([[[urlStr componentsSeparatedByString:@"/"]lastObject]containsString:@"?"]) {
            
            [urlStr appendString:@"&is_app=y"];
            
        }else{
            
            [urlStr appendString:@"?is_app=y"];
            
        }
        
        NSLog(@"urlStr-加参数:%@",urlStr);
        
        NSMutableURLRequest *mRequest = (NSMutableURLRequest *)request;
        
        [mRequest setURL:[NSURL URLWithString:urlStr]];
        
        
        [webView loadRequest:mRequest];
        
        return NO;
        
    }else  if([urlStr containsString:kURL_Order_PayWithWeixin] || [urlStr containsString:kURL_Order_PayWithAlipay]) {
        
        
        NSString *orderIdAndPayType = [_webView stringByEvaluatingJavaScriptFromString:@"get_order_id_for_app()"];
        NSLog(@"get_order_id_and_paytype_for_app %@", orderIdAndPayType);
        
        if ([orderIdAndPayType isEqualToString:@""]) {
            
            DebugLog(@"%@",@"orderIdAndPayType isEqualToString:@\"\"");
            return NO;
        }
        
        //微信支付，支付宝
        
        NSArray *arrayData = [orderIdAndPayType componentsSeparatedByString:@"_"];
        
        
        NSLog(@"%@,%@",arrayData[0],arrayData[1]);
        
        
        self.myOrderModel.order_id = arrayData[0];
        
        
        if ([arrayData[1] isEqualToString:@"微信APP"]) {
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithWeChat];
            
        }else if ([arrayData[1] isEqualToString:@"支付宝APP"]){
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithAlipay];
            
        }
        
        // 获取当前页面的标题
        NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSLog(@"title %@", title);
        
        
        [self request_PayOrder_AppH5];
        
        
        //        WS(ws)
        //        [[Ditiy_NetAPIManager sharedManager]request_PayOrder_AppH5_WithPayType:[_myOrderModel.payType intValue] Params:[_myOrderModel toPayOrderH5Params] andBlock:^(id data, NSError *error) {
        //
        //
        //            //[ws.myOrderModel.payType intValue] == PayWithWeChat
        //
        //
        //            NSLog(@"ws.myOrderModel.payType:%d, PayWithWeChat:%d ",[ws.myOrderModel.payType intValue],PayWithWeChat);
        //
        //
        //
        //            if(data && [ws.myOrderModel.payType intValue] == PayWithWeChat){
        //
        //                NSLog(@"微信支付");
        //
        //                [ws sendWechatPay:data];
        //            }else if (data && [ws.myOrderModel.payType intValue] == PayWithAlipay){
        //
        //                NSLog(@"支付宝支付");
        //
        //                [ws sendAlipay:data];
        //
        //
        //            }
        //
        //        }];
        
        
        return NO;
        
        
    }else if ([urlStr isEqualToString:kURL_User_Set_GesturePassword]){//设置手势密码
        
//        
//        SettingGesturePasswordViewController *vc = [SettingGesturePasswordViewController new];
//        
//        
//
//        [self presentViewController:vc animated:YES completion:nil];
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        SettingGesturePasswordViewController *sgpVC = [SettingGesturePasswordViewController new];
        //sgpVC.automaticallyAdjustsScrollViewInsets = NO;
        sgpVC.delegate = self;
        sgpVC.promptStr = @"设置手势密码";
        
        
        UINavigationController *nc =[[UINavigationController alloc]initWithRootViewController:sgpVC];
        
        [self presentViewController:nc animated:YES completion:nil];
        
        //[self.navigationController pushViewController:sgpVC animated:YES];
        
        return NO;
        
    }else if ([urlStr isEqualToString:kURL_User_My] && [LoginModel isLogin]){
        
        AppDelegate *appDelegate   =(AppDelegate *) [UIApplication sharedApplication].delegate;
        
        //appDelegate
        
        if ([[SettingManager sharedManager]gestureLock] && ![[SettingManager sharedManager].gesturePassword isEmptyStr]) {
            
            [appDelegate.lockWindow makeKeyAndVisible];
            
        }
        
        return YES;
    }else if ([urlStr isEqualToString:kURL_ShareSettle_我要付款]){ //我要付款
        
        [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
        
//        QRCodeScanningVC *vc = [QRCodeScanningVC new];
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
        
        // 1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        });
                        
                        SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                        // 用户第一次同意了访问相机权限
                        SGQRCodeLog(@"用户第一次同意了访问相机权限");
                        
                    } else {
                        
                        // 用户第一次拒绝了访问相机权限
                        SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                    }
                }];
            } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"因为系统原因, 无法访问相册");
            }
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    
//        NSString *url = @"http://sitmarket.ditiy.com/mobile/space_station_offline_store.php?act=payinfo&suppid=148";
//        
//        [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]]];
//        
        
        return NO;
        
    }
    return  true;
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    SGQRCodeLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    if ([string hasPrefix:@"http"]) {
        [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:string]]];
        
    } else { // 扫描结果为条形码
//        
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_bar_code = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

-(void)initViews{
    
    
    self.myOrderModel = [OrderModel new];
    
    //    UIImage *backButtonImage = [UIImage imageNamed:@"nav_arrow.png"];
    //
    //
    //    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    //
    //    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    //
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, rectStatus.size.height, kScreenWidth, kScreenHeight - rectStatus.size.height)];
    
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_webView];
    
    
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:kURL_Index]]];
    
    
    
}

-(void)request_Set_Session{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *path = [NSString stringWithFormat:@"%@/mobile/api_set_session.php?key=is_app&value=y",baseURLStr];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSString *result = [NSString stringWithCString:responseObject encoding:NSUTF8StringEncoding];
        
        NSData *data = responseObject;
        

        NSString *result = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%s:%@",__func__,result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
    
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.netErrorView.hidden = YES;
    
    //NSLog(@"webViewDidStartLoad-----@%",[NSString stringWithFormat:@"%@%@",kURL_Base,kURL_Order_Submit]);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    NSLog(@"webViewDidFinishLoad-----");
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //[MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    
    NSString *urlStr = webView.request.URL.absoluteString;
    
    if ([urlStr isEqualToString:kURL_UserLogin_Finish]){  //登录
        
        NSString *userID = [_webView stringByEvaluatingJavaScriptFromString:@"get_user_id_for_app()"];
        
        
        if (![userID isEmptyStr]) {
            
            
            NSLog(@"userID:%@",userID);
            
            
            GestureModel *model = [GestureModel new];
            
            model.user_id = userID;
     
            
            [[Ditiy_NetAPIManager sharedManager]request_UserInfoWithUserID:userID andBlock:^(id data, NSError *error) {
               
                
                
                UserModel *userModel = [UserModel mj_objectWithKeyValues:data[@"data"][0]];
                userModel.user_id = userID;
                
                [LoginModel doLogin:[userModel mj_keyValues]];
                
                
            }];
            
            
            
           [[Ditiy_NetAPIManager sharedManager]request_H5_FetchGestureCode_WithParams:[model toH5FetchGestureCodeParams] andBlock:^(id data, NSError *error) {
              
               
               if (data) {
                   
                   
                   NSString *password = [Util tripleDES_Decrypt:data[@"msg"] withKey:k3DES_Ditiy_Key];
                   
                   
                   
                   if (password) {
                    
                       [[SettingManager sharedManager] setGesturePassword:password];
                       [[SettingManager sharedManager] setGestureLock:true];
                   }
                   
                   
               }else{
                   
                   [[SettingManager sharedManager] setGesturePassword:@""];
                   [[SettingManager sharedManager] setGestureLock:false];
                   
               }
               
               
           }];
            
        }
        
        
    }else if ([urlStr isEqualToString:kURL_UserUnlogin]){ //退出
        
        
        [LoginModel doLogout];
        [[SettingManager sharedManager] setGesturePassword:@""];
        [[SettingManager sharedManager] setGestureLock:false];
        
        
        
    }else if([urlStr isEqualToString:kURL_ShareSettle_立即支付]){ //分享结算 立即支付
        
        
        
        NSString *orderIdAndPayType = [_webView stringByEvaluatingJavaScriptFromString:@"get_station_order_id_for_app()"];
        NSLog(@"get_order_id_and_paytype_for_app %@", orderIdAndPayType);
        
        
        if([orderIdAndPayType isEqualToString:@""]){
            
            return;
        }
        
        //微信支付，支付宝
        
        NSArray *arrayData = [orderIdAndPayType componentsSeparatedByString:@"_"];
        
        
        NSLog(@"%@,%@",arrayData[0],arrayData[1]);
        
        
        self.myOrderModel = [OrderModel new];
        self.myOrderModel.typeStr = @"共享结算";
        
        self.myOrderModel.order_id = arrayData[0];
        
        
        if ([arrayData[1] isEqualToString:@"微信APP"]) {
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithWeChat];
            
        }else if ([arrayData[1] isEqualToString:@"支付宝APP"]){
            
            _myOrderModel.payType = [NSString stringWithFormat:@"%d",PayWithAlipay];
            
        }else{
            
            return;
        }
        
        
        
        // 获取当前页面的标题
        NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSLog(@"title %@", title);
        
        
        [self request_PayOrder_AppH5];
        
        
        //return NO;
        
        
        
    }
    

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    //NSLog(@"%@",error);
    
    NSLog(@"didFailLoadWithError-----%@",error);
    
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (error.code == -1009) { //似乎已断开与互联网的连接
        
       // [MBProgressHUD showMessage:@"网络已经断开" toView:webView];
        
        
        self.netErrorView.hidden = NO;
    }
    
    
}


//request_PayOrder_AppH5_WithPayType

//请求服务端支付接口
-(void)request_PayOrder_AppH5{
    
    
    if ([_myOrderModel.payType intValue] == PayWithWeChat && ![WXApi isWXAppInstalled]) {
        
        
        [MBProgressHUD showError:@"请安装微信后使用微信支付"];
        
        return;
        
    }
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(ws)
    [[Ditiy_NetAPIManager sharedManager]request_PayOrder_AppH5_WithPayType:[_myOrderModel.payType intValue] Params:[_myOrderModel toPayOrderH5Params] andBlock:^(id data, NSError *error) {
        

        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        if (data) {
            
            
            if([ws.myOrderModel.payType intValue] == PayWithWeChat){
                
                NSLog(@"调用微信支付");
                [ws sendWechatPay:data];
                
            }else if ([ws.myOrderModel.payType intValue] == PayWithAlipay){
                
                NSLog(@"调用支付宝支付");
                
                [ws sendAlipay:data];
                
            }
            
            
        }
        
        
    }];
    
}

-(void)sendWechatPay:(id)data{
    
    
    
    PayReq *request = [[PayReq alloc] init];
    
    request.openID = data[@"data"][@"appid"];
    
    /** 商家向财付通申请的商家id */
    request.partnerId = data[@"data"][@"mch_id"];
    /** 预支付订单 */
    request.prepayId= data[@"data"][@"prepay_id"];
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = @"Sign=WXPay";
    /** 随机串，防重发 */
    request.nonceStr= data[@"data"][@"nonce_str"];
    
    // 将当前时间转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= timeStamp;
    
    /** 时间戳，防重发 */
    request.timeStamp= timeStamp;
    
    // 签名加密
    MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
    
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign=[md5 createMD5SingForPay:request.openID
                                partnerid:request.partnerId
                                 prepayid:request.prepayId
                                  package:request.package
                                 noncestr:request.nonceStr
                                timestamp:request.timeStamp];
    /*! @brief 发送请求到微信，等待微信返回onResp
     *
     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
     * SendAuthReq、SendMessageToWXReq、PayReq等。
     * @param req 具体的发送请求，在调用函数后，请自己释放。
     * @return 成功返回YES，失败返回NO。
     */
    [WXApi sendReq: request];
    
    
}


-(void)sendAlipay:(id)data{
    
    
    NSString * orderStr=data[@"data"];
    NSString *appScheme = @"alisdk123";
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        
        if([resultDic[@"resultStatus"]intValue] == 9000){ //成功
            
            //[MBProgressHUD showSuccess:@"购买成功"];
            
            [self UpdatePayResultSuccess:YES];
            
        }else if([resultDic[@"resultStatus"] intValue] == 6001) //用户取消
        {
            
            if ([self.myOrderModel.typeStr isEqualToString:@"共享结算"]) {
                
                [self UpdatePayResultSuccess:NO];
                
            }else{
                
                [MBProgressHUD showError:@"用户取消支付"];
                
            }
            
            
            
        }else{
            
            [MBProgressHUD showError:resultDic[@"memo"]];
            [self UpdatePayResultSuccess:NO];
        }
        
    }];
    
    
}

-(void)UpdatePayResultSuccess:(Boolean)success{
    
    NSString *path = [NSString stringWithFormat:@"%@/mobile/api_weixin_paysuccess.php",baseURLStr];
    
    
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    
    [mRequest setHTTPMethod:@"POST"];
    
    
    //    NSDictionary *values = @{
    //                             @"order_id":_myOrderModel.order_id,
    //                             @"pay_result":@"00"
    //                             };
    //891
    //    NSString *order_id = [[NSString stringWithFormat:@"order_id=%@",_myOrderModel.order_id]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *pay_result = [[NSString stringWithFormat:@"pay_result=00"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *pay_type = [[NSString stringWithFormat:@"pay_type=微信"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //
    //                    NSMutableData *postData = [NSMutableData new];
    //
    //                    postData appendBytes:<#(nonnull const void *)#> length:<#(NSUInteger)#>
    //_myOrderModel.order_id
    
    
    
    NSString *pay_type = [_myOrderModel.payType intValue] == PayWithAlipay ? @"支付宝":@"微信";
    NSString *pay_result = success ? @"00":@"11";
    
    NSString *valueStr = [[NSString stringWithFormat:@"order_id=%@&pay_result=%@&pay_type=%@",_myOrderModel.order_id,pay_result,pay_type]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *postData = [valueStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //                        [mRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    
    // values dat
    
    
    [mRequest setHTTPBody:postData];
    
    
    [_webView loadRequest:mRequest];
    
}


-(void)managerDidReceivePayResponse:(PayResp *)resp{
    
    NSString *strMsg;
    
    
    switch (resp.errCode) {
        case WXSuccess:{
            
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
            
            [self UpdatePayResultSuccess:YES];
            
            
            break;
            
        }
        case WXErrCodeUserCancel:{
            
            
            if ([self.myOrderModel.typeStr isEqualToString:@"共享结算"]) {
                
                [self UpdatePayResultSuccess:NO];
                
            }else{
                
                [MBProgressHUD showError:@"用户取消支付"];
                
            }
            
            break;
        }
            
        default:
            
            
            
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            
            [self UpdatePayResultSuccess:NO];
            break;
    }
    
    
}

-(void)alipayApiManagerDidReceivePayResponse:(NSDictionary *)response{
    
    
    if([response[@"resultStatus"]intValue] == 9000){
        
        //[MBProgressHUD showSuccess:@"购买成功"];
        
        [self UpdatePayResultSuccess:YES];
        
    }else if([response[@"resultStatus"] intValue] == 6001) //用户取消
    {
        
        if ([self.myOrderModel.typeStr isEqualToString:@"共享结算"]) {
            
            [self UpdatePayResultSuccess:NO];
            
        }else{
            
            [MBProgressHUD showError:@"用户取消支付"];
            
        }
        
        
        
    }else{
        
        [MBProgressHUD showError:response[@"memo"]];
        [self UpdatePayResultSuccess:NO];
    }
    
    
    
}


#pragma mark -- SettingGesturePasswordViewControllerDelegate

-(void)settingGesturePasswordViewController:(SettingGesturePasswordViewController *)vc didFinishSettingWithPassword:(NSString *)password{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
