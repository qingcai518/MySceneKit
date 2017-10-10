//
//  AiyaGLDrawPoint.h
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AiyaCameraSDK/FaceData.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface AiyaGLDrawPoint : NSObject


/**
 绘制特征点

 @param texture 原始纹理数据
 @param width 纹理宽度
 @param height 纹理高度
 @param faceData 人脸数据
 @param trackResult 人脸数据是否有效
 */
- (void)drawTrackPointWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height FaceData:(FaceData *)faceData trackResult:(BOOL)trackResult;


@end
