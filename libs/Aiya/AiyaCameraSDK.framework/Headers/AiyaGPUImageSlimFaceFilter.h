//
//  AiyaGPUImageSlimFaceFilter.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/7/6.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//

#import "AYGPUImageFilter.h"
#import "AiyaCameraEffect.h"

@interface AiyaGPUImageSlimFaceFilter : AYGPUImageFilter

@property (nonatomic, assign) float slimFaceScale;

- (id)initWithAiyaCameraEffect:(AiyaCameraEffect *)cameraEffect;

@end
