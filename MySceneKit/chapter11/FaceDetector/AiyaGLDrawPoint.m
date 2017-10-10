//
//  AiyaGLDrawPoint.m
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import "AiyaGLDrawPoint.h"
#import <GPUImage/GPUImage.h>

NSString *const kPointVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 uniform float pointSize;
 uniform mat4 transformMatrix;

 void main()
 {
     gl_Position = transformMatrix * position ;
     gl_PointSize = pointSize;
 }
 );

NSString *const kPointFragmentShaderString = SHADER_STRING
(
 
 void main()
 {
     gl_FragColor = vec4(0, 1, 0, 1);
 }
 );

NSString *const kStickerVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 uniform mat4 transformMatrix;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = transformMatrix * position ;
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

static const GLfloat squareVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
};

static const GLfloat textureCoordinates[] = {
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
};

static const GLfloat uvVertices[] = {
    0, 1,
    1, 1,
    0, 0,
    1, 0
};

@interface AiyaGLDrawPoint (){
    GLProgram *dataProgram;
    GLint dataPositionAttribute, dataTextureCoordinateAttribute, dataInputTextureUniform;
    
    GLProgram *pointProgram;
    GLint pointPositionAttribute, pointSizeUniform, transformMatrixUniform;
    
    GLProgram *stickerProgram;
    GLint stickerPositionAttribute, stickerTextureCoordinateAttribute, stickerInputTextureUniform, stickerTransformMatrixUniform;
    
    GLuint stickerTexture[20];
    CGSize stickerSize;
    
    // gif frame index
    CGFloat animationTime;
    NSMutableArray *frames;
    int index;
}

@end

@implementation AiyaGLDrawPoint

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [GPUImageContext useImageProcessingContext];
        dataProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImagePassthroughFragmentShaderString];
        if (!dataProgram.initialized)
        {
            [dataProgram addAttribute:@"position"];
            [dataProgram addAttribute:@"inputTextureCoordinate"];
            if (![dataProgram link])
            {
                NSString *progLog = [dataProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [dataProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [dataProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                dataProgram = nil;
            }
        }
        dataPositionAttribute = [dataProgram attributeIndex:@"position"];
        dataTextureCoordinateAttribute = [dataProgram attributeIndex:@"inputTextureCoordinate"];
        dataInputTextureUniform = [dataProgram uniformIndex:@"inputImageTexture"];
        
        
        
        pointProgram = [[GPUImageContext sharedImageProcessingContext]programForVertexShaderString:kPointVertexShaderString fragmentShaderString:kPointFragmentShaderString];
        if (!pointProgram.initialized)
        {
            [pointProgram addAttribute:@"position"];
            if (![pointProgram link])
            {
                NSString *progLog = [pointProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [pointProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [pointProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                pointProgram = nil;
            }
        }
        pointPositionAttribute = [pointProgram attributeIndex:@"position"];
        pointSizeUniform = [pointProgram uniformIndex:@"pointSize"];
        transformMatrixUniform = [pointProgram uniformIndex:@"transformMatrix"];
        
        // sticker program.
        stickerProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kStickerVertexShaderString fragmentShaderString:kGPUImagePassthroughFragmentShaderString];
        if (!stickerProgram.initialized)
        {
            [stickerProgram addAttribute:@"position"];
            [stickerProgram addAttribute:@"inputTextureCoordinate"];
            if (![stickerProgram link])
            {
                NSString *progLog = [stickerProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [stickerProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [stickerProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                stickerProgram = nil;
            }
        }
        
        stickerPositionAttribute = [stickerProgram attributeIndex:@"position"];
        stickerTextureCoordinateAttribute = [stickerProgram attributeIndex:@"inputTextureCoordinate"];
        stickerInputTextureUniform = [stickerProgram uniformIndex:@"inputImageTexture"];
        stickerTransformMatrixUniform = [stickerProgram uniformIndex:@"transformMatrix"];

//        [self loadStickerImage];
        [self loadGif];
    }
    return self;
}

- (void)loadGif {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"panda" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];

    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
//  glBlendFunc(GL_ONE, GL_SRC_COLOR);    // 有背景色
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);

    if (src) {
        size_t imageCount = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:imageCount];
        for (size_t i = 0; i < imageCount; i++) {
            CGImageRef cgImageRef = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (cgImageRef) {
                [frames addObject:[UIImage imageWithCGImage:cgImageRef]];

                GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
                GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
                CGRect rect = CGRectMake(0, 0, width, height);
                
                if (stickerSize.width == 0) {
                    stickerSize = rect.size;
                }
                
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                void *imageData = malloc(width * height * 4);
                CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
                CGContextTranslateCTM(context, 0, height);
                CGContextScaleCTM(context, 1.0f, -1.0f);
                CGColorSpaceRelease(colorSpace);
                CGContextClearRect(context, rect);
                CGContextDrawImage(context, rect, cgImageRef);
                
                glGenTextures(1, &stickerTexture[i]);
                glBindTexture(GL_TEXTURE_2D, stickerTexture[i]);
                
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
                
                CGContextRelease(context);
                free(imageData);
                
                CGImageRelease(cgImageRef);
            }
        }
        CFRelease(src);
    }
    
    NSLog(@"animation time = %f", animationTime);
    NSLog(@"frames = %lu", (unsigned long)frames.count);
}

- (void) loadStickerImage {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"maohuzi" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    stickerSize = image.size;
    
    CGImageRef cgImageRef = [image CGImage];
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImageRef);
    
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_SRC_COLOR);    // 有背景色
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glGenTextures(1, &stickerTexture[0]);
    glBindTexture(GL_TEXTURE_2D, stickerTexture[0]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

    CGContextRelease(context);
    free(imageData);
}

- (void)drawTrackPointWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height FaceData:(FaceData *)faceData trackResult:(BOOL)trackResult{
    
    //绘制原始画面
    [GPUImageContext setActiveShaderProgram:dataProgram];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(dataInputTextureUniform, 4);
    
    glVertexAttribPointer(dataPositionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
    glVertexAttribPointer(dataTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glEnableVertexAttribArray(dataPositionAttribute);
    glEnableVertexAttribArray(dataTextureCoordinateAttribute);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if (trackResult) {
        //绘制特征点
        [GPUImageContext setActiveShaderProgram:pointProgram];
        
        GPUMatrix4x4 matrix;
        CATransform3D tranform = CATransform3DIdentity;
        tranform = CATransform3DRotate(tranform, M_PI, 0, 0, 1);
        tranform = CATransform3DRotate(tranform, M_PI, 0, 1, 0);
        tranform = CATransform3DScale(tranform, 2, 2, 1);
        tranform = CATransform3DTranslate(tranform, -0.5, -0.5, 0);
        
        [self convert3DTransform:&tranform toMatrix:&matrix];
        
        glUniformMatrix4fv(transformMatrixUniform, 1, GL_FALSE, (GLfloat *)&matrix);
        glUniform1f(pointSizeUniform, 7.0f);
        glVertexAttribPointer(pointPositionAttribute, 2, GL_FLOAT, 0, 0, faceData->featurePoints2D);
        
        glEnableVertexAttribArray(pointPositionAttribute);
        
        glDrawArrays(GL_POINTS, 0, faceData->numfeaturePoints2D);
        
        // 绘制贴图.
        float rotateX = floor(faceData->faceRotation[0]*10) / 10;
        float rotateY = floor(faceData->faceRotation[1]*10) / 10;
        float rotateZ = floor(faceData->faceRotation[2]*10) / 10;
        float translateX = faceData->faceTranslation[0];
        float translateY = faceData->faceTranslation[1];
        float translateZ = faceData->faceTranslation[2];
        
        NSLog(@"rotate = %f, %f, %f", rotateX, rotateY, rotateZ);

        [GPUImageContext setActiveShaderProgram:stickerProgram];
        float lbX = faceData->featurePoints2D[19][0];
        float lbY = faceData->featurePoints2D[19][1];
        float rbX = faceData->featurePoints2D[24][0];
        float rbY = faceData->featurePoints2D[24][1];

        float width = rbX - lbX;
        float height = (width / stickerSize.width) * stickerSize.height / 2;

        // 上面的坐标.
        float ltX = lbX - width * rotateZ;
        float ltY = lbY + height * (1 - fabsf(rotateX));
        float rtX = rbX - width * rotateZ;
        float rtY = rbY + height * (1 - fabsf(rotateX));
        
        // draw texture.
        float time = animationTime / frames.count;
        NSTimer *timer = [NSTimer timerWithTimeInterval:time repeats:false block:^(NSTimer * _Nonnull timer) {
            // draw texture.
            glActiveTexture(GL_TEXTURE5);
            glBindTexture(GL_TEXTURE_2D, stickerTexture[index]);
            glUniform1i(stickerInputTextureUniform, 5);

            GPUMatrix4x4 matrix2;
            CATransform3D tranform2 = CATransform3DIdentity;
            tranform2 = CATransform3DRotate(tranform2, M_PI, 0, 0, 1);
            tranform2 = CATransform3DRotate(tranform2, M_PI, 0, 1, 0);
            tranform2 = CATransform3DScale(tranform2, 2, 2, 1);
            tranform2 = CATransform3DTranslate(tranform2, -0.5, -0.5, 0);

            tranform2 = CATransform3DRotate(tranform2, M_PI / 2 * rotateX, 1, 0, 0);
            tranform2 = CATransform3DRotate(tranform2, -M_PI / 2 * rotateY, 0, 1, 0);

            [self convert3DTransform:&tranform2 toMatrix:&matrix2];

            glUniformMatrix4fv(stickerTransformMatrixUniform, 1, GL_FALSE, (GLfloat *)&matrix2);

//            GLfloat stVertices[] = {
//                0.25, 0.35, 0,
//                0.4, 0.35, 0,
//                0.25, 0.25, 0,
//                0.4, 0.25, 0
//            };

            GLfloat stVertices[] = {
                ltX, ltY, 0,
                rtX, rtY, 0,
                lbX, lbY, 0,
                rbX, rbY, 0
            };


            glVertexAttribPointer(stickerPositionAttribute, 3, GL_FLOAT, 0, 0, stVertices);
            glVertexAttribPointer(stickerTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, uvVertices);

            glEnableVertexAttribArray(stickerPositionAttribute);
            glEnableVertexAttribArray(stickerTextureCoordinateAttribute);

            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

            // do count.
            if (index == frames.count - 1) {
                index = 0;
            } else {
                index = index + 1;
            }
        }];

        [timer fire];
    }
}

- (void)convert3DTransform:(CATransform3D *)transform3D toMatrix:(GPUMatrix4x4 *)matrix;
{
    
    GLfloat *mappedMatrix = (GLfloat *)matrix;
    
    mappedMatrix[0] = (GLfloat)transform3D->m11;
    mappedMatrix[1] = (GLfloat)transform3D->m12;
    mappedMatrix[2] = (GLfloat)transform3D->m13;
    mappedMatrix[3] = (GLfloat)transform3D->m14;
    mappedMatrix[4] = (GLfloat)transform3D->m21;
    mappedMatrix[5] = (GLfloat)transform3D->m22;
    mappedMatrix[6] = (GLfloat)transform3D->m23;
    mappedMatrix[7] = (GLfloat)transform3D->m24;
    mappedMatrix[8] = (GLfloat)transform3D->m31;
    mappedMatrix[9] = (GLfloat)transform3D->m32;
    mappedMatrix[10] = (GLfloat)transform3D->m33;
    mappedMatrix[11] = (GLfloat)transform3D->m34;
    mappedMatrix[12] = (GLfloat)transform3D->m41;
    mappedMatrix[13] = (GLfloat)transform3D->m42;
    mappedMatrix[14] = (GLfloat)transform3D->m43;
    mappedMatrix[15] = (GLfloat)transform3D->m44;
}
@end
