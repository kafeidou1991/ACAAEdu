//
//  AERequestTool.m
//  ACAAEdu
//
//  Created by 张竟巍 on 2018/2/6.
//  Copyright © 2018年 ACAA. All rights reserved.
//

#import "AENetworkingTool.h"
#import "NSString+MD5Addition.h"
#import "JSONKit.h"

#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define openHttpsSSL NO    // 是否使用ssl验证
#define TIMEOUT_INTERVAL 60
//RSA公钥
static NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCn54Dv6njGvlwMxBQ8FURQcvuficUAs2ZlCWAl4Z+ACLa8a19VJt7Pgkek3Kl+R0z9c2XWRv7AZLsQfKxU6JBqsWsFl1C9Q9/iF3OdJClRtHrLXeAUW77qbLI/TScdKTahmAW7C/3bL2vGvPf13uGL3XOhp7EI1u16YU/pRuj11wIDAQAB";

@interface AENetworkingTool ()
@property (nonatomic, strong) dispatch_group_t dispathGroup;    //实现异步请求同步回调
@property (nonatomic, copy) RequestSuccessBlock success;
@property (nonatomic, copy) RequestFailureBlock faile;
@end

@implementation AENetworkingTool

-(instancetype)init {
    if (self = [super init]) {
        _info = [[AEHttpInfo alloc] init];
        self.dispathGroup = dispatch_group_create();
    }
    return self;
}
+ (void)httpRequestAsynHttpType:(HttpRequestType)type
                     methodName:(NSString *)methodName
                          query:(NSMutableDictionary *)query
                           path:(NSString *)path
                           body:(id)body success:(RequestSuccessBlock)success faile:(RequestFailureBlock)faile{
    AENetworkingTool * tool = [AENetworkingTool new];
    tool.success = [success copy];
    tool.faile = [faile copy];
    [tool request:type methodName:methodName query:query path:path body:body];
}
- (void)request:(HttpRequestType)type
    methodName:(NSString *)methodName
         query:(NSMutableDictionary *)query
          path:(NSString *)path
          body:(id)body {
    [self configAppHttpInfo:type methodName:methodName query:query path:path body:body];
    NSAssert(!STRISEMPTY(self.info.networkDomain) && !STRISEMPTY(self.info.methodName), @"networkDomain,method cann't be nil!");
    NSString *md5Str = [[self sortAscInfo:self.info] stringFromMD5];
    self.info.apiSign = [RSAEncryptor encryptString:md5Str publicKey:publicKey];
    switch (self.info.httpType) {
        case HttpRequestTypeGET:
        {
            NSString *urlStr = [self GETFromatInfo:self.info];
            return [self GETHttpRequestAsynUrl:urlStr methodName:self.info.methodName parameters:self.info.query apiSign:self.info.apiSign];
        }
            break;
        case HttpRequestTypePOST:
        {
            NSString *urlStr = [self basicUrl:self.info];
            return [self POSTHttpRequestAsynUrl:urlStr HttpMethod:@"POST" methodName:self.info.methodName parameters:self.info.query apiSign:self.info.apiSign body:self.info.body];
        }
            break;
        case HttpRequestTypePUT:
        {
            NSString *urlStr = [self GETFromatInfo:self.info];
            return [self POSTHttpRequestAsynUrl:urlStr HttpMethod:@"PUT" methodName:self.info.methodName parameters:self.info.query apiSign:self.info.apiSign body:self.info.body];
        }
            break;
        case HttpRequestTypeDELETE:
        {
            NSString *urlStr = [self basicUrl:self.info];
            return [self POSTHttpRequestAsynUrl:urlStr HttpMethod:@"DELETE" methodName:self.info.methodName parameters:self.info.query apiSign:self.info.apiSign body:self.info.body];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- GET
- (void)GETHttpRequestAsynUrl:(NSString *)url methodName:(NSString *)methodName parameters:(NSDictionary *)parameters apiSign:(NSString *)apiSign{
    dispatch_group_enter(self.dispathGroup);
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [self configHTTPSessionManagerWith:apiSign];
    NSURLSessionDataTask *getDataTask = [manager GET:urlStr parameters:nil
                                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                                NSLog(@"GET:completedUnitCount:%lld,totalUnitCount:%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
                                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                [self requestSuccess:task responseObject:responseObject methodName:methodName];
                                                dispatch_group_leave(self.dispathGroup);
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                [self requestFailure:task error:error methodName:methodName];
                                                dispatch_group_leave(self.dispathGroup);
                                            }];
    [getDataTask resume];
}

#pragma mark -- POST & PUT & DELETE
- (void)POSTHttpRequestAsynUrl:(NSString *)url HttpMethod:(NSString *)method methodName:(NSString *)methodName parameters:(NSDictionary *)parameters apiSign:(NSString *)apiSign body:(id)body{
    dispatch_group_enter(self.dispathGroup);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *responseSerialiazer = [AFJSONResponseSerializer serializer];
    responseSerialiazer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    manager.responseSerializer = responseSerialiazer;
    if (openHttpsSSL) {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    NSMutableURLRequest *requst = [self configSeccsionManagerApiSign:apiSign method:method url:url body:body];
    __block NSURLSessionDataTask *postDataTask = nil;
    postDataTask = [manager dataTaskWithRequest:requst
                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                  dispatch_group_leave(self.dispathGroup);
                                  if (!error) {
                                      [self requestSuccess:postDataTask responseObject:responseObject methodName:methodName];
                                  }else{
                                      [self requestFailure:postDataTask error:error methodName:methodName];
                                  }
                              }];
    [postDataTask resume];
}
- (void)configAppHttpInfo:(HttpRequestType)httpType methodName:(NSString *)methodName query:(NSMutableDictionary *)query path:(NSString *)path body:(id)body{
    _info = [[AEHttpInfo alloc] init];
    self.info.methodName = methodName;
    self.info.httpType = httpType;
    if (!STRISEMPTY(path)) {
        self.info.urlPath = path;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:query];
    [dict setObject:self.info.platform forKey:@"platform"];
    [dict setObject:self.info.timestamp forKey:@"timestamp"];
    self.info.query = [dict copy];
    if (body != nil) {
        self.info.body = body;
    }
}
#pragma mark - 请求成功/失败
- (void)requestSuccess:(NSURLSessionDataTask *)dataTask responseObject:(id)responseObject methodName:(NSString *)methodName{
#ifdef DEBUG
#if TARGET_IPHONE_SIMULATOR
    if ([dataTask.response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
        NSUInteger httpStatusCode = response.statusCode;
        NSString *statusStr = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
        NSLog(@"HTTP状态码:%ld,状态码描述%@",httpStatusCode,statusStr);
    }
#endif
#endif
    if ([dataTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        [self saveCacheApiToken:[allHeaders objectForKey:@"Api-Token"]];
    }
    NSError * error = [self checkIsSuccess:responseObject];
    if (!error) {
        if (_success) {
            _success(responseObject[@"data"]);
        }
    }else {
        if (_faile) {
            _faile(error.code,error.domain);
        }
    }
    NSLog(@"接收消息[%@]---json = \n%@",methodName,[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
}
//检查是否有是正确参数返回
-(id) checkIsSuccess:(id)responseObject
{
    if(responseObject==nil) {
        NSString *str = [NSString stringWithFormat:@"返回数据为空"];
        return [NSError errorWithDomain:str code:0 userInfo:responseObject];
    }
    NSNumber *code = [responseObject objectForKey:@"code"];
    if (code == nil) {
        NSString *str = [NSString stringWithFormat:@"%@ 没有返回正常标识！", responseObject];
        return [NSError errorWithDomain:str code:0 userInfo:responseObject];
    }
    //失败
    if (code.integerValue != 200) {
        NSString * error = [responseObject objectForKey:@"message"];
        if (error == nil) {
            return [NSError errorWithDomain:@"暂无错误数据" code:0 userInfo:responseObject];
        }
        return [NSError errorWithDomain:error code:code.integerValue userInfo:responseObject];
    }
    return nil;
}

- (void)requestFailure:(NSURLSessionDataTask *)dataTask error:(NSError *)error methodName:(NSString *)methodName{
    if (error) {
        NSString *errorStr = error.localizedDescription;
        if (_faile) {
            _faile(error.code,errorStr);
        }
        NSLog(@"Mothed:%@--Error.localizedDescription:%@,code :%ld",methodName,errorStr,(long)error.code);
    }
}
#pragma mark - http header
- (AFHTTPSessionManager *)configHTTPSessionManagerWith:(NSString *)apiSign{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (openHttpsSSL) {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:apiSign forHTTPHeaderField:@"Api-Sign"];
    [requestSerializer setValue:[self readCacheApiToken] forHTTPHeaderField:@"Api-Token"];
    requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
    manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerialiazer = [AFJSONResponseSerializer serializer];
    responseSerialiazer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    manager.responseSerializer = responseSerialiazer;
#ifdef DEBUG
//    NSLog(@"httpHeader %@",manager.requestSerializer.HTTPRequestHeaders);
#endif
    return manager;
}

- (NSMutableURLRequest *)configSeccsionManagerApiSign:(NSString *)apiSign method:(NSString *)method url:(NSString *)url body:(id)body{
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:url parameters:nil error:nil];
    req.timeoutInterval= TIMEOUT_INTERVAL;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:[self readCacheApiToken] forHTTPHeaderField:@"Api-Token"];
    [req setValue:apiSign forHTTPHeaderField:@"Api-Sign"];
    if (body != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
                                                           options:0
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
#ifdef DEBUG
    NSLog(@"参数 %@\n",body);
#endif
    return req;
}
#pragma mark -- Domain&Path
- (NSString *)basicUrl:(AEHttpInfo *)info{
    NSMutableString *urlStr = [NSMutableString stringWithString:info.networkDomain];
    [urlStr appendString:info.methodName];
    if (!STRISEMPTY(info.urlPath)) {
        [urlStr appendString:[NSString stringWithFormat:@"/%@",info.urlPath]];
    }
    [urlStr appendString:[NSString stringWithFormat:@"%@=%@",@"?timestamp",info.timestamp]];
    [urlStr appendString:[NSString stringWithFormat:@"&%@=%@",@"platform",info.platform]];
    return urlStr;
}
#pragma mark -- 拼接GET链接
- (NSString *)GETFromatInfo:(AEHttpInfo *)info{
    NSArray *allKeys = [info.query allKeys];
    NSArray *sortKeyArr = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArr = [NSMutableArray array];
    for (NSString *categoryId in sortKeyArr) {
        [valueArr addObject:[info.query objectForKey:categoryId]];
    }
    NSMutableArray *sortAllArr = [NSMutableArray array];
    for (int i=0;i<sortKeyArr.count;i++) {
        NSString *keyStr = sortKeyArr[i];
        NSString *strSub;
        if (![keyStr isEqualToString:@"timestamp"] && ![keyStr isEqualToString:@"platform"]) {
            strSub = [NSString stringWithFormat:@"%@=%@",sortKeyArr[i],valueArr[i]];
        }else{
            continue;
        }
        [sortAllArr addObject:strSub];
    }
    if (!kArrayIsEmpty(sortAllArr)) {
        NSMutableString *allStr = [[sortAllArr componentsJoinedByString:@"&"] mutableCopy];
        NSString *urlStr = [NSString stringWithFormat:@"%@&%@",[self basicUrl:info],allStr];
        NSLog(@"httpUrl: %@",urlStr);
        return urlStr;
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@",[self basicUrl:info]];
        NSLog(@"httpUrl: %@",urlStr);
        return urlStr;
    }
}

#pragma mark -- 参数body排序
- (NSString *)sortAscInfo:(AEHttpInfo *)info{
    NSMutableDictionary *allDict = [NSMutableDictionary dictionaryWithDictionary:info.query];
    if (info.body != nil) {
        [allDict setValue:info.body forKey:@"body"];
    }
    NSArray *allKeys = [allDict allKeys];
    NSArray *sortKeyArr = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArr = [NSMutableArray array];
    for (NSString *categoryId in sortKeyArr) {
        [valueArr addObject:[allDict objectForKey:categoryId]];
    }
    NSMutableArray *sortAllArr = [NSMutableArray array];
    for (int i=0;i<sortKeyArr.count;i++) {
        NSString *key = sortKeyArr[i];
        id value = valueArr[i];
        NSString *strSub = nil;
        if ([key isEqualToString:@"body"]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value
                                                               options:0
                                                                 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
//            strSub = [NSString stringWithFormat:@"\"%@\":%@",key,jsonString];
            //此处需要将json进行转义 否则会匹配不成功
            strSub = [NSString stringWithFormat:@"\"%@\":%@",key,[jsonString JSONString]];
            
        }else{
            strSub = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        }
        [sortAllArr addObject:strSub];
    }
    NSMutableString *allStr = [[sortAllArr componentsJoinedByString:@","] mutableCopy];
    [allStr insertString:@"{" atIndex:0];
    [allStr insertString:@"}" atIndex:allStr.length];
    NSString *url = [allStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *paraStr = [url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return paraStr;
}
#pragma 储存token
-(void) saveCacheApiToken:(NSString *)apitoken {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: apitoken forKey:@"token"];
    [defaults synchronize];
}
-(NSString *)readCacheApiToken {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *content = [defaults objectForKey:@"token"];
    return content;
}

#pragma mark Https SSL证书适配
- (AFSecurityPolicy*)customSecurityPolicy{
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ssl" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
    
    return securityPolicy;
}

- (void)dealloc{
    NSLog(@"%s%@",__func__,NSStringFromSelector(_cmd));
}


@end
