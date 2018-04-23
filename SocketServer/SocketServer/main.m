//
//  main.m
//  SocketServer
//
//  Created by zyh on 2017/12/23.
//  Copyright © 2017年 SOHU. All rights reserved.
//
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>
#import <Foundation/Foundation.h>

#define MAXPENDING 5    /* Max connection requests */
#define BUFFSIZE 32

void handleClient(int sock) {
    char buffer[BUFFSIZE];
    int received = -1;
    printf("receive data start\n");
    memset(buffer, 0, BUFFSIZE);
    if ((received = recv(sock, buffer, BUFFSIZE, 0)) < 0) {
        printf("received fail!\n");
    } else {
        printf("received success len:%d, content:%s\n", received, buffer);
        while (received > 0) {
            memset(buffer, 0, BUFFSIZE);
            if ((received = recv(sock, buffer, BUFFSIZE, 0)) < 0) {
                printf("received fail again!\n");
            } else {
                printf("received success again len:%d, content:%s\n", received, buffer);
                if (received < 30) {
                    printf("receive data end\n");
                    close(sock);
                }
            }
        }
    }
//    printf("receive data end\n");
//    close(sock);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int serverSocket, clientSocket;
        struct sockaddr_in server, client;
        serverSocket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
        if (serverSocket >= 0) {
            printf("socket server create success!\n");
        } else {
            printf("socket server create fail!\n");
        }
        memset(&server, 0, sizeof(server));
        server.sin_family = AF_INET;
        server.sin_addr.s_addr = htonl(INADDR_ANY);
        server.sin_port = htons(1024);
        
        if (bind(serverSocket, &server, sizeof(server)) < 0) {
            printf("socket server bind fail!\n");
        } else {
            printf("socket server bind success!\n");
        }
        
        if (listen(serverSocket, MAXPENDING) < 0) {
            printf("listen fail!\n");
        } else {
            printf("listen success\n");
        }
        
        while (1) {
            unsigned int clientLen = sizeof(client);
            printf("accept start\n");
            if ((clientSocket = accept(serverSocket, &client, &clientLen)) < 0) {
                printf("accept fail!!\n");
            } else {
                printf("accept success!\n");
            }
            
            handleClient(clientSocket);
        }
    }
    return 0;
}
