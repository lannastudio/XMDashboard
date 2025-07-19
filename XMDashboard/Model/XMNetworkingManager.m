//
//  XMNetworkingManager.m
//  XMDashboard
//
//  Created by lannastudio on 2025/7/1.
//

#import "XMNetworkingManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

static NSString * const kProdDomain = @"https://api.xunmengjizhang.com/kitten";

@implementation BaseResponseObject

@end

@implementation XMNetworkingManager

+ (instancetype)sharedInstance {
    static XMNetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMNetworkingManager alloc] init];
    });
    return manager;
}

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;

    });
    return manager;
}

+ (void)requestWithPath:(NSString *)path
                 params:(NSDictionary *)params
             completion:(void (^)(id , BaseResponseObject *, NSError *))completion {
    NSString *finalPath = path;
    if (![finalPath hasPrefix:@"/"]) {
        finalPath = [@"/" stringByAppendingString:path];
    }
    NSString *urlString = [kProdDomain stringByAppendingString:finalPath];
    [self.sessionManager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseResponseObject *rs = nil;
        if (responseObject) {
            rs = [BaseResponseObject mj_objectWithKeyValues:responseObject];
        }
        SafeBlock(completion, responseObject, rs, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        XMLog(@"Error: %@", error);
        SafeBlock(completion, nil, nil, error);
    }];
}

@end
