//
//  AiyaBeautifyEffect.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/2/16.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AiyaBeautifyEffect : NSObject

/**
 初始化上下文

 @param width 保留字段,传0
 @param height 保留字段,传0
 */
- (void)initEffectContextWithWidth:(GLuint)width height:(GLuint)height;


/**
 对纹理数据进行美颜

 @param texture 需要美颜的纹理数据
 @param width 纹理数据宽度
 @param height 纹理数据高度
 @param beautyType 美颜类型
 @param beautyLevel 美颜等级
 */
- (void)beautifyFaceWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height beautyType:(NSUInteger)beautyType beautyLevel:(NSInteger) beautyLevel;


/**
 销毁上下文
 */
- (void)deinitEffectContext;


@end
