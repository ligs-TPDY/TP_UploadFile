//
//  UpFileHash.m
//  qfxtaoguwang
//
//  Created by liaojihong on 2018/4/9.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import "UpFileHash.h"

#import <CommonCrypto/CommonDigest.h>

#define CC_MD5_LENGTH 16

@implementation UpFileHash

+ (NSString *)hash:(NSData *)data
{
    return [UpFileHash fileMD5:data];
}

+ (NSString *)fileMD5:(NSData *)fileData
{
    const char*original_str = (const char *)[fileData bytes];
    
    unsigned char result[CC_MD5_LENGTH];
    
     CC_MD5(original_str, (CC_LONG)fileData.length, result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_LENGTH * 2];
    
    for( int i = 0; i < CC_MD5_LENGTH; i++ )
    {
        [output appendFormat:@"%02x", result[i]];
    }
    
    return output;
}

@end
