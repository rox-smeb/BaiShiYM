//
//  ZMServerInteraction.m
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/1.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//

#import "ZMServerInteraction.h"
#import "YBNetworkEngine.h"
#import "NSMutableDictionary+Params.h"

#import <objc/runtime.h>

/************************ MKNetworkOperation ***********************/

#define USER_OBJECT                   (@"USER_OBJECT")

@interface MKNetworkOperation (YBNetworkKit)

@property (nonatomic, strong) id userObject;       // 用户自定义数据

@end


@implementation MKNetworkOperation (YBNetworkKit)

- (NSObject*)userObject
{
    return (NSObject*)objc_getAssociatedObject(self, USER_OBJECT);
}

- (void)setUserObject:(NSObject *)userObject
{
    objc_setAssociatedObject(self, USER_OBJECT, userObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

/*********************** ZMServerResponseInfo **********************/
@interface ZMServerResponseInfo ()

@property (strong, nonatomic) NSDictionary * i;   // 原始的字典数据i

@end

@implementation ZMServerResponseInfo

+ (instancetype)instanceWithDict:(NSDictionary*)i
{
    ZMServerResponseInfo* info = [[ZMServerResponseInfo alloc] init];
    if ([info setupWithDict:i])
    {
        return info;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (int)setupWithDict:(NSDictionary*)i
{
    BOOL ret = NO;
    @try
    {
        if ([i isKindOfClass:[NSDictionary class]])
        {
            self.i = i;
            
            NSDictionary* data = i[@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                self.data = data;
            }
            
            NSArray* list = i[@"data"];
            if ([list isKindOfClass:[NSArray class]])
            {
                self.list = list;
            }
            
            id v = i[@"v"];
            if ([v isKindOfClass:[NSNumber class]])
            {
                self.v = [v description];
            }
            if ([v isKindOfClass:[NSString class]])
            {
                self.v = v;
            }
            
            ret = YES;
        }
    }
    @catch (NSException *exception)
    {
        ret = NO;
    }
    
    return ret;
}

@end

/********************** ZMServerResponse *********************/

@interface ZMServerResponse ()

@property (nonatomic, strong) id dataOrList;

@end

@implementation ZMServerResponse

+ (instancetype)responseWithError:(NSError*)error
{
    ZMServerResponse* ret = [[ZMServerResponse alloc] init];
    [ret setupWithError:error];
    return ret;
}

+ (instancetype)responseWithOperation:(MKNetworkOperation*)operation error:(NSError*)error
{
    if (error == nil)
    {
        return [[self class] responseWithOperation:operation];
    }
    else
    {
        return [[self class] responseWithError:error];
    }
}

+ (instancetype)responseWithOperation:(MKNetworkOperation*)operation error:(NSError*)error infoBlock:(ZMMakeResponseInfoBlock)block
{
    if (error == nil)
    {
        return [[self class] responseWithOperation:operation infoBlock:block];
    }
    else
    {
        return [[self class] responseWithError:error];
    }
}

+ (instancetype)responseWithOperation:(MKNetworkOperation*)operation
{
    return [[self class] responseWithOperation:operation infoBlock:nil];
}

+ (instancetype)responseWithOperation:(MKNetworkOperation*)operation infoBlock:(ZMMakeResponseInfoBlock)block
{
    ZMServerResponse* ret = nil;
    
    @try
    {
        if ([operation isKindOfClass:[MKNetworkOperation class]] == NO)
        {
            NSError* error = [NSError errorWithDomain:@"网络引擎返回错误参数" code:RESPONSE_ERROR_RETURN_WRONG_PARAM userInfo:nil];
            ret = [ZMServerResponse responseWithError:error];
            return ret;
        }
        
        // 获取服务端返回的内容
        NSString* content = [operation responseString];
        
        // 获取服务器返回JSON
        NSDictionary* dict = [operation responseJSON];
        
        // 服务器可能返回错误JSON->尝试处理一下 "{}"
        @try
        {
            if (dict == nil)
            {
                NSString* jsonStr = content;
                if ([jsonStr hasPrefix:@"\""])
                {
                    jsonStr = [jsonStr substringFromIndex:1];
                }
                
                if ([jsonStr hasSuffix:@"\""])
                {
                    jsonStr = [jsonStr substringToIndex:jsonStr.length - 1];
                }
                
                dict = [NSDictionary dictWithJSON:jsonStr];
            }
        }
        @catch (NSException *exception)
        {
        }
        
        // 服务器返回错误数据
        if ([dict isKindOfClass:[NSDictionary class]] == NO)
        {
            NSError* error = [NSError errorWithDomain:@"服务器返回错误数据" code:RESPONSE_ERROR_RETURN_WRONG_DATA userInfo:nil];
            ret = [ZMServerResponse responseWithError:error];
            return ret;
        }
        
        NSNumber* s     = dict[@"code"];
        NSString* m     = dict[@"message"];
        NSDictionary* i = dict[@"data"];
        
        ret                  = [[ZMServerResponse alloc] init];
        ret.isCachedResponse = operation.isCachedResponse;
        ret.content          = content;
        ret.userObject       = operation.userObject;
        
//        // 服务器返回的接口版本号
//        if ([v isKindOfClass:[NSNumber class]])
//        {
//            ret.v = [v description];
//        }
//        if ([v isKindOfClass:[NSString class]])
//        {
//            ret.v = v;
//        }
        
        // 服务器返回状态码
        if (s == nil || [s respondsToSelector:@selector(integerValue)] == NO)
        {
            NSError* error = [NSError errorWithDomain:@"服务器返回状态码无效" code:RESPONSE_ERROR_RETURN_WRONG_STATE userInfo:nil];
            [ret setupWithError:error];
        }
        else
        {
            ret.code = [s integerValue];
        }
        
        // 服务器返回状态信息
        if (m == nil || [m isEqual:@""])
        {
            if (ret.code == 0)
            {
                m = @"操作成功";
            }
            else if (s > 0)
            {
                m = @"发生异常";
            }
            else
            {
                m = @"操作失败";
            }
        }
        ret.message = m;
        
        // 服务器返回错误
        if (ret.code != 200)
        {
            NSError* error = [NSError errorWithDomain:m code:ret.code userInfo:nil];
            [ret setupWithError:error];
        }
        
        // 处理服务器返回数据
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic addParam:i forKey:@"data"];
        ZMServerResponseInfo* responseInfo = [ZMServerResponseInfo instanceWithDict:dic];
        ret.data = responseInfo;
        if (block != nil && ret.code >= 0)
        {
            id dataOrList = nil;
            BOOL isSuccess = YES;
            
            // 回调构建数据
            @try
            {
                dataOrList = block(responseInfo, &isSuccess);
            }
            @catch (NSException *exception)
            {
                dataOrList = nil;
                ret = NO;
            }
            ret.dataOrList = dataOrList;
            
            // 数据构建失败
            if (isSuccess == NO)
            {
                NSError* error = [NSError errorWithDomain:@"服务器返回数据格式无法解析" code:RESPONSE_ERROR_WRONG_DATA_ANALYSIS userInfo:nil];
                [ret setupWithError:error];
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
    
    return ret;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isCachedResponse = NO;
    }
    return self;
}

- (void)setupWithError:(NSError*)error
{
    self.error      = error;
    self.code       = error.code;
    self.message    = error.domain;
}

- (BOOL)success
{
    if (self.error == nil && self.code == 0)
    {
        return YES;
    }
    return NO;
}

- (void)showHUD
{
    if ([self success])
    {
        [SVProgressHUD showSuccessWithStatus:self.message];
    }
    else
    {
        [self.error showErrorHUD];
    }
}

@end

/******************** ZMServerInteraction ********************/
@implementation ZMServerInteraction

static ZMServerInteraction *SINGLETON = nil;

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

/**
 *  通过Class创建对象 (对象需实现initWithJson才可完整创建)
 *
 *  @param itemClass 要创建对象的Class
 *  @param json      json字典
 *
 *  @return 创建并初始化的对象
 */
- (id)instanceWithClass:(Class)itemClass withJSON:(NSDictionary*)json
{
    id instance = nil;
    @try
    {
        if ([json isKindOfClass:[NSDictionary class]])
        {
            instance = [itemClass alloc];
            if ([instance respondsToSelector:@selector(initWithJSON:)])
            {
                [instance initWithJSON:json];
            }
        }
    }
    @catch (NSException *exception)
    {
        instance = nil;
    }
    return instance;
}

- (void)uploadArrayFromParam:(NSMutableDictionary*)param datas:(NSArray**)ppDatas names:(NSArray**)ppNames
{
    @try
    {
        if ([param isKindOfClass:[NSMutableDictionary class]])
        {
            NSMutableArray* datas = [NSMutableArray array];
            NSMutableArray* names = [NSMutableArray array];
            
            for (UploadDataInfo* info in param.uploadDatas)
            {
                if (info.data != nil && info.name != nil)
                {
                    [datas addObject:info.data];
                    [names addObject:info.name];
                }
            }
            
            if (ppDatas != nil)
            {
                *ppDatas = datas;
            }
            
            if (ppNames != nil)
            {
                *ppNames = names;
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
}

#pragma mark - 通过信息构造回调获取返回值

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param params        传入参数
 *  @param infoMakeBlock 通过 ZMServerResponseInfo 构造返回数据的回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
           params:(NSDictionary*)params
    infoMakeBlock:(ZMMakeResponseInfoBlock)infoMakeBlock
    responseBlock:(ZMResponseBlock)block
{
    [self invokeApi:api
             method:method
             params:params
         userObject:nil
      infoMakeBlock:infoMakeBlock
      responseBlock:block];
}

#pragma mark - 通过信息构造回调获取返回值 可以用户自定义参数

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param params        传入参数
 *  @param userObject    用户自定义对象
 *  @param infoMakeBlock 通过 ZMServerResponseInfo 构造返回数据的回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
           params:(NSDictionary*)params
       userObject:(id)userObject
    infoMakeBlock:(ZMMakeResponseInfoBlock)infoMakeBlock
    responseBlock:(ZMResponseBlock)block
{
    [self invokeApi:api
             method:method
             params:params
         userObject:userObject
      infoMakeBlock:infoMakeBlock
      progressBlock:nil
      responseBlock:block];
}

#pragma mark - 通过信息构造回调获取返回值 具备进度回调

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param params        传入参数
 *  @param infoMakeBlock 通过 ZMServerResponseInfo 构造返回数据的回调
 *  @param progressBlock 进度回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
           params:(NSDictionary*)params
    infoMakeBlock:(ZMMakeResponseInfoBlock)infoMakeBlock
    progressBlock:(ZMProgressUpdateBlock)progressBlock
    responseBlock:(ZMResponseBlock)block
{
    [self invokeApi:api
             method:method
             params:params
         userObject:nil
      infoMakeBlock:infoMakeBlock
      progressBlock:progressBlock
      responseBlock:block];
}

#pragma mark - 通过信息构造回调获取返回值 具备进度回调 可以用户自定义参数

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param params        传入参数
 *  @param userObject    用户自定义对象
 *  @param infoMakeBlock 通过 ZMServerResponseInfo 构造返回数据的回调
 *  @param progressBlock 进度回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
           params:(NSDictionary*)params
       userObject:(id)userObject
    infoMakeBlock:(ZMMakeResponseInfoBlock)infoMakeBlock
    progressBlock:(ZMProgressUpdateBlock)progressBlock
    responseBlock:(ZMResponseBlock)block
{
    NetEngineComplete ne_complete = ^(id result, NSError* error)
    {
        if (block != nil)
        {
            @try
            {
                ZMServerResponse* response = [ZMServerResponse responseWithOperation:result
                                                                               error:error
                                                                           infoBlock:infoMakeBlock];
                block(response, response.dataOrList);
            }
            @catch (NSException *exception)
            {
                NSLog(@"ZMResponseBlock %@", exception);
            }
        }
    };
    
    MKNetworkOperation* operation = nil;
    if (method == GET_ZM)                  // GET请求
    {
        operation = [[YBNetworkEngine sharedInstance] getSomethingFrom:api
                                                            withParams:params
                                                   withCompletionBlock:ne_complete
                                                                option:responseJsonState];
    }
    else if (method == POST_ZM)            // POST请求
    {
        operation = [[YBNetworkEngine sharedInstance] postSomethingTo:api
                                                           withParams:params
                                                  withCompletionBlock:ne_complete
                                                               option:responseJsonState];
    }
    else if (method == UPLOAD_ZM)          // 上传数据
    {
        NSArray* datas = nil;
        NSArray* names = nil;
        [self uploadArrayFromParam:params datas:&datas names:&names];
        
        operation = [[YBNetworkEngine sharedInstance] postFileTo:api
                                                      withParams:params
                                                       withFiles:datas
                                                        andNames:names
                                        withProgressChangedBlock:progressBlock
                                             withCompletionBlock:ne_complete];
    }
    else if (method == DOWNLOAD_ZM)        // 下载数据
    {
        
    }
    
    // 设置用户自定义数据
    if ([operation isKindOfClass:[MKNetworkOperation class]] && [operation respondsToSelector:@selector(setUserObject:)])
    {
        [operation setUserObject:userObject];
    }
}

#pragma mark - 通过itemClass获取返回值

/**
 *  调用服务端API
 *
 *  @param api       api地址
 *  @param method    GET | POST
 *  @param infoType  Data字段返回 | List字段返回 | Data,List字段同时返回
 *  @param itemClass 生成数据的对应Class
 *  @param params    传入参数
 *  @param block     结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
     responseType:(RESPONSE_INFO_TYPE_ZM)infoType
        itemClass:(Class)itemClass
           params:(NSDictionary*)params
    responseBlock:(ZMResponseBlock)block;
{
    [self invokeApi:api
             method:method
       responseType:infoType
          itemClass:itemClass
             params:params
         userObject:nil
      responseBlock:block];
}

#pragma mark - 通过itemClass获取返回值 可以用户自定义参数

/**
 *  调用服务端API
 *
 *  @param api        api地址
 *  @param method     GET | POST
 *  @param infoType   Data字段返回 | List字段返回 | Data,List字段同时返回
 *  @param itemClass  生成数据的对应Class
 *  @param params     传入参数
 *  @param userObject 用户自定义对象
 *  @param block      结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
     responseType:(RESPONSE_INFO_TYPE_ZM)infoType
        itemClass:(Class)itemClass
           params:(NSDictionary*)params
       userObject:(id)userObject
    responseBlock:(ZMResponseBlock)block
{
    [self invokeApi:api
             method:method
       responseType:infoType
          itemClass:itemClass
             params:params
         userObject:userObject
      progressBlock:nil
      responseBlock:block];
}

#pragma mark - 通过itemClass获取返回值 具备进度回调

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param infoType      Data字段返回 | List字段返回 | Data,List字段同时返回
 *  @param itemClass     生成数据的对应Class
 *  @param params        传入参数
 *  @param progressBlock 进度回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
     responseType:(RESPONSE_INFO_TYPE_ZM)infoType
        itemClass:(Class)itemClass
           params:(NSDictionary*)params
    progressBlock:(ZMProgressUpdateBlock)progressBlock
    responseBlock:(ZMResponseBlock)block
{
    [self invokeApi:api
             method:method
       responseType:infoType
          itemClass:itemClass
             params:params
         userObject:nil
      progressBlock:progressBlock
      responseBlock:block];
}

#pragma mark - 通过itemClass获取返回值 具备进度回调 可以用户自定义参数

/**
 *  调用服务端API
 *
 *  @param api           api地址
 *  @param method        GET | POST
 *  @param infoType      Data字段返回 | List字段返回 | Data,List字段同时返回
 *  @param itemClass     生成数据的对应Class
 *  @param params        传入参数
 *  @param userObject    用户自定义对象
 *  @param progressBlock 进度回调
 *  @param block         结果回调
 */
- (void)invokeApi:(NSString*)api
           method:(HTTP_METHOD_ZM)method
     responseType:(RESPONSE_INFO_TYPE_ZM)infoType
        itemClass:(Class)itemClass
           params:(NSDictionary*)params
       userObject:(id)userObject
    progressBlock:(ZMProgressUpdateBlock)progressBlock
    responseBlock:(ZMResponseBlock)block
{
    ZMMakeResponseInfoBlock infoMakeBlock = ^id(ZMServerResponseInfo* info, BOOL *ret)
    {
        id instance = nil;
        if (infoType == RESPONSE_INFO_NONE_ZM)
        {
            instance = nil;
        }
        else if (infoType == RESPONSE_INFO_DATA_ZM)
        {
            instance = [self instanceWithClass:itemClass withJSON:info.data];
            if (instance == nil)
            {
                *ret = NO;
            }
        }
        else if (infoType == RESPONSE_INFO_LIST_ZM)
        {
            NSMutableArray* array = [NSMutableArray array];
            for (NSDictionary* dict in info.list)
            {
                id item = [self instanceWithClass:itemClass withJSON:dict];
                if (item != nil && [item isKindOfClass:itemClass])
                {
                    [array addObject:item];
                }
            }
            instance = array;
        }
        else if (infoType == (RESPONSE_INFO_DATA_ZM | RESPONSE_INFO_LIST_ZM))
        {
            instance = [self instanceWithClass:itemClass withJSON:info.i];
            if (instance == nil)
            {
                *ret = NO;
            }
        }
        return instance;
    };
    
    [self invokeApi:api
             method:method
             params:params
         userObject:userObject
      infoMakeBlock:infoMakeBlock
      progressBlock:progressBlock
      responseBlock:block];
}

@end
