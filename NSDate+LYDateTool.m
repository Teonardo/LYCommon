//
//  NSDate+LYDateTool.m
//  DateTransform
//
//  Created by Teonardo on 2019/7/5.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "NSDate+LYDateTool.h"

#pragma mark -
@implementation NSDate (LYDateTool)

#pragma mark - 共享DateFormatter对象
// 获取全局共享的 NSDateFormatter 对象, 避免大量重复创建带来的性能问题.
+ (NSDateFormatter *)ly_sharedDateFormatter:(NSString *)dateFormat {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    [dateFormatter setDateFormat:dateFormat];
    return dateFormatter;
}

#pragma mark - 时间戳转date
// 由时间戳获取 NSDate 对象
+ (NSDate *)ly_dateWithTimestamp:(NSString *)timestamp {
    if (!timestamp) {
        return nil;
    }
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    if (timestamp.length == 13) {
        //时间戳为13位是精确到毫秒的，10位精确到秒, 毫秒的需要转为秒(除以1000)
        timeInterval = timeInterval / 1000;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

#pragma mark - 相对时间描述
+ (NSString *)ly_timeCompareToNowWithTimestamp:(NSString *)timestamp {
    NSDate *date = [self ly_dateWithTimestamp:timestamp];
    return [date ly_timeCompareToNow];
}

// 接收者相对现在的时间描述
- (NSString *)ly_timeCompareToNow {
    return [self ly_timeCompareToDate:[NSDate date]];
}

// 接收者相对参数date的时间描述
- (NSString *)ly_timeCompareToDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    
    NSUInteger upToHours = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *difference = [calendar components:upToHours fromDate:earliest toDate:latest options:0];
    
    NSString *result = nil;
    if (difference.day > 10) {
        result = [self ly_dateStringWithDateFormat:@"yyyy-MM-dd"];
    }
    else if (difference.day > 0) {
        result = [NSString stringWithFormat:@"%@天前", @(difference.day)];
    }
    else if (difference.hour > 0) {
        result = [NSString stringWithFormat:@"%@小时前", @(difference.hour)];
    }
    else if (difference.minute > 0) {
        result = [NSString stringWithFormat:@"%@分钟前", @(difference.minute)];
    }
    else {
        result = @"刚刚";
    }
    
    return result;
}

#pragma mark - 格式日期字符串
// 获取接收者在指定格式下的日期字符串
- (NSString *)ly_dateStringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDate ly_sharedDateFormatter:dateFormat];
    return [dateFormatter stringFromDate:self];
}

#pragma mark - 时间戳
// 获取当前时间的时间戳, 默认毫秒
+ (NSString *)ly_currentTimestamp {
    return [self ly_currentTimestampWithAccuracy:LYTimestampAccuracyMillisecond];
}

// 获取当前时间的时间戳, 可以指定精度(毫秒/秒)
+ (NSString *)ly_currentTimestampWithAccuracy:(LYTimestampAccuracy)accuracy {
    return [[NSDate date] ly_timestampWithAccuracy:accuracy];
}

// 获取接收者对应的时间戳, 默认毫秒
- (NSString *)ly_timestamp {
    return [self ly_timestampWithAccuracy:LYTimestampAccuracyMillisecond];
}

// 获取接收者对应的时间戳, 可以指定精度(毫秒/秒)
- (NSString *)ly_timestampWithAccuracy:(LYTimestampAccuracy)accuracy {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSString *timestamp = nil;
    switch (accuracy) {
        case LYTimestampAccuracyMillisecond:
        {
            timeInterval *= 1000;
            timestamp = [NSString stringWithFormat:@"%013.0lf", timeInterval];
            break;
        }
            
        default:
        {
            timestamp = [NSString stringWithFormat:@"%010.0lf", timeInterval];
            break;
        }
    }
    
    return timestamp;
}

#pragma mark - Components
// 获取接收者在一周中的位置(第几天. 注意: 1 表示周日, 2 表示周一)
- (NSInteger)ly_weekday {
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents =
    [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [dateComponents weekday];
}

// 获取时间戳代表的时间在一周中的位置(第几天. 注意: 1 表示周日, 2 表示周一)
+ (NSInteger)ly_weekdayFromTimestamp:(NSString *)timestamp {
    NSDate *date = [self ly_dateWithTimestamp:timestamp];
    return [date ly_weekday];
}

#pragma mark -

@end


@implementation NSString (LYDateTool)

#pragma mark - 时间戳与日期字符串互转
// 由时间戳字符串得到格式化的日期字符串
+ (NSString *)ly_dateStringWithTimestamp:(NSString *)timestamp dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate ly_dateWithTimestamp:timestamp];
    NSDateFormatter *dateFormatter = [NSDate ly_sharedDateFormatter:dateFormat];
    return [dateFormatter stringFromDate:date];
}

// 由格式化的日期字符串得到时间戳(字符串), 默认毫秒
+ (NSString *)ly_timestampWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    return [self ly_timestampWithDateString:dateString dateFormat:dateFormat accuracy:LYTimestampAccuracyMillisecond];
}

// 由格式化的日期字符串得到时间戳(字符串), 可以指定时间戳的精度(毫秒/秒)
+ (NSString *)ly_timestampWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat accuracy:(LYTimestampAccuracy)accuracy {
    NSDateFormatter *dateFormatter = [NSDate ly_sharedDateFormatter:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [date ly_timestampWithAccuracy:accuracy];
}

#pragma mark -

@end
