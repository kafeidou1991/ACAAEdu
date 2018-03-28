//
//  AEPurchaseManage.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/3/15.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AEPurchaseManage.h"
#import <StoreKit/StoreKit.h>

static AEPurchaseManage * manage = nil;
@interface AEPurchaseManage () <SKPaymentTransactionObserver,SKProductsRequestDelegate> {
    NSString *selectProductID;
}

@property (nonatomic,copy) NSString *purchID;
@property (nonatomic,copy) IAPCompletionHandle handle;
@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSDictionary * orderInfoDict; //订单信息

@end

@implementation AEPurchaseManage
@synthesize request;
// MARK: init Purchase

- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
// MARK: 开始内购
- (void)startPurchWithID:(NSDictionary *)orderInfo completeHandle:(IAPCompletionHandle)handle{
    [self showLoading];
    if (orderInfo) {
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            self.orderInfoDict = orderInfo;
            self.purchID = @"com.acaaedu.1";
            self.handle = handle;
            [self requestProductID:self.purchID];
        }else{
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                 message:@"请先开启应用内付费购买功能。"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles: nil];
            [alertError show];
        }
    }
}

-(void)requestProductID:(NSString *)productID{
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc]initWithArray:productIDArray];
    
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
    
}
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
#if DEBUG
        NSLog(@"--------------没有商品------------------");
#endif
        return;
    }
    
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:self.purchID]){
            p = pro;
            break;
        }
    }
    
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[p description]);
    NSLog(@"%@",[p localizedTitle]);
    NSLog(@"%@",[p localizedDescription]);
    NSLog(@"%@",[p price]);
    NSLog(@"%@",[p productIdentifier]);
    NSLog(@"发送购买请求");
#endif
    
    [self buyProduct:p];
}
-(void)buyProduct:(SKProduct *)product{
    
    // 1.创建票据
    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
    
    // 3.添加观察者，监听用户是否付钱成功(不在此处添加观察者)
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}


// MARK: SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}

// MARK: 结果处理
// 成功交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
#ifdef DEBUG
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
#else
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
#endif
}
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    [self closeLoding];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:kIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:kIAPPurchCancle data:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)handleActionWithType:(IAPPurchType)type data:(NSData *)data{
    NSString * tipStr =@"";
    switch (type) {
        case kIAPPurchSuccess:
            NSLog(@"购买成功");
            tipStr = @"购买成功";
            break;
        case kIAPPurchFailed:
            NSLog(@"购买失败");
            tipStr = @"购买失败";
            break;
        case kIAPPurchCancle:
            NSLog(@"用户取消购买");
            tipStr = @"取消购买";
            break;
        case KIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            tipStr = @"订单校验失败";
            break;
        case KIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            tipStr = @"购买成功";
            break;
        case kIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
            tipStr = @"不允许程序内付费";
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.handle){
            self.handle(type,data);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (type != kIAPPurchSuccess) {
                [AEBase alertMessage:tipStr cb:nil];
            }
        });
    });
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
#if DEBUG
    NSLog(@"------------------错误-----------------:%@", error);
#endif
}

- (void)requestDidFinish:(SKRequest *)request{
#if DEBUG
    NSLog(@"------------反馈信息结束-----------------");
#endif
}

//MARK: 购买成功验证凭据
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
//    [self closeLoding];
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:KIAPPurchVerFailed data:nil];
        return;
    }
    //验证凭据
    WS(weakSelf);
    NSDictionary * prama = @{};
    if (flag) {
        prama = @{@"sandbox": @"1",@"orders_no":weakSelf.orderInfoDict[@"orders_no"],@"total_amount":weakSelf.orderInfoDict[@"price"],@"apple_receipt":[receipt base64EncodedStringWithOptions:0]};
    }else {
        prama = @{@"orders_no":weakSelf.orderInfoDict[@"orders_no"],@"total_amount":weakSelf.orderInfoDict[@"price"],@"apple_receipt":[receipt base64EncodedStringWithOptions:0]};
    }
    //验证凭据，验证成功就代表购买成功
    [AENetworkingTool httpRequestAsynHttpType:HttpRequestTypePOST methodName:kValidateReceipt query:nil path:nil body:prama success:^(id object) {
        [weakSelf closeLoding];
        [weakSelf handleActionWithType:kIAPPurchSuccess data:receipt];
    } faile:^(NSInteger code, NSString *error) {
        [weakSelf closeLoding];
        // 无法连接服务器,购买校验失败
        [weakSelf handleActionWithType:KIAPPurchVerFailed data:nil];
    }];
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
//    NSError *error;
//    NSDictionary *requestContents = @{
//                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
//                                      };
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
//                                                          options:0
//                                                            error:&error];
//
//    if (!requestData) { // 交易凭证为空验证失败
//        [self handleActionWithType:KIAPPurchVerFailed data:nil];
//        return;
//    }
//
//    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
//    if (flag) {
//        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
//    }
//    NSURL *storeURL = [NSURL URLWithString:serverString];
//    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
//    [storeRequest setHTTPMethod:@"POST"];
//    [storeRequest setHTTPBody:requestData];
//    WS(weakSelf)
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               [self closeLoding];
//                               if (connectionError) {
//                                   // 无法连接服务器,购买校验失败
//                                   [weakSelf handleActionWithType:KIAPPurchVerFailed data:nil];
//                               } else {
//                                   NSError *error;
//                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                   if (!jsonResponse) {
//                                       // 苹果服务器校验数据返回为空校验失败
//                                       [weakSelf handleActionWithType:KIAPPurchVerFailed data:nil];
//                                   }
//
//                                   // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
//                                   NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
//                                   if (status && [status isEqualToString:@"21007"]) {
//                                       [weakSelf showLoading];
//                                       [weakSelf verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
//                                   }else if(status && [status isEqualToString:@"0"]){
//                                       [weakSelf handleActionWithType:KIAPPurchVerSuccess data:nil];
//                                   }
//#if DEBUG
//                                   NSLog(@"----验证结果 %@",jsonResponse);
//#endif
//                               }
//                           }];
    
}

// 恢复购买(主要是针对非消耗产品)
-(void)replyToBuy{
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)dealloc{
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [AEBase hudShowInWindowMsg:@""];
    });
}
- (void)closeLoding {
    dispatch_async(dispatch_get_main_queue(), ^{
        [AEBase hudclose];
    });
}


@end

