//
//  HQLDepartmentModel.m
//  csvConvertToPlist
//
//  Created by 何启亮 on 2018/1/7.
//  Copyright © 2018年 HQL. All rights reserved.
//

#import "HQLDepartmentModel.h"

@implementation HQLPersonModel

- (instancetype)init {
    if (self = [super init]) {
        self.pName = @"";
        self.duty = @"";
        self.peopelArray = [NSMutableArray array];
        self.award = 0;
    }
    return self;
}

@end

@implementation HQLSubDepartmentModel

- (instancetype)init {
    if (self = [super init]) {
        self.subName = @"";
        self.personArray = [NSMutableArray array];
    }
    return self;
}

@end

@implementation HQLDepartmentModel

- (instancetype)init {
    if (self = [super init]) {
        self.dName = @"";
        self.subDepartmentArray = [NSMutableArray array];
    }
    return self;
}

/*
 2018.1.7
 NSString *csvFilePath = @"/Users/heqiliang/Desktop/总表/Sheet2-表格 1.csv";
 NSLog(@"load csv file %@", csvFilePath);
 NSString *content = [NSString stringWithContentsOfFile:csvFilePath encoding:NSUTF8StringEncoding error:nil];
 NSLog(@"content %@", content);
 
 NSMutableArray *baseStationInfoArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
 
 NSMutableArray *deleteArray = [NSMutableArray array];
 for (NSString *s in baseStationInfoArr) {
 if ([s isEqualToString:@""]) {
 [deleteArray addObject:s];
 continue;
 }
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
 NSArray *names = [nameLine componentsSeparatedByString:@","];
 
 [baseStationInfoArr removeObjectAtIndex:0];
 
 NSMutableArray <HQLDepartmentModel *>*targetArray = [NSMutableArray array];
 
 NSString *path = @"/Users/heqiliang/Desktop/target.csv";
 
 NSFileManager *manager = [NSFileManager defaultManager];
 if ([manager fileExistsAtPath:path]) {
 [manager removeItemAtPath:path error:nil];
 }
 
 HQLDepartmentModel *currentDepartment = nil;
 
 for (NSString *string in baseStationInfoArr) {
 NSString *targetString = string;
 // 清除双引号内的逗号
 NSLog(@"before string : %@", targetString);
 NSRange range = [targetString rangeOfString:@"\""];
 while (range.location != NSNotFound) {
 
 NSRange seconedRange = [targetString rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + range.length, targetString.length - (range.location + range.length)) locale:nil];
 
 if (seconedRange.location != NSNotFound) {
 
 NSRange r = NSMakeRange(range.location, (seconedRange.location + seconedRange.length) - range.location);
 
 NSString *operationString = [targetString substringWithRange:r];
 operationString = [operationString stringByReplacingOccurrencesOfString:@"," withString:@""];
 operationString = [operationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
 
 targetString = [targetString stringByReplacingCharactersInRange:r withString:operationString];
 
 } else {
 targetString = [targetString stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:range];
 }
 
 range = [targetString rangeOfString:@"\""];
 }
 
 NSLog(@"after string : %@", targetString);
 
 NSMutableArray *value = [NSMutableArray arrayWithArray:[targetString componentsSeparatedByString:@","]];
 
 [value removeObjectAtIndex:1]; // 移除第二行
 
 NSString *dName = value[0]; // 部门
 if (![dName isEqualToString:@""]) {
 if (currentDepartment) {
 [targetArray addObject:currentDepartment];
 }
 currentDepartment = [[HQLDepartmentModel alloc] init];
 currentDepartment.dName = dName;
 }
 
 NSString *pName = value[1]; // 姓名
 if (![pName isEqualToString:@""]) {
 HQLPersonModel *person = [[HQLPersonModel alloc] init];
 person.pName = pName;
 person.duty = value[2];
 [currentDepartment.personArray addObject:person];
 }
 
 NSString *peopel = value[3];
 if (![peopel isEqualToString:@""]) {
 HQLPersonModel *person = currentDepartment.personArray.lastObject;
 [person.peopelArray addObject:peopel];
 }
 
 }
 
 // 计算奖励
 NSInteger totalAward = 0;
 for (HQLDepartmentModel *department in targetArray) {
 for (HQLPersonModel *person in department.personArray) {
 
 NSInteger base = 4;
 if ([department.dName isEqualToString:@"总经理室"]) {
 base = 19;
 } else {
 if ([person.duty containsString:@"经理"] || [person.duty isEqualToString:@"负责人"]) {
 if ([person.duty isEqualToString:@"拓展经理"]) {
 base = 4;
 } else {
 base = 9;
 }
 } else {
 base = 4;
 }
 }
 
 // 计算奖励
 person.award = (person.peopelArray.count - base) * 30;
 if (person.award >= 300) {
 person.award = 300;
 }
 if (person.award < 0) {
 person.award = 0;
 }
 totalAward += person.award;
 }
 }
 
 // 合成csv
 NSString *spaceChart = @"\n";
 
 NSMutableString *targetString = [NSMutableString string];
 
 for (HQLDepartmentModel *department in targetArray) {
 
 for (HQLPersonModel *person in department.personArray) {
 
 int index = 0;
 for (NSString *peopel in person.peopelArray) {
 
 NSString *dName = @"";
 NSString *pName = @"";
 NSString *duty = @"";
 NSString *award = @"";
 if (index == 0) {
 dName = department.dName;
 pName = person.pName;
 duty = person.duty;
 award = [NSString stringWithFormat:@"%ld", person.award];
 }
 
 NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", dName, pName, duty, peopel, award];
 [targetString appendString:line];
 [targetString appendString:spaceChart];
 
 index++;
 }
 
 }
 
 }
 
 // 总数
 [targetString appendString:[NSString stringWithFormat:@"总奖励 : %ld", totalAward]];
 
 [targetString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
 
 */

@end
