//
//  AiyaDrawTrackPointFilter.h
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiyaTrackEffect.h"
#import <GPUImage/GPUImage.h>

@interface AiyaDrawTrackPointFilter : GPUImageFilter

- (id)initWithAiyaTrackEffect:(AiyaTrackEffect *)trackEffect;

@end
