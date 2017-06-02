//
//  NSJSON+YBClass.h
//  果动校园
//
//  Created by AnYanbo on 15/2/28.
//  Copyright (c) 2015年 GDSchool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (_JSON_)

+ (NSArray*)arrayWithJSON:(NSString*)json;
+ (NSArray*)arrayWithJSONData:(NSData*)jsonData;
- (NSString*)toJSON;

@end

@interface NSMutableArray (_JSON_)

+ (NSMutableArray*)arrayWithJSON:(NSString*)json;
+ (NSMutableArray*)arrayWithJSONData:(NSData*)jsonData;
- (NSString*)toJSON;

@end

@interface NSDictionary (_JSON_)

+ (NSDictionary*)dictWithJSON:(NSString*)json;
+ (NSDictionary*)dictWithJSONData:(NSData*)jsonData;
- (NSString*)toJSON;

@end

@interface NSMutableDictionary (_JSON_)

+ (NSMutableDictionary*)dictWithJSON:(NSString*)json;
+ (NSMutableDictionary*)dictWithJSONData:(NSData*)jsonData;
- (NSString*)toJSON;

@end