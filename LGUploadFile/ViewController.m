//
//  ViewController.m
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"
#import "HAMURLSessionWrapperOperationManager.h"
#import "UpFileNetwork.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"9970" ofType:@"mp3"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
//    NSMutableDictionary *dicForPar = [[NSMutableDictionary alloc] initWithDictionary:@{@"duration":@"100000",
//                                                                                       @"fileType":@"mp3"}];
//
//    [UpFileManager upLoadFile:data fileType:FileType_File params:dicForPar failure:^(NSError *error) {
//        NSLog(@"-------%@",error);
//    }];
    
    
//    //需要上传的数据
//    NSMutableArray* images = [[NSMutableArray alloc]init];
//    for (int i=1; i<7; i++) {
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
//        NSData *data = UIImageJPEGRepresentation(img, 1.0);
//        [images addObject:data];
//    }
//
//    [HAMURLSessionWrapperOperationManager uploadMoreFileNSOperationWithDataArr:images parameters:nil progress:^(NSInteger mark, NSProgress * progress) {
//        NSLog(@"%ld%@",mark,progress.localizedDescription);
//    } success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    [UpFileNetwork downLoadFileWithParams:nil result:^(id responseObject) {
        NSLog(@"123");
    } failure:^(NSError *error) {
        NSLog(@"456");
    }];
    
}


@end
