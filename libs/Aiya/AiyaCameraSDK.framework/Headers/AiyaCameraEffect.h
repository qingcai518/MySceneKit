//
//  AiyaCameraEffect.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2016/10/26.
//  Copyright © 2016年 深圳哎吖科技. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AiyaCameraEffect : NSObject

/**
 大眼
 */
@property (nonatomic, assign) float bigEyesScale;

/**
 瘦脸
 */
@property (nonatomic, assign) float slimFaceScale;

/**
 设置特效,通过设置特效文件路径的方式
 */
@property (nonatomic, copy) NSString *effectPath;



/**
 初始化上下文
 
 @param width 保留字段,传0
 @param height 保留字段,传0
 */
- (void)initEffectContextWithWidth:(GLuint)width height:(GLuint)height;

/**
 更新人脸跟踪数据

 @param byteBuffer BGRA数据
 @param width 数据宽度
 @param height 数据高度
 */
- (void)trackFaceWithByteBuffer:(GLubyte *)byteBuffer width:(GLuint)width height:(GLuint)height;

/**
 对纹理数据进行美颜
 
 @param texture 纹理数据
 @param width 纹理数据宽度
 @param height 纹理数据高度
 @param beautyType 美颜类型
 @param beautyLevel 美颜等级
 */
- (void)beautifyFaceWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height beautyType:(NSUInteger)beautyType beautyLevel:(NSUInteger) beautyLevel;

/**
 绘制大眼特效
 
 @param texture 纹理数据
 @param width 纹理数据宽度
 @param height 理数据高度
 */
- (void)processBigEyesWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

/**
 绘制瘦脸特效
 
 @param texture 纹理数据
 @param width 纹理数据宽度
 @param height 理数据高度
 */
- (void)processSlimFaceWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

/**
 绘制特效

 @param texture 纹理数据
 @param width 宽度
 @param height 高度
 @return 特效播放状态 AIYA_EFFECT_STATUS
 */
- (int)processWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

/**
 销毁上下文
 */
- (void)deinitEffectContext;

@end
