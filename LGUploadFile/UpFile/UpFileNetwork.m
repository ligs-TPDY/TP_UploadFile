//
//  UpFileNetwork.m
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import "UpFileNetwork.h"

#import "AFHTTPSessionManager.h"

///检查文件是否存在
#define UploadcheckfileUniUrl       @"https://api.tgw360.com/file-service"

@implementation UpFileNetwork

///检查文件是否存在
+ (void)getWithParForfileHash:(NSDictionary *)dicForfileHash
           success:(void(^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"%@/upload/checkfile",UploadcheckfileUniUrl];
    NSLog(@"检查图片.文件url:%@",URL);
    NSLog(@"检查图片.文件参数:%@",dicForfileHash);
    [manager GET:URL parameters:dicForfileHash progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress.userInfo);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

//上传图片.文件
+(void)postDataWithParams:(NSMutableDictionary *)params
            imageDatas:(NSData *)image
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"%@/upload/image",UploadcheckfileUniUrl];
    NSLog(@"上传图片.文件url:%@",URL);
    NSLog(@"上传图片.文件参数:%@",params);
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *strForFileName = [formatter stringFromDate:[NSDate date]];
        
        [formData appendPartWithFileData:image
                                    name:@"file"
                                fileName:[NSString stringWithFormat:@"%@.%@",strForFileName,@"png"]
                                mimeType:@"application/octet-stream"];
        
    }progress:^(NSProgress * _Nonnull uploadProgress) {
        //图片上传进度
        NSLog(@"%@",uploadProgress.localizedDescription);
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"%@",error);
        failure(error);
    }];
}
@end
