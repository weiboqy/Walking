//
//  NetWorkRequestManager.m
//  Walking
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager




//类方法
+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error{
    
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic finish:finish error:error];
}

//POST请求
- (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errors{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //这个需要设置请求的 基本参数 需要加判断
    if (type == POST) { //这个是 枚举
        request.HTTPMethod = @"POST";
        //这个参数可能没有所以要加判断
        if (parDic.count > 0) {
            NSData *data = [self parDicToDataWithDic:parDic];
            [request setHTTPBody:data];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //得到的 数据传给 Block
        if (data) {
            finish(data);
        }else{
            errors(error);
        }
    }];
    [task resume];
}

//把参数字典转为POST请求所需要的参数体
- (NSData *)parDicToDataWithDic:(NSDictionary *)dic {
    
    NSMutableArray *array = [NSMutableArray array];
    //遍历字典得到每一个键，得到所有的 Key＝Value类型的字符串
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:str];
    }
    //数组里所有Key＝Value的字符串通过&符号连接
    NSString *parString = [array componentsJoinedByString:@"&"];
//    WKLog(@"%@", parString);
    return [parString dataUsingEncoding:NSUTF8StringEncoding];
}




@end
