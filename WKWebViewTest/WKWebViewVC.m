//
//  WKWebViewVC.m
//  WKWebViewTest
//
//  Created by ftimage2 on 2018/9/27.
//  Copyright © 2018年 Jack Wang. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>
@interface WKWebViewVC ()<WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation WKWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建Request
    NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    // 方法一：
    // WKWebView初始化
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    
    
    // 方法二：（对网页进行相关的配置，下次再详细介绍）
    //    //设置网页的配置文件
    //    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    // 加载请求
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
   
    
    // UIProgressView初始化
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 64, self.webView.frame.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor];
    // 设置进度条的色彩
    self.progressView.progressTintColor = [UIColor magentaColor];
    // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
    [self.progressView setProgress:0.1 animated:YES];
    [self.webView addSubview:self.progressView];
    
    
    //WKwebView 代理方法
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
 
}

// WKNavigationDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"------webView开始加载------");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"-----WebView加载成功-----------");
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"------WebView加载失败 F-----------");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"打印测试进度值：%f", newprogress);
        if (newprogress == 1) { // 加载完成 // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES]; // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
            
        }
        
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) { // 标题
        self.title = self.webView.title;
        
    } else { // 其他
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
}
- (void)dealloc {
    // 最后一步：移除监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}



@end
