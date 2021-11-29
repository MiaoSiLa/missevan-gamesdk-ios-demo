//
//  CALayer+WeCache.h
//  MissEvanApp
//
//  Created by snowimba on 16/6/24.
//  Copyright © 2016年 com.missevan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
@interface CALayer (WeCache)

- (NSURL *)sd_imageURL;

- (void)sd_setImageWithURL:(NSURL *)url;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(NSURL *)url imageSize:(CGSize)size placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_cancelCurrentImageLoad;

@end
