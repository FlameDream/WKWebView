//
//  ViewController.m
//  WKWebViewTest
//
//  Created by ftimage2 on 2018/9/27.
//  Copyright © 2018年 Jack Wang. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    [btn setTitle:@"WebViewTtn" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btn  addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnAction{
    WKWebViewVC *wkVC = [[WKWebViewVC alloc] init];
    [self.navigationController pushViewController:wkVC animated:true];
}

@end
