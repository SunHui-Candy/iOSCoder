//
//  ViewController.m
//  SH_Https
//
//  Created by ios on 16/12/19.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()<NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self sesstionHttpsTest];
    [self afnTest];
}

#pragma mark - AFN的HTTPS请求
- (void)afnTest
{
    
}

#pragma mark - NSURLSession的HTTPS请求
- (void)sesstionHttpsTest
{
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/"];
    NSURLRequest *urlrequest = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"----%@,%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],error);
    }];
    [dataTask resume];
    
    /*
     2016-12-19 13:03:46.391 SH_Https[2624:120291] App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
     2016-12-19 13:03:46.397 SH_Https[2624:120233] ----,Error Domain=NSURLErrorDomain Code=-1022 "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection." UserInfo={NSUnderlyingError=0x60800005b690 {Error Domain=kCFErrorDomainCFNetwork Code=-1022 "(null)"}, NSErrorFailingURLStringKey=http://www.baidu.com/, NSErrorFailingURLKey=http://www.baidu.com/, NSLocalizedDescription=The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.}
     
     */
}

#pragma mark - NSURLSessionDataDelegate
/*
 如果发送的请求是https的,那么才会调用此方法
 challenge,质询,挑战
 */

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    // 如果不是服务器信任就直接return
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"]) {
        return;
    }
    
    // 受保护空间
    NSLog(@"***,,,%@",challenge.protectionSpace);
    
    /**
     NSURLSessionAuthChallengeDisposition 如何处理证书
     
     NSURLSessionAuthChallengeUseCredential = 0, 使用安装证书
     NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认采用的方式,该证书被忽略
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 取消请求,证书忽略
     NSURLSessionAuthChallengeRejectProtectionSpace = 3, 拒绝
     */
    //NSURLCredential 授权信息
    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






