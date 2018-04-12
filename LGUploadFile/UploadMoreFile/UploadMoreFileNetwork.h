//
//  UploadMoreFileNetwork.h
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

/**
    1,异步上传。批量请求里的每个请求都应该在不同线程，可以同时上传。
    2,在所有请求都完成之后，再通知回调。
    3,尽管异步请求的返回先后顺序没有一定，很可能后发出的请求先返回；但是最后回调的时候，请求返回的结果必须要按请求发出的顺序排列。比如，一个很常见的处理是，上传图片的接口返回该图片的 url；那么回调结果里的 url 顺序显然需要跟上传的图片顺序一一对应上。
    4,最好传完每张图片也能有一个回调，方便我们告诉用户上传的进度。
 */

//https://www.jianshu.com/p/2cb9136c837a

/**使用指南
 //导入头文件
 
 //需要上传的数据
 NSMutableArray* images = [[NSMutableArray alloc]init];
 for (int i=1; i<7; i++) {
 UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
 NSData *data = UIImageJPEGRepresentation(img, 1.0);
 [images addObject:data];
 }
 
 UploadMoreFileNetwork *up = [[UploadMoreFileNetwork alloc]init];
 [up uploadMoreFileWithDataArr:images parameters:nil progress:^(NSInteger mark, NSProgress * progress) {
 NSLog(@"%ld%@",mark,progress.localizedDescription);
 } success:^(id responseObject) {
 NSLog(@"%@",responseObject);
 } failure:^(NSError *error) {
 NSLog(@"%@",error);
 }];
 
 */

#import <Foundation/Foundation.h>

@interface UploadMoreFileNetwork : NSObject
/**
 上传多个图片
 
 @param mutArr 图片数据（二进制流）
 @param dicForPar 参数
 @param progress 当前进度
 @param success 成功的回调（全部完成）
 @param failure 失败的回调
 */
-(void)uploadMoreFileGCDWithDataArr:(NSMutableArray *)mutArr
                      parameters:(NSMutableDictionary *)dicForPar
                         progress:(void(^)(NSInteger mark , NSProgress * progress))progress
                         success:(void(^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end
