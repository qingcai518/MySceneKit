//
//  AiyaDrawTrackPointFilter.m
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import "AiyaDrawTrackPointFilter.h"

@interface AiyaDrawTrackPointFilter ()

@property (nonatomic, weak) AiyaTrackEffect *trackEffect;

@end

@implementation AiyaDrawTrackPointFilter

- (id)initWithAiyaTrackEffect:(AiyaTrackEffect *)trackEffect{
    if (!(self = [super init])){
        return nil;
    }
    
    _trackEffect = trackEffect;
    
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;{
    if (self.preventRendering){
        [firstInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    //------------->绘制Track图像<--------------//
    [self.trackEffect drawTrackPointWithTexture:[firstInputFramebuffer texture] width:outputFramebuffer.size.width height:outputFramebuffer.size.width];
    
    [filterProgram use];
    //------------->绘制Track图像<--------------//
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
    
}


@end
