//
//  ViewController.m
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

#import "ViewController.h"

@interface ViewController ()
{
    UITextField *_ipField;
    UITextField *_portField;
    UITextField *_contentField;
    UITextView *_resultTextView;
    
    NSMutableString *_tipString;
    int sockedId;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:gesture];
    
    _ipField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, 150, 30)];
    _ipField.placeholder = @"ip address";
    [self.view addSubview:_ipField];
    
    _portField = [[UITextField alloc] initWithFrame:CGRectMake(200, 20, 150, 30)];
    _portField.placeholder = @"port";
    [self.view addSubview:_portField];
    
    _contentField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 30)];
    _contentField.placeholder = @"content";
    [self.view addSubview:_contentField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"connect" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 100, 60, 30);
    [button addTarget:self action:@selector(connect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"send" forState:UIControlStateNormal];
    button.frame = CGRectMake(80, 100, 60, 30);
    [button addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"close" forState:UIControlStateNormal];
    button.frame = CGRectMake(160, 100, 60, 30);
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"clear" forState:UIControlStateNormal];
    button.frame = CGRectMake(240, 100, 60, 30);
    [button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat offsetY = button.frame.origin.y + button.frame.size.height + 10;
    _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, offsetY, self.view.frame.size.width - 20, self.view.frame.size.height - offsetY)];
    _resultTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_resultTextView];
    _resultTextView.editable = NO;
    
    sockedId = 0;
    _tipString = [NSMutableString string];
}

- (void)tap:(id)sender
{
    [self.view endEditing:YES];
}

- (void)connect:(id)sender
{
    [self tap:nil];
    
    if (sockedId <= 0) {
        [self showTipMessage:@"正在创建socket\n"];
        sockedId = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
        if (sockedId < 0) {
            [self showTipMessage:@"socket创建失败\n"];
            return;
        }
        [self showTipMessage:@"socket创建成功\n"];
    } else {
        [self showTipMessage:@"socket已经创建成功\n"];
    }
    [self showTipMessage:@"socket连接中。。。\n"];
    struct sockaddr_in socketAddr;
    memset(&socketAddr, 0, sizeof(socketAddr));
    socketAddr.sin_family = AF_INET;
    socketAddr.sin_addr.s_addr = inet_addr([_ipField.text UTF8String]);
    socketAddr.sin_port = htons([_portField.text intValue]);
    if (connect(sockedId, &socketAddr, sizeof(socketAddr)) < 0) {
        [self showTipMessage:@"socket连接失败\n"];
    } else {
        [self showTipMessage:@"socket连接成功\n"];
    }
}

-(void)send:(id)sender
{
    [self tap:nil];
    
    char *str = [_contentField.text UTF8String];
    int sendLen = strlen(str);
    if (send(sockedId, str, sendLen, 0) != sendLen) {
        [self showTipMessage:@"发送数据失败\n"];
    } else {
        [self showTipMessage:@"发送数据成功\n"];
    }
}

- (void)close:(id)sender
{
    [self tap:nil];
    close(sockedId);
    sockedId = 0;
    [self showTipMessage:@"socket关闭\n"];
}

- (void)clear:(id)sender
{
    [self tap:nil];
    [_tipString deleteCharactersInRange:NSMakeRange(0, _tipString.length)];
    _resultTextView.text = @"";
}

- (void)showTipMessage:(NSString *)str
{
    [_tipString appendString:str];
    _resultTextView.text = _tipString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
