//
//  UpFileManager.m
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import "UpFileManager.h"

#import "UpFileHash.h"
#import "UpFileNetwork.h"

@implementation UpFileManager

+ (void)upLoadFile:(NSData *)data
            params:(NSMutableDictionary *)mutDic
           success:(void(^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    //利用hash值检查文件
    NSString *strForHash = [UpFileHash hash:data];
    NSDictionary *dicForPar = @{@"fileHash":strForHash};
    [UpFileNetwork getWithParForfileHash:dicForPar success:^(id responseObject){
        NSLog(@"%@",responseObject);
        //图片上传
        [UpFileNetwork postDataWithParams:mutDic imageDatas:data success:^(id response){
             NSLog(@"%@",response);
         }failure:^(NSError *error){
             NSLog(@"%@",error);
         }];
    }failure:^(NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}
        

@end
