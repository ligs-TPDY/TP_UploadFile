//
//  HAMURLSessionWrapperOperation.m
//  LGUploadFile
//
//  Created by liaojihong on 2018/4/12.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "HAMURLSessionWrapperOperation.h"

@interface HAMURLSessionWrapperOperation () {
    BOOL executing;
    // 系统的 finished 是只读的，不能修改，所以只能重写一个。
    BOOL finished;
}
//保留当前的请求
@property (nonatomic, strong) NSURLSessionTask* task;

@property (nonatomic, assign) BOOL isObserving;

@end

@implementation HAMURLSessionWrapperOperation

#pragma mark - Observe Task

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task {
    
    HAMURLSessionWrapperOperation* operation = [HAMURLSessionWrapperOperation new];
    
    operation.task = task;
    
    return operation;
}
#pragma mark - NSOperation methods
- (void)start {
    //如果任务已经取消
    if ([self isCancelled])
    {
        //将当前任务状态改为结束，并通知队列
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    //如果任务没有取消，则开始
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        [self startObservingTask];
        [self.task resume];
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
}
- (void)startObservingTask {
    @synchronized (self) {
        if (_isObserving) {
            return;
        }
        
        [_task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        _isObserving = YES;
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (self.task.state == NSURLSessionTaskStateCanceling || self.task.state == NSURLSessionTaskStateCompleted) {
        [self stopObservingTask];
        [self completeOperation];
    }
}
- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)dealloc {
    [self stopObservingTask];
}
// 因为要在 dealloc 调，所以用下划线不用点语法
- (void)stopObservingTask {
    @synchronized (self) {
        if (!_isObserving) {
            return;
        }
        
        _isObserving = NO;
        [_task removeObserver:self forKeyPath:@"state"];
    }
}

@end
