///Users/wudan/Desktop/AiyaTrackDemo/AiyaTrackDemo/AiyaCameraSDK.bundle
//  AiyaTrackInput.h
//  AiyaTrackDemo
//
//  Created by 汪洋 on 2017/7/9.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import "AiyaTrackEffect.h"

@interface AiyaTrackInput : NSObject<GPUImageInput>

- (id)initWithAiyaTrackEffect:(AiyaTrackEffect *)trackEffect;

- (void) doTrack;

@end
