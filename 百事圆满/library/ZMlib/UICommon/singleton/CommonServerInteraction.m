//
//  CommonServerInteraction.m
//  车联网-修理厂端
//
//  Created by AnYanbo on 16/7/6.
//  Copyright © 2016年 AnYanbo. All rights reserved.
//

#import "CommonServerInteraction.h"
#import "AppURL.h"

@implementation CommonServerInteraction

static CommonServerInteraction *SINGLETON = nil;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[super alloc] init];
    });
    
    return SINGLETON;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)provincialInfoResponseBlock:(YBResponseBlock)responseBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    
    [self invokeApi:[AppURL URLWithPath:@"Common" method:@"GetProvincial"]
             method:GET
       responseType:RESPONSE_INFO_LIST
          itemClass:[ProvincialInfo class]
             params:param
      responseBlock:responseBlock];
}

@end
