//
//  AiyaEffectHandler.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/2/23.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AiyaGPUImageBeautifyFilter.h"
#import "AiyaGPUImageEffectFilter.h"

@interface AiyaEffectHandler : NSObject

/** 设置美颜等级 默认0 */
@property (nonatomic, assign) AIYA_BEAUTY_LEVEL beautyLevel;

/** 设置美颜类型 默认0 */
@property (nonatomic, assign) AIYA_BEAUTY_TYPE beautyType;

/** 设置滤镜 默认空*/
@property (nonatomic, strong) UIImage *style;

/** 设置滤镜的强度 默认0.8 最高为1*/
@property (nonatomic, assign) CGFloat styleIntensity;

/** 大眼 默认0 最高为1 */
@property (nonatomic, assign) float bigEyesScale;

/** 瘦脸 默认0 最高为1 */
@property (nonatomic, assign) float slimFaceScale;

/**
 设置特效,通过设置特效文件路径的方式,默认空值,空值表示取消渲染特效
 */
@property (nonatomic, copy) NSString *effectPath;

/**
 设置特效播放次数,默认0,0表示一直重复播放当前特效
 */
@property (nonatomic, assign) NSUInteger effectPlayCount;


/**
 使用设置的特效对图像数据进行处理

 @param pixelBuffer 图像数据
 @return 特效播放状态
 */
- (AIYA_EFFECT_STATUS)processWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 使用设置的特效对图像数据进行处理
 
 @param texture 图像数据
 @return 特效播放状态
 */
- (AIYA_EFFECT_STATUS)processWithTexture:(GLuint)texture width:(GLint)width height:(GLint)height;

@end
