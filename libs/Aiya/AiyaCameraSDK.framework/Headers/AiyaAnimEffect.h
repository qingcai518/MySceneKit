//
//  AiyaAnimEffect.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/6/22.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AiyaAnimEffect : NSObject

/**
 设置特效,通过设置特效文件路径的方式
 */
@property (nonatomic, copy) NSString *effectPath;

/** 
 设置特效播放次数 默认0 0表示一直渲染当前特效
 */
@property (nonatomic, assign) NSUInteger effectPlayCount;

/** 
 特效播放状态 AIYA_EFFECT_STATUS
 */
@property (nonatomic, assign, readonly) int effectStatus;

/**
 初始化上下文
 
 @param width 保留字段,传0
 @param height 保留字段,传0
 */
- (void)initEffectContextWithWidth:(GLuint)width height:(GLuint)height;

/**
 绘制特效
 
 @param texture 保留字段,传0
 @param width 宽度
 @param height 高度
 */
- (void)processWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

/**
 销毁上下文
 */
- (void)deinitEffectContext;



@end
