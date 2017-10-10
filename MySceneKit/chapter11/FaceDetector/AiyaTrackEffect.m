//
//  AiyaTrackEffect.m
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import "AiyaTrackEffect.h"
#import <AiyaCameraSDK/AiyaCameraSDK.h>
#import <AiyaCameraSDK/FaceData.h>
#import "AiyaGLDrawPoint.h"

@interface AiyaTrackEffect (){
    AiyaTrackHandler *aiyaTrackHandler;
    FaceData faceData;
    BOOL trackResult;
    
    AiyaGLDrawPoint *drawPint;
    
}

@end

@implementation AiyaTrackEffect
- (instancetype)init
{
    self = [super init];
    if (self) {
        aiyaTrackHandler = [[AiyaTrackHandler alloc]init];
        
        [AiyaLicenseManager initLicense:@"704705f35759"];
        
        drawPint = [[AiyaGLDrawPoint alloc]init];
    }
    return self;
}

- (void)trackFaceWithByteBuffer:(GLubyte *)byteBuffer width:(GLuint)width height:(GLuint)height{
    
    int result = [aiyaTrackHandler trackWithPixelBuffer:byteBuffer bufferWidth:width bufferHeight:height trackData:&faceData];
    
    if (result == 0) {
        // NSLog(@"track 成功");
        trackResult = YES;
    }else {
        // NSLog(@"track 失败");
        trackResult = NO;
    }
}

- (void)drawTrackPointWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height{
    
    [drawPint drawTrackPointWithTexture:texture width:width height:height FaceData:&faceData trackResult:trackResult];
}

- (FaceData) getFaceData {
    return faceData;
}

- (Boolean) trackSuccess {
    return trackResult;
}

@end
