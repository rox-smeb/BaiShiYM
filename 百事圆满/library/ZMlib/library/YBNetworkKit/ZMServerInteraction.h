//
//  ZMServerInteraction.h
//  百事圆满
//
//  Created by ZhangMeng on 2017/6/1.
//  Copyright © 2017年 Chuangshihuichuang. All rights reserved.
//
//  服务端返回数据结构
//
//  {
//      "code": 200,
//      "message":"登录成功",
//      "data": {
//
//              }
//  }


#import <Foundation/Foundation.h>

@class ZMServerResponseInfo;
@class ZMServerResponse;

typedef NS_ENUM(NSInteger, HTTP_METHOD_ZM)
{
    GET_ZM      = 0,                                                                       // GET请求
    POST_ZM     = 1,                                                                       // POST请求
    UPLOAD_ZM   = 2,                                                                       // 上传数据
    DOWNLOAD_ZM = 3                                                                        // 下载数据
};

typedef NS_ENUM(NSInteger, RESPONSE_INFO_TYPE_ZM)
{
    RESPONSE_INFO_NONE_ZM = 1,                                                             // 无数据
    RESPONSE_INFO_DATA_ZM = 1 << 1,                                                        // Data返回
    RESPONSE_INFO_LIST_ZM = 1 << 2                                                         // List返回
};

typedef NS_ENUM(NSInteger, RESPONSE_ERROR_TYPE_ZM)
{
    RESPONSE_ERROR_RETURN_WRONG_PARAM_ZM  = -100,                                          // 网络引擎返回错误参数
    RESPONSE_ERROR_RETURN_WRONG_DATA_ZM   = -101,                                          // 服务器返回错误数据
    RESPONSE_ERROR_RETURN_WRONG_STATE_ZM  = -102,                                          // 服务器返回状态码无效
    RESPONSE_ERROR_WRONG_DATA_ANALYSIS_ZM = -103                                           // 服务器返回数据格式无法解析
};

typedef void (^ZMResponseBlock)(ZMServerResponse* response, id dataOrList);               // 结果返回回调
typedef void (^ZMProgressUpdateBlock)(double progress);                                   // 进度更新回调
typedef id   (^ZMMakeResponseInfoBlock)(ZMServerResponseInfo* info, BOOL *ret);           // 构建info回调

/*********************** ZMServerResponseInfo **********************/
@interface ZMServerResponseInfo : NSObject
{
    
}

@property (strong, nonatomic) NSDictionary * data;                                      // k->v
@property (strong, nonatomic) NSArray      * list;                                      // array
@property (strong, nonatomic) NSString     * v;                                         // 数据版本号

@end

/********************** ZMServerResponse *********************/
@interface ZMServerResponse : NSObject
{
    
}

@property (assign, nonatomic) NSInteger            code;                                // 状态值
@property (strong, nonatomic) NSString             * message;                           // 提示信息
@property (strong, nonatomic) ZMServerResponseInfo * data;                              // 数据

@property (assign, nonatomic) BOOL                 isCachedResponse;                    // 是否为缓存
@property (strong, nonatomic) id                   content;                             // 服务端返回全部内容
@property (strong, nonatomic) id                   userObject;                          // 用户自定义数据
@property (strong, nonatomic) NSError              * error;                             // 错误信息

- (BOOL)success;
- (void)showHUD;

@end


/******************** ZMServerInteraction ********************/
@interface ZMServerInteraction : NSObject
{
    
}

+ (ZMServerInteraction*)sharedInstance;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

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
    responseBlock:(ZMResponseBlock)block;

@end
