//
//  HQLConverHelper.m
//  csvConvertToPlist
//
//  Created by 何启亮 on 2018/1/7.
//  Copyright © 2018年 HQL. All rights reserved.
//

#import "HQLConvertHelper.h"

@implementation HQLConvertHelper

+ (NSMutableArray<NSMutableDictionary *> *)csvConvertToPlistWithFile:(NSString *)path {
    NSLog(@"load csv file %@", path);
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *baseStationInfoArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (NSString *s in baseStationInfoArr) {
        if ([s isEqualToString:@""]) {
            [deleteArray addObject:s];
            continue;
        }
        // 去除空的字典
        NSArray *array = [s componentsSeparatedByString:@","];
        BOOL yesOrNo = YES;
        for (NSString *sub in array) {
            NSString *b = [sub stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![b isEqualToString:@""]) {
                yesOrNo = NO;
                break;
            }
        }
        if (yesOrNo) {
            [deleteArray addObject:s];
        }
    }
    
    [baseStationInfoArr removeObjectsInArray:deleteArray];
    
    NSString *nameLine = [baseStationInfoArr objectAtIndex:0];
    NSMutableArray *names = [NSMutableArray arrayWithArray:[nameLine componentsSeparatedByString:@","]];
    
    NSInteger index = 0;
    NSArray *array = [NSArray arrayWithArray:names];
    for (NSString *string in array) {
        if ([string isEqualToString:@""]) {
            [names removeObjectAtIndex:index];
            [names insertObject:[NSString stringWithFormat:@"default%ld", index] atIndex:index];
        }
        index++;
    }
    
    [baseStationInfoArr removeObjectAtIndex:0];
    
    NSMutableArray <NSMutableDictionary *>*targetArray = [NSMutableArray array];
    
    for (NSString *string in baseStationInfoArr) {
        NSString *targetString = string;
        // 清除双引号内的逗号
        NSRange range = [targetString rangeOfString:@"\""];
        while (range.location != NSNotFound) {
            
            NSRange seconedRange = [targetString rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + range.length, targetString.length - (range.location + range.length)) locale:nil];
            
            if (seconedRange.location != NSNotFound) {
                
                NSRange r = NSMakeRange(range.location, (seconedRange.location + seconedRange.length) - range.location);
                
                // 两个双引号间的字符串 --- 如果要增加其他需要清除的符号在下面弄就好
                NSString *operationString = [targetString substringWithRange:r];
                operationString = [operationString stringByReplacingOccurrencesOfString:@"," withString:@""];
                operationString = [operationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                targetString = [targetString stringByReplacingCharactersInRange:r withString:operationString];
                
            } else {
                targetString = [targetString stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:range];
            }
            
            range = [targetString rangeOfString:@"\""];
        }
        
        // 每一行的value
        NSMutableArray *value = [NSMutableArray arrayWithArray:[targetString componentsSeparatedByString:@","]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < names.count; i++) {
            NSString *vString = @"";
            if (i <= value.count - 1) {
                vString = value[i];
            }
            if ([vString isEqual:[NSNull null]] || !vString) {
                vString = @"";
            }
            [dict setObject:vString forKey:names[i]];
        }
        
        [targetArray addObject:dict];
    }
    
    return targetArray;
}

@end
