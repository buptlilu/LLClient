//
//  UIImageTool.m
//  HiBuy
//
//  Created by youagoua on 15/3/21.
//  Copyright (c) 2015年 xiaoyou. All rights reserved.
//

#import "XUtil.h"
#import <objc/runtime.h>
#import "DKNightVersion.h"

@implementation XUtil

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (long)dateToLong:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return [strDate longLongValue];
}

+ (NSDate *)stringToDate:(NSString *)strDate
{
    //设置转换格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:strDate];
    return date;
}

+ (NSString *) returnAddrTimeToString:(NSDate *)startTime endTime:(NSDate *)endTime returnAddr:(NSString*)addr
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    double nowTime=time;      //NSTimeInterval返回的是double类型
    double endTimeSince1970 = endTime.timeIntervalSince1970;
    double startTimeSince1970 = startTime.timeIntervalSince1970;
    if(nowTime<startTimeSince1970){
        int interval = (startTimeSince1970-nowTime)/86400;
        if(interval==1){
            return [NSString stringWithFormat:@"今天从%@出发",addr];
        }
        return [NSString stringWithFormat:@"%i天后从%@出发",interval,addr];

    }else if(nowTime < endTimeSince1970){
        int  interval = (endTimeSince1970-nowTime)/86400 +1;
        if(interval==1){
            return [NSString stringWithFormat:@"今天回到%@",addr];
        }
        return [NSString stringWithFormat:@"%i天后回到%@",interval,addr];
    }else if(nowTime >= endTimeSince1970){
        int  interval = (nowTime-endTimeSince1970)/86400 +1;
        if(interval==1){
            return [NSString stringWithFormat:@"今天回到%@",addr];
        }
        return [NSString stringWithFormat:@"已回到%@%i天",addr,interval];
    }
    return @"未知";
}


+ (void)bindRequestInfo:(AFHTTPRequestOperationManager *)manager{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    if(userId ==nil){
        userId = @"-1";
    }
    NSString *xcode = [userDefaults objectForKey:@"xcode"];
    if(xcode ==nil){
        xcode = @"";
    }
    @try {
        [manager.requestSerializer setValue:@"3123" forHTTPHeaderField:@"tata-reset-clientid"];
        [manager.requestSerializer setValue:@"888382832" forHTTPHeaderField:@"tata-reset-imei"];
        [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"tata-reset-apiversion"];
        [manager.requestSerializer setValue:xcode forHTTPHeaderField:@"tata-reset-code"];
        [manager.requestSerializer setValue:userId forHTTPHeaderField:@"tata-reset-userid"];
    }
    @catch (NSException *exception) {
          BYLog(@"exception:%@", exception);
    }
    @finally {
    }

}

+ (void)bindResponseInfo:(AFHTTPRequestOperation *)operation{
   
    @try{
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 
    // handle response headers
    NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[operation response]);
    NSDictionary *headers = [response allHeaderFields];
 
    
    for (NSString *key in headers) {
        BYLog(@"key: %@ value: %@", key, headers[key]);
        if([key isEqualToString:@"tata-reset-code"]){
            [userDefaults setObject:headers[key] forKey:@"xcode"];
        }
    }

  
   } @catch (NSException *exception) {
        BYLog(@"exception:%@", exception);
    }
    @finally {
    }
    
    
    
}

+ (NSString *)dateToSimpleString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"MM.dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (int)isSameDay:(NSDate *)date otherDay:(NSDate *)otherDate{
    NSString * dateStr =[XUtil dateToSimpleString:date];
    NSString * aDateStr =[XUtil dateToSimpleString:otherDate];
    if([dateStr isEqualToString:aDateStr] ){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)dateToTimeString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (UIColor *) hexToRGB:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2 ;
    range.location = 0 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&red];
    range.location = 2 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&green];
    range.location = 4 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&blue];
    return [UIColor colorWithRed:(float)(red/ 255.0f) green:(float)(green/ 255.0f) blue:(float)(blue/ 255.0f) alpha:1.0f ];
}

+ (UIColor *) hexToRGB:(NSString *)hexColor setAlpha:(CGFloat)alpha;
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2 ;
    range.location = 0 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&red];
    range.location = 2 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&green];
    range.location = 4 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&blue];
    return [UIColor colorWithRed:(float)(red/ 255.0f) green:(float)(green/ 255.0f) blue:(float)(blue/ 255.0f) alpha:alpha ];
}

+ (UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

//设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (BOOL) containsObject:(NSMutableArray *)arrays getObject:(NSString *)object
{
    for (NSString *tmp in arrays) {
        if ([[NSString stringWithFormat:@"%@",tmp] isEqualToString:[NSString stringWithFormat:@"%@",object]]) {
            return YES;
        }
    }
    return NO;
}


+(BOOL) isDay{
    DKNightVersionManager *manager = [DKNightVersionManager sharedNightVersionManager];
    BOOL isDay = (manager.themeVersion == DKThemeVersionNormal) ? YES: NO;
    return  isDay;
}

+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity
{
    if (dict && entity) {
        
        for (NSString *keyName in [dict allKeys]) {
            //构建出属性的set方法
            NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[keyName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
            //如果是description，转为descriptions
            if([keyName isEqualToString:@"description"]){
                destMethodName = [NSString stringWithFormat:@"set%@:",[@"descriptions" capitalizedString]];
            }
            SEL destMethodSelector = NSSelectorFromString(destMethodName);
            
            if ([entity respondsToSelector:destMethodSelector]) {
                NSString *data = [dict objectForKey:keyName];
                [entity performSelector:destMethodSelector withObject:data];
            }
            
        }//end for
        
    }//end if
}

+ (NSDictionary *) entityToDictionary:(id)entity
{
    
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString *property = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if([property isEqualToString:@"content"] || [property isEqualToString:@"isFavor"] || [property isEqualToString:@"isDownload"]){
            continue;
        }
        id value;
        @try {
            value =  [entity performSelector:NSSelectorFromString(property)];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        if(value !=nil){
            [valueArray addObject:value];
            [propertyArray addObject:property];
        }
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    BYLog(@"%@", returnDic);
    
    return returnDic;
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        BYLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


@end
