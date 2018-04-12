//
//  HAMURLSessionWrapperOperationManager.m
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "HAMURLSessionWrapperOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "HAMURLSessionWrapperOperation.h"
@implementation HAMURLSessionWrapperOperationManager

+ (void)uploadMoreFileNSOperationWithDataArr:(NSMutableArray *)mutArr
                         parameters:(NSMutableDictionary *)dicForPar
                           progress:(void(^)(NSInteger mark , NSProgress * progress))progress
                            success:(void(^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0; i<mutArr.count; i++) {
        [result addObject:[NSNull null]];
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ // 回到主线程执行，方便更新 UI 等
            NSLog(@"上传完成!");
            for (id response in result) {
                NSLog(@"%@", response);
            }
        }];
    }];
    
    for (NSInteger i = 0; i < mutArr.count; i++) {
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:mutArr[i] parameters:dicForPar progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"第%ld张图片的%@",i+1,uploadProgress.localizedDescription);
            progress(i+1 , uploadProgress);
        }  completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
            }
        }];
        
        HAMURLSessionWrapperOperation *uploadOperation = [HAMURLSessionWrapperOperation operationWithURLSessionTask:uploadTask];
        
        [completionOperation addDependency:uploadOperation];
        [queue addOperation:uploadOperation];
    }
    
    [queue addOperation:completionOperation];
}

+ (NSURLSessionUploadTask*)uploadTaskWithImage:(NSData*)data
                                    parameters:(NSMutableDictionary *)dicForPar
                                      progress:(void(^)(NSProgress * _Nonnull uploadProgress))Progress
                                    completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock
{
    //构造NSURLRequest,构造一次请求。
    NSError* error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:@"https://api.tgw360.com/file-service/upload/image"
                                                                                             parameters:dicForPar
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        //可以在上传时使用当前的系统时间作为文件名
                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                        formatter.dateFormat = @"yyyyMMddHHmmss";
                                        NSString *strForFileName = [formatter stringFromDate:[NSDate date]];
                                        //上传文件
                                        [formData appendPartWithFileData:data
                                                                    name:@"file"
                                                                fileName:[NSString stringWithFormat:@"%@.jpg",strForFileName]
                                                                mimeType:@"multipart/form-data"];
                                    }
                                                                                                  error:&error];
    
    //配置NSMutableURLRequest的header
    //    [request setValue:@"file" forHTTPHeaderField:@"file"];
    
    // 将NSURLRequest与completionBlock包装为NSURLSessionUploadTask，将请求和回调绑定在一起
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:Progress
                                                              completionHandler:completionBlock];
    return uploadTask;
}
@end
