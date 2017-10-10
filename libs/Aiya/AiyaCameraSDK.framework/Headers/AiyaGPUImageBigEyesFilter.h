//
//  AiyaGPUImageBigEyesFilter.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/7/6.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//

#import "AYGPUImageFilter.h"
#import "AiyaCameraEffect.h"

@interface AiyaGPUImageBigEyesFilter : AYGPUImageFilter

@property (nonatomic, assign) float bigEyesScale;

- (id)initWithAiyaCameraEffect:(AiyaCameraEffect *)cameraEffect;

@end
