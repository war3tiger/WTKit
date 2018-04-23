//
//  ViewControllerSocket.m
//  socketClient
//
//  Created by zyh on 2017/12/24.
//  Copyright © 2017年 SOHU. All rights reserved.
//
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>

#import "ViewControllerSocket.h"

#define BUFFSIZE 32
static int clientSocket = 0;

@interface ViewControllerSocket ()

@property (nonatomic, copy) NSString *ipUrl;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableString *showText;

@end

@implementation ViewControllerSocket

- (instancetype)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        self.ipUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 30, 60, 30);
    [button setTitle:@"back" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 30, 60, 30);
    [button setTitle:@"disconnect" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(closeSocketClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, self.view.frame.size.height - 80)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.textView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.showText = [[NSMutableString alloc] init];
        if (clientSocket <= 0) {
            [self.showText appendString:@"正在创建socket\n"];
            
            [self showMessage];
            clientSocket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (clientSocket < 0) {
                [self.showText appendString:@"创建socket失败\n"];
            } else {
                [self.showText appendString:@"创建socket成功，建立连接\n"];
            }
            [self showMessage];
            
            struct sockaddr_in socketAddr;
            memset(&socketAddr, 0, sizeof(socketAddr));
            socketAddr.sin_family = AF_INET;
            socketAddr.sin_addr.s_addr = inet_addr("192.168.1.107");
            socketAddr.sin_port = htons(1024);
            if (connect(clientSocket, &socketAddr, sizeof(socketAddr)) < 0) {
                [self.showText appendString:@"socket连接失败\n"];
            } else {
                [self.showText appendFormat:@"socket连接成功，开始发送数据\n"];
            }
            [self showMessage];
        }
        
//        char *str = [@"This is a test!" UTF8String];
//        int sendLen = strlen(str);
//        if (send(clientSocket, str, sendLen, 0) != sendLen) {
//            [self.showText appendString:@"发送数据失败\n"];
//        } else {
//            [self.showText appendString:@"发送数据成功\n"];
//        }
//        [self showMessage];
    });
}

- (void)showMessage
{
    if ([NSThread isMainThread]) {
        self.textView.text = self.showText;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textView.text = self.showText;
        });
    }
}

- (void)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeSocketClick:(id)sender
{
    close(clientSocket);
    clientSocket = 0;
}

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

@end
