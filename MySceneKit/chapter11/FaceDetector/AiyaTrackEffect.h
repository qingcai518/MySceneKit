//
//  AiyaTrackEffect.h
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <AiyaCameraSDK/FaceData.h>

@interface AiyaTrackEffect : NSObject
/**
 更新人脸跟踪数据
 
 @param byteBuffer BGRA数据
 @param width 数据宽度
 @param height 数据高度
 */
- (void)trackFaceWithByteBuffer:(GLubyte *)byteBuffer width:(GLuint)width height:(GLuint)height;


/**
 绘制特征点

 @param texture 原始纹理
 @param width 纹理宽度
 @param height 纹理高度
 */
- (void)drawTrackPointWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

-(FaceData) getFaceData;
-(Boolean) trackSuccess;
@end
