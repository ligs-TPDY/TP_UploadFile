//
//  UpFileManager.h
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpFileManager : NSObject

+ (void)upLoadFile:(NSData *)data
            params:(NSMutableDictionary *)mutDic
           success:(void(^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;








@end
