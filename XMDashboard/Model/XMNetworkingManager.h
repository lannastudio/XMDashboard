//
//  XMNetworkingManager.h
//  XMDashboard
//
//  Created by lannastudio on 2025/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseResponseObject;

typedef NS_ENUM(NSInteger, CommonResponseResult) {
    CommonResponseResultSuccess = 200,
    CommonResponseResultFailed = 500,
    CommonResponseResultValidate = 404,
    CommonResponseResultUnauthorized = 401,
    CommonResponseResultForbidden = 403,
};

@interface BaseResponseObject : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic,   copy) NSString *message;
@property (nonatomic, strong) id data;

@end

@interface XMNetworkingManager : NSObject

+ (void)requestWithPath:(NSString *)path
                 params:(NSDictionary *)params
             completion:(void(^)(id respone, BaseResponseObject *responseObject, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
