//
//  HQLConverHelper.h
//  csvConvertToPlist
//
//  Created by 何启亮 on 2018/1/7.
//  Copyright © 2018年 HQL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQLConvertHelper : NSObject

+ (NSMutableArray <NSMutableDictionary *>*)csvConvertToPlistWithFile:(NSString *)path;

@end
