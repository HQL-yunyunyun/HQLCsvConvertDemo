//
//  main.m
//  csvConvertToPlist
//
//  Created by 何启亮 on 2017/11/22.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HQLConvertHelper.h"

#import "HQLDepartmentModel.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
       
        NSString *path = @"/Users/heqiliang/Desktop/帮助/Sheet1-表格 1.csv";
        NSArray *array = [HQLConvertHelper csvConvertToPlistWithFile:path];
        
        NSMutableArray *targetArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            
            NSMutableDictionary *currentDict = nil;
            for (NSMutableDictionary *dict2 in targetArray) {
                if ([dict[@"questionCategory"] isEqualToString:dict2[@"questionCategory"]]) {
                    currentDict = dict2;
                    break;
                }
            }
            
            if (currentDict) {
                NSMutableArray *questions = currentDict[@"questions"];
                if (!questions) {
                    questions = [NSMutableArray array];
                    currentDict[@"questions"] = questions;
                }
                [questions addObject:@{@"question" : dict[@"question"], @"answer" : dict[@"answer"]}];
            } else {
                currentDict = [NSMutableDictionary dictionary];
                currentDict[@"questionCategory"] = dict[@"questionCategory"];
                NSMutableArray *questions = [NSMutableArray array];
                [questions addObject:@{@"question" : dict[@"question"], @"answer" : dict[@"answer"]}];
                currentDict[@"questions"] = questions;
                [targetArray addObject:currentDict];
            }
        }
        
        NSString *plistPath = @"/Users/heqiliang/Desktop/target.plist";
        [targetArray writeToFile:plistPath atomically:YES];
    }
    return 0;
}

    /* 2018.1.10
- (void)test {
    NSString *staffPath = @"/Users/heqiliang/Desktop/表/新增实名用户奖励 2.csv";
    NSArray *staffArray = [HQLConvertHelper csvConvertToPlistWithFile:staffPath];
    NSLog(@"staffArray count %ld", staffArray.count);
    
    NSString *basePath = @"/Users/heqiliang/Desktop/表/新增实名注册用户-表格 1.csv";
    NSArray *baseArray = [HQLConvertHelper csvConvertToPlistWithFile:basePath];
    NSLog(@"baseArray count %ld", baseArray.count);
    
    NSMutableArray <HQLDepartmentModel *>*departmentArray = [NSMutableArray array];
    HQLDepartmentModel *currentDepartment = nil;
    
    for (NSDictionary *dict in staffArray) {
        
        NSString *dName = dict[@"部门"]; // 部门
        if (!dName) {
            dName = @"";
        }
        if (![dName isEqualToString:@""] || ([dName isEqualToString:@""] && !currentDepartment)) {
            if (currentDepartment) {
                [departmentArray addObject:currentDepartment];
            }
            
            currentDepartment = [[HQLDepartmentModel alloc] init];
            currentDepartment.dName = dName;
        }
        
        NSString *subName = dict[@"default1"];
        if (!subName) {
            subName = @"";
        }
        if (![subName isEqualToString:@""] || ([subName isEqualToString:@""] && currentDepartment.subDepartmentArray.count == 0)) {
            HQLSubDepartmentModel *subDepartment = [[HQLSubDepartmentModel alloc] init];
            subDepartment.subName = subName;
            [currentDepartment.subDepartmentArray addObject:subDepartment];
        }
        
        NSString *pName = dict[@"姓名"]; // 姓名
        if (!pName) {
            pName = @"";
        }
        if (![pName isEqualToString:@""]) {
            HQLPersonModel *person = [[HQLPersonModel alloc] init];
            person.pName = pName;
            person.duty = dict[@"职务"];
            HQLSubDepartmentModel *sub = currentDepartment.subDepartmentArray.lastObject;
            [sub.personArray addObject:person];
        }
        
        NSString *peopel = dict[@"default4"];
        if (!peopel) {
            peopel = @"";
        }
    }
    
    if (currentDepartment) {
        [departmentArray addObject:currentDepartment];
        currentDepartment = nil;
    }
    
    NSInteger departmentCount = departmentArray.count;
    NSInteger personCount = 0;
    
    // 合并两个表
    for (HQLDepartmentModel *department in departmentArray) {
        for (HQLSubDepartmentModel *subDepartment in department.subDepartmentArray ) {
            personCount += subDepartment.personArray.count;
            for (HQLPersonModel *person in subDepartment.personArray) {
                
                for (NSMutableDictionary *dict in baseArray) {
                    if (![dict.allKeys containsObject:@"flag"]) {
                        [dict setValue:[NSNumber numberWithBool:NO] forKey:@"flag"];
                    }
                    if ([dict[@"顶级归属"] isEqualToString:person.pName] ) {
                        [person.peopelArray addObject:dict];
                        
                        // 记录
                        dict[@"flag"] = [NSNumber numberWithBool:YES];
                    }
                }
                
            }
        }
    }
    
    NSLog(@"departmentcount %ld, personcount %ld", departmentCount, personCount);
    
    // 合成csv
    NSString *spaceChart = @"\n";
    
    NSMutableString *targetString = [NSMutableString string];
    [targetString appendString:@"部门,,姓名,职务,姓名,手机号码,身份,上级归属,顶级归属,注册时间"];
    [targetString appendString:spaceChart];
    
    for (HQLDepartmentModel *department in departmentArray) {
        
        BOOL isShowDepartmentName = YES;
        for (HQLSubDepartmentModel *subDepartment in department.subDepartmentArray) {
            
            BOOL isShowSubDepartmentName = YES;
            for (HQLPersonModel *person in subDepartment.personArray) {
                
                for (int i = 0; i < person.peopelArray.count; i++) {
                    NSDictionary *dict = person.peopelArray[i];
                    
                    NSString *dName = @"";
                    NSString *subName = @"";
                    NSString *pName = @"";
                    NSString *duty = @"";
                    if (i == 0) {
                        dName = isShowDepartmentName ? department.dName : @"";
                        subName = isShowSubDepartmentName ? subDepartment.subName : @"";
                        pName = person.pName;
                        duty = person.duty;
                    }
                    
                    //姓名,手机号码,身份,上级归属,顶级归属,注册时间
                    NSString *peopelString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", dict[@"姓名"], dict[@"手机号码"], dict[@"身份"], dict[@"上级归属"], dict[@"顶级归属"], dict[@"注册时间"]];
                    
                    NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", dName, subName, pName, duty, peopelString];
                    [targetString appendString:line];
                    [targetString appendString:spaceChart];
                    
                    if (isShowDepartmentName) {
                        isShowDepartmentName = NO;
                    }
                    if (isShowSubDepartmentName) {
                        isShowSubDepartmentName = NO;
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // 目标
    NSString *targetPath = @"/Users/heqiliang/Desktop/target.csv";
    [targetString writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *noneString = [NSMutableString string];
    [noneString appendString:@"姓名,手机号码,身份,上级归属,顶级归属,注册时间"];
    [noneString appendString:spaceChart];
    for (NSMutableDictionary *dict in baseArray) {
        if (![dict[@"flag"] boolValue]) {
            NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", dict[@"姓名"], dict[@"手机号码"], dict[@"身份"], dict[@"上级归属"], dict[@"顶级归属"], dict[@"注册时间"]];
            [noneString appendString:line];
            [noneString appendString:spaceChart];
        }
    }
    
    NSString *nonePath = @"/Users/heqiliang/Desktop/none.csv";
    [noneString writeToFile:nonePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}//*/
    
/* 2018.1.9
- (void)test {
    NSString *path = @"/Users/heqiliang/Desktop/总表/Sheet2-表格 1.csv";
    NSArray *array = [HQLConvertHelper csvConvertToPlistWithFile:path];
    
    
    NSMutableArray <HQLDepartmentModel *>*targetArray = [NSMutableArray array];
    HQLDepartmentModel *currentDepartment = nil;
    
    for (NSDictionary *dict in array) {
        
        NSString *dName = dict[@"部门"]; // 部门
        if (!dName) {
            dName = @"";
        }
        if (![dName isEqualToString:@""] || ([dName isEqualToString:@""] && !currentDepartment)) {
            if (currentDepartment) {
                [targetArray addObject:currentDepartment];
            }
            
            currentDepartment = [[HQLDepartmentModel alloc] init];
            currentDepartment.dName = dName;
        }
        
        NSString *subName = dict[@"default1"];
        if (!subName) {
            subName = @"";
        }
        if (![subName isEqualToString:@""] || ([subName isEqualToString:@""] && currentDepartment.subDepartmentArray.count == 0)) {
            HQLSubDepartmentModel *subDepartment = [[HQLSubDepartmentModel alloc] init];
            subDepartment.subName = subName;
            [currentDepartment.subDepartmentArray addObject:subDepartment];
        }
        
        NSString *pName = dict[@" 姓 名"]; // 姓名
        if (!pName) {
            pName = @"";
        }
        if (![pName isEqualToString:@""]) {
            HQLPersonModel *person = [[HQLPersonModel alloc] init];
            person.pName = pName;
            person.duty = dict[@"职务"];
            HQLSubDepartmentModel *sub = currentDepartment.subDepartmentArray.lastObject;
            [sub.personArray addObject:person];
        }
        
        NSString *peopel = dict[@"default4"];
        if (!peopel) {
            peopel = @"";
        }
        // 每一条都必须加上去
        HQLSubDepartmentModel *sub = currentDepartment.subDepartmentArray.lastObject;
        HQLPersonModel *person = sub.personArray.lastObject;
        [person.peopelArray addObject:peopel];
        
    }
    
    if (currentDepartment) {
        [targetArray addObject:currentDepartment];
        currentDepartment = nil;
    }
    
    // 计算奖励
    NSInteger totalAward = 0;
    for (HQLDepartmentModel *department in targetArray) {
        
        for (HQLSubDepartmentModel *subDepartment in department.subDepartmentArray) {
            
            for (HQLPersonModel *person in subDepartment.personArray) {
                
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
        
    }
    
    // 合成csv
    NSString *spaceChart = @"\n";
    
    NSMutableString *targetString = [NSMutableString string];
    [targetString appendString:@"部门,, 姓 名,职务,,开店奖励"];
    [targetString appendString:spaceChart];
    
    for (HQLDepartmentModel *department in targetArray) {
        
        BOOL isShowDepartmentName = YES;
        for (HQLSubDepartmentModel *subDepartment in department.subDepartmentArray) {
            
            BOOL isShowSubDepartmentName = YES;
            for (HQLPersonModel *person in subDepartment.personArray) {
                
                int index = 0;
                for (NSString *peopel in person.peopelArray) {
                    
                    NSString *dName = @"";
                    NSString *subName = @"";
                    NSString *pName = @"";
                    NSString *duty = @"";
                    NSString *award = @"";
                    if (index == 0) {
                        dName = isShowDepartmentName ? department.dName : @"";
                        subName = isShowSubDepartmentName ? subDepartment.subName : @"";
                        pName = person.pName;
                        duty = person.duty;
                        award = [NSString stringWithFormat:@"%ld", person.award];
                    }
                    
                    NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", dName, subName, pName, duty, peopel, award];
                    [targetString appendString:line];
                    [targetString appendString:spaceChart];
                    
                    if (isShowDepartmentName) {
                        isShowDepartmentName = NO;
                    }
                    if (isShowSubDepartmentName) {
                        isShowSubDepartmentName = NO;
                    }
                    
                    index++;
                }
                
            }
            
        }
        
    }
    
    // 总数
    NSString *targetPath = @"/Users/heqiliang/Desktop/target.csv";
    [targetString appendString:[NSString stringWithFormat:@"总奖励 : %ld", totalAward]];
    [targetString writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
//*/

/* 2018.1.8
- (void)test {
    NSString *path = @"/Users/heqiliang/Desktop/11-1开始的投资明细.csv";
    NSArray *array = [HQLConvertHelper csvConvertToPlistWithFile:path];
    
    NSString *path2 = @"/Users/heqiliang/Desktop/总表/Sheet2-表格 1.csv";
    NSArray *array2 = [HQLConvertHelper csvConvertToPlistWithFile:path2];
    
    //投资人,投资项目,投资金额(元),年化收益,佣金比率,投资时间,回款时间,折标金额(元),实得佣金(元),顶级归属,上级归属
    NSString *sign = @"\n";
    NSMutableString *targetString = [NSMutableString string];
    
    [targetString appendString:@"投资人,投资项目,投资金额(元),年化收益,佣金比率,投资时间,回款时间,折标金额(元),实得佣金(元),顶级归属,上级归属"];
    [targetString appendString:sign];
    
    for (NSDictionary *dict in array2) {
        NSString *name = dict[@"default4"];
        for (NSDictionary *dict2 in array) {
            NSString *name2 = dict2[@"顶级归属"];
            if ([name isEqualToString:name2]) {
                NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@", dict2[@"投资人"], dict2[@"投资项目"], dict2[@"投资金额(元)"], dict2[@"年化收益"], dict2[@"佣金比率"], dict2[@"投资时间"], dict2[@"回款时间"], dict2[@"折标金额(元)"], dict2[@"实得佣金(元)"], dict2[@"顶级归属"], dict2[@"上级归属"]];
                
                [targetString appendString:string];
                [targetString appendString:sign];
                
            }
        }
    }
    
    NSString *targetPath = @"/Users/heqiliang/Desktop/target.csv";
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:targetPath]) {
        [manager removeItemAtPath:targetPath error:nil];
    }
    
    [targetString writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
//*/
