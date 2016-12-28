//
//  Ditiy_NetAPIManager.m
//  ecshop
//
//  Created by 吴狄 on 2016/12/23.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "Ditiy_NetAPIManager.h"

@implementation Ditiy_NetAPIManager


+ (instancetype)sharedManager {
    static Ditiy_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


-(void)request_Login_WithParams:(NSDictionary *)params andBlock:(void (^)(id data,NSError *error))block{
    
    NSString *path = @"user/login";
    
    [[DitiyNetAPIClient sharedJsonClient]requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
       
        
        
        block(data,error);
        
        
    }];

    
}



-(void)request_CreateOrder_WithParams:(NSDictionary *)params andBlock:(void (^)(id data,NSError *error))block{
    
    NSString *toPath = @"order/create";
    
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
    
    
}

-(void)request_AddAddress_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    NSString *toPath = @"goods/address";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
}

@end
