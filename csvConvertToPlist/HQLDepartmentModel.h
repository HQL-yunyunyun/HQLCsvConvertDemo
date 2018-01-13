//
//  HQLDepartmentModel.h
//  csvConvertToPlist
//
//  Created by 何启亮 on 2018/1/7.
//  Copyright © 2018年 HQL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQLPersonModel : NSObject

@property (nonatomic, copy) NSString *pName; // 名字
@property (nonatomic, copy) NSString *duty; // 职务
@property (nonatomic, strong) NSMutableArray *peopelArray; //人
@property (nonatomic, assign) NSInteger award; // 奖励

@end

@interface HQLSubDepartmentModel : NSObject

@property (nonatomic, copy) NSString *subName; // 分部名称
@property (nonatomic, strong) NSMutableArray <HQLPersonModel *>* personArray;

@end

@interface HQLDepartmentModel : NSObject

@property (nonatomic, copy) NSString *dName; // 部门名称
@property (nonatomic, strong) NSMutableArray <HQLSubDepartmentModel *>*subDepartmentArray;

@end
