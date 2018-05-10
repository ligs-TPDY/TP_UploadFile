//
//  UpFileNetwork.m
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import "UpFileNetwork.h"

#import "AFNetworking.h"

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

#pragma mark --下载文件--
///下载文件
+ (void)downLoadFileWithFileType:(FileType)type
                          Params:(NSMutableDictionary *)mutDic
                          result:(void(^)(id responseObject))result
                         failure:(void(^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"http://172.18.45.24:3001/profile/image/tgw/chat/image/25h58pic3eg.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination--(downloadTask-)
        在该block中告诉AFN应该把文件存放在什么位置,AFN内部会自动的完成文件的剪切处理
        targetPath:文件的临时存储路径(tmp)
        response:响应头信息
        return 返回值:文件的最终存储路径
     第四个参数:completionHandler 完成之后的回调
     filePath:文件路径 == 返回值
     */
    
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度回调,可在此监听下载进度(已经下载的大小/文件总大小)
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"%@",response);
        NSLog(@"文件临时缓存路径targetPath:%@",targetPath);
        NSLog(@"文件最终存储路径fullPath:%@",fullPath);
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath,NSError * _Nullable error) {
        NSLog(@"response%@",response);
        NSLog(@"filePath:%@",filePath);
        NSLog(@"error%@",error);
        //如果报错了，就返回错误，此时filePath也会返回文件路径。但其实文件下载操作失败。
        if (error != nil) {
            failure(error);
        }else{
            //如果没有报错，同时文件路径存在，将文件路径返回。
            if (filePath != nil) {
                
                result(filePath);
            }
        }
    }];
    
    [download resume];
}
///根据类型获取对应的URL地址
+ (NSString *)getDownloadURl:(FileType)type
{
    NSString *URL = nil;
    switch (type) {
        case FileType_Img:
            URL = [NSString stringWithFormat:@"%@%@",@"1",@"2"];
            break;
        case FileType_File:
            URL = [NSString stringWithFormat:@"%@%@",@"1",@"2"];
            break;
        case FileType_Music:
            URL = [NSString stringWithFormat:@"%@%@",@"1",@"2"];
            break;
        default:
            break;
    }
    return URL;
}
@end
