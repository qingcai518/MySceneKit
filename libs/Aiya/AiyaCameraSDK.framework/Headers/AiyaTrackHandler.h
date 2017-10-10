//
//  AiyaTrackHandler.h
//  AiyaCameraSDK
//
//  Created by 汪洋 on 2017/7/6.
//  Copyright © 2017年 深圳哎吖科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceData.h"

@interface AiyaTrackHandler : NSObject


/**
 人脸跟踪处理

 @param pixelBuffer BGRA数据
 @param width 宽度 需要是16的倍数,AiyaCamera中是176
 @param height 高度
 @param trackData 人脸跟踪返回的数据
 @return 人脸跟踪是否成功 0 表示成功 1 表示失败
 */
- (int)trackWithPixelBuffer:(unsigned char*)pixelBuffer bufferWidth:(int)width bufferHeight:(int)height trackData:(FaceData *)trackData;

@end
