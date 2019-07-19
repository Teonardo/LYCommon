//
//  NSDate+LYDateTool.h
//  DateTransform
//
//  Created by Teonardo on 2019/7/5.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 时间戳的精度*/
typedef NS_ENUM(NSInteger, LYTimestampAccuracy) {
    /** 精确到毫秒(13位)*/
    LYTimestampAccuracyMillisecond = 0,
    /** 精确到秒(10位)*/
    LYTimestampAccuracySecond,
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
@interface NSDate (LYDateTool)


#pragma mark - 共享DateFormatter对象
/**
 获取全局共享的 NSDateFormatter 对象, 避免大量重复创建带来的性能问题.
 
 @param dateFormat 格式字符串(eg: yyyy-MM-dd HH:mm:ss SS). 注: 将格式字符串参数放在这里主要是为了提醒开发者每次获取 DateFormatter 对象时不要忘记设置(更新) 格式.
 @return 共享的DateFormatter 对象
 */
+ (NSDateFormatter *)ly_sharedDateFormatter:(NSString *)dateFormat;


#pragma mark - 时间戳转date
/**
 由时间戳获取 NSDate 对象
 
 @param timestamp 时间戳
 @return NSDate 对象
 */
+ (NSDate *)ly_dateWithTimestamp:(NSString *)timestamp;


#pragma mark - 相对时间描述

/**
 通过给定时间戳(之前的某个时刻), 获取该时刻相对现在的时间描述
 
 @param timestamp 时间戳
 @return 时间描述 (eg: "刚刚", "三分钟前"等. 注意:超过10天则显示时间戳的日期字符串,如 2019-7-5)
 */
+ (NSString *)ly_timeCompareToNowWithTimestamp:(NSString *)timestamp;

/**
 接收者相对现在的时间描述
 
 @return 时间描述 (eg: "刚刚", "三分钟前"等. 注意:超过10天则显示时间戳的日期字符串,如 2019-7-5)
 */
- (NSString *)ly_timeCompareToNow;

/**
 接收者相对参数date的时间描述
 
 @param date 相对date
 @return 时间描述 (eg: "刚刚", "三分钟前"等. 注意:超过10天则显示时间戳的日期字符串,如 2019-7-5)
 */
- (NSString *)ly_timeCompareToDate:(NSDate *)date;


#pragma mark - 格式日期字符串

/**
 获取接收者在指定格式下的日期字符串
 
 @param dateFormat 日期字符串的格式
 @return 日期字符串
 */
- (NSString *)ly_dateStringWithDateFormat:(NSString *)dateFormat;


#pragma mark - 时间戳

/**
 获取当前时间的时间戳, 默认毫秒
 
 @return 时间戳
 */
+ (NSString *)ly_currentTimestamp;

/**
 获取当前时间的时间戳, 可以指定精度(毫秒/秒)
 
 @param accuracy 精度
 @return 时间戳
 */
+ (NSString *)ly_currentTimestampWithAccuracy:(LYTimestampAccuracy)accuracy;

/**
 获取接收者对应的时间戳, 默认毫秒
 
 @return 时间戳
 */
- (NSString *)ly_timestamp;

/**
 获取接收者对应的时间戳, 可以指定精度(毫秒/秒)
 
 @param accuracy 精度
 @return 时间戳
 */
- (NSString *)ly_timestampWithAccuracy:(LYTimestampAccuracy)accuracy;


#pragma mark - Components
/**
 获取接收者在一周中的位置(第几天. 注意: 1 表示周日, 2 表示周一)

 @return 一周中的第几天
 */
- (NSInteger)ly_weekday;

/**
 获取时间戳代表的时间在一周中的位置(第几天. 注意: 1 表示周日, 2 表示周一)
 
 @param timestamp 时间戳
 @return 一周中的第几天
 */
+ (NSInteger)ly_weekdayFromTimestamp:(NSString *)timestamp;
#pragma mark -

@end


@interface NSString (LYDateTool)


#pragma mark - 时间戳与日期字符串互转
/**
 由时间戳字符串得到格式化的日期字符串
 
 @param timestamp 时间戳
 @param dateFormat 日期字符串的格式 (eg: yyyy-MM-dd HH:mm:ss SS)
 @return 日期字符串
 */
+ (NSString *)ly_dateStringWithTimestamp:(NSString *)timestamp dateFormat:(NSString *)dateFormat;

/**
 由格式化的日期字符串得到时间戳(字符串), 默认毫秒
 
 @param dateString 日期字符串
 @param dateFormat 日期字符串的格式 (eg: yyyy-MM-dd HH:mm:ss SS)
 @return 时间戳(字符串)
 */
+ (NSString *)ly_timestampWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/**
 由格式化的日期字符串得到时间戳(字符串), 可以指定时间戳的精度(毫秒/秒)
 
 @param dateString 日期字符串
 @param dateFormat 日期字符串的格式 (eg: yyyy-MM-dd HH:mm:ss SS)
 @param accuracy 精度
 @return 时间戳(字符串)
 */
+ (NSString *)ly_timestampWithDateString:(NSString *)dateString
                              dateFormat:(NSString *)dateFormat
                                accuracy:(LYTimestampAccuracy)accuracy;
#pragma mark -

@end

NS_ASSUME_NONNULL_END
