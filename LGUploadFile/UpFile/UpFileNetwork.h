//
//  UpFileNetwork.h
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FileType)  {
    //图片
    FileType_Img = 0,
    //文件
    FileType_File,
    //音频
    FileType_Music,
};


@interface UpFileNetwork : NSObject

///检查文件
+ (void)getWithParForfileHash:(NSDictionary *)dicForfileHash
           success:(void(^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


///上传图片.文件
+(void)postDataWithParams:(NSMutableDictionary *)params
            imageDatas:(NSData *)image
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;


+ (void)downLoadFileWithFileType:(FileType)type
                          Params:(NSMutableDictionary *)mutDic
                          result:(void(^)(id responseObject))result
                         failure:(void(^)(NSError *error))failure;

@end
