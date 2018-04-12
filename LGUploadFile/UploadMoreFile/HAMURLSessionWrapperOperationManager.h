//
//  HAMURLSessionWrapperOperationManager.h
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAMURLSessionWrapperOperationManager : NSObject

+ (void)uploadMoreFileNSOperationWithDataArr:(NSMutableArray *)mutArr
                          parameters:(NSMutableDictionary *)dicForPar
                            progress:(void(^)(NSInteger mark , NSProgress * progress))progress
                             success:(void(^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

@end
