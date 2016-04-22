//
//  NetWorkRequestManager.h
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

//封装网络请求
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};
//有参无反 的 Block
typedef void (^RequestFinish)(NSData *data);
typedef void (^RequestError) (NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errors;




@end
