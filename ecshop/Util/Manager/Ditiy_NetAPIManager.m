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


-(void)request_UserInfo_WithParams:(NSDictionary *)params andBlock:(void (^)(id data,NSError *error))block{
    
    NSString *path = @"user/userinfo";
    
    [[DitiyNetAPIClient sharedJsonClient]requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
    }];
    
    
}

//更新用户信息
-(void)request_UpdateUserInfo_WithParams:(NSDictionary *)params andBlock:(void (^)(id data,NSError *error))block{
    
    NSString *path = @"user/modifyUser";
    
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

//查询
-(void)request_GetAddressList_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    
    NSString *toPath = @"goods/addresslist";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
}

//删除
-(void)request_DeleteAddress_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    NSString *toPath = @"goods/deladdress";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
}

//修改
-(void)request_ModifyAddress_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    NSString *toPath = @"goods/address";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
    
}

-(void)request_GetDetailAddress_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    
    NSString *toPath = @"goods/addrdetail";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
}


-(void)request_SetDefaultAddress_WithParams:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block;
{
    
    NSString *toPath = @"goods/addrdefault";
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
}


-(void)request_GetOrderList_withOrderType:(OrderType)type Params:(NSDictionary *)params andBlock:(void (^)(id data ,NSError *error))block{
    
    NSString *toPath ;
    
    switch (type) {
        case OrderAll:
            
            toPath = @"user/order";
            
            break;
        case OrderUnpayed:
            toPath = @"order/obligation";
            
            break;
        case OrderUndispatched:
            toPath = @"order/send_goods";
            
            break;
        case OrderUnreceived:
            toPath = @"order/reciv_goods";
            
            break;
        case OrderFinished:
            toPath = @"order/order_sucess";
            
            break;
    }
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
    
    
    
}


-(void)request_UserBonus_WithParams:(NSDictionary *)params andBlock:(void (^)(id data,NSError *error))block{
    
    
    
    NSString *toPath = @"user/bonus";
    
    
    [[DitiyNetAPIClient sharedJsonClient] requestJsonDataWithPath:toPath withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        
        
        
        block(data,error);
        
        
        
    }];
    
    
}


@end
