//
//  AddressModel.m
//  ecshop
//
//  Created by Jin on 15/12/22.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
-(void)setModel:(AddressModel *)model{
    self.is_default = model.is_default;
    self.address_id = model.address_id;
    self.address = model.address;
    self.telnumber = model.telnumber;
    self.username = model.username;
}



-(NSDictionary *)toAddAddressParams{
    
    NSMutableDictionary *params =  @{
                                     @"key":[LoginModel key],
                                     
                                     @"username":self.username,
                                     @"telnumber":self.telnumber,
                                     
                                     @"province":self.province,
                                     @"city":self.city,
                                     @"district":self.district,
                                     
                                     @"address_p":self.address,
                                     }.mutableCopy;
    
    
    return params;
    
}

@end
