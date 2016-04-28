//
//  UserInfoManager.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

/** 创建单例 */
+ (instancetype)defaultManager {
    static UserInfoManager *userInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoManager = [[UserInfoManager alloc]init];
    });
    return userInfoManager;
}

/** 保存用户的auth */
+ (void)conserveUserAuth:(NSString *)userAuth {
    [[NSUserDefaults standardUserDefaults] setObject:userAuth forKey:@"UserAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**获取用户的auth*/
+ (NSString *)getUserAuth {
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAuth"];
    if (auth == nil) {
        return @" ";
    }
    return auth;
}
/** 取消用户的auth */
+ (void)cancelUserAuth {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 保存用户的name */
+ (void)conserveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/** 获取用户的name */
+ (NSString *)getUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if (name == nil) {
        return @" ";
    }
    return name;
}

/** 保存用户的id */
+ (void)conserveUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", userID] forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/** 获取用户的id */
+ (NSString *)getUserID {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (userID == nil) {
        return @" ";
    }
    return userID;
}
+ (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 保存用户的icon */
+ (void)conserveUserIcon:(NSString *)userIcon {
    [[NSUserDefaults standardUserDefaults] setObject:userIcon forKey:@"UserIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/** 获取用户的icon */
+ (NSString *)getUserIcon {
    NSString *userIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIcon"];
    if (userIcon == nil) {
        return @" ";
    }
    return userIcon;
}

/** 保存用户的coverimg */
+ (void)conserveUsercoverimg:(NSString *)coverimg{
    [[NSUserDefaults standardUserDefaults] setObject:coverimg forKey:@"coverimg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/** 获取用户的coverimg */
+ (NSString *)getUsercoverimg {
    NSString *coverimg = [[NSUserDefaults standardUserDefaults] objectForKey:@"coverimg"];
    if (coverimg == nil) {
        return @" ";
    }
    return coverimg;
}

@end
