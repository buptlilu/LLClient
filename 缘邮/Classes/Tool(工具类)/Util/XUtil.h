//
//  UIImageTool.h
//  HiBuy
//
//  Created by youagoua on 15/3/21.
//  Copyright (c) 2015年 xiaoyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface XUtil : NSObject

+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)dateToString:(NSDate *)date;

+ (long)dateToLong:(NSDate *)date;

+ (NSDate *)stringToDate:(NSString *)strDate;

+ (NSString *)dateToSimpleString:(NSDate *)date;

+ (NSString *)dateToTimeString:(NSDate *)date;

+ (int)isSameDay:(NSDate *)date otherDay:(NSDate *)otherDate;

+ (NSString *) returnAddrTimeToString:(NSDate *)startTime endTime:(NSDate *)endTime returnAddr:(NSString*)addr;

+ (UIColor *) hexToRGB:(NSString *)hexColor;

+ (UIColor *) hexToRGB:(NSString *)hexColor setAlpha:(CGFloat)alpha;

+ (UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;


+ (void )bindRequestInfo:(AFHTTPRequestOperationManager *)manager;

+ (void)bindResponseInfo:(AFHTTPRequestOperation *)operation;

+ (BOOL) containsObject:(NSMutableArray *)arrays getObject:(NSString *)object;


+ (NSArray *) getOrderArray:(NSArray *) selectedChannels allChannels: (NSArray *) allChannels;

+ (NSArray *) getRecommendChannels;

+ (BOOL) isSaveFlow;

+ (BOOL) isDay;

+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity;

+ (NSDictionary *) entityToDictionary:(id)entity;

+(NSString*)DataTOjsonString:(id)object;
@end
