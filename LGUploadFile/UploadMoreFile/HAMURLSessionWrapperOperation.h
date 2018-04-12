//
//  HAMURLSessionWrapperOperation.h
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAMURLSessionWrapperOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;

@end
