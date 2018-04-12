//
//  UpFileHash.h
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpFileHash : NSObject

/**
 流的MD5加密

 @param data 需要加密的数据流
 @return 加密后的数据
 */
+ (NSString *)hash:(NSData *)data;

@end
