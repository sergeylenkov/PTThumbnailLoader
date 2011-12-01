//
//  PTThumbnailLoader.h
//
//  Created by Sergey Lenkov on 13.07.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTThumbnailLoader;

@protocol PTThumbnailLoaderDelegate 

- (void)thumbnailLoader:(PTThumbnailLoader *)loader didLoad:(NSIndexPath *)indexPath;
- (void)thumbnailLoader:(PTThumbnailLoader *)loader didFail:(NSError *)error;

@end

typedef void (^PTThumbnailLoaderResultBlock)(UIImage *image);
typedef void (^PTThumbnailLoaderFailureBlock)(NSError *error);

@interface PTThumbnailLoader : NSObject {
    NSURL *url;
    UIImage *image;
    NSIndexPath *indexPath;
    NSString *cacheFile;
    id <PTThumbnailLoaderDelegate> delegate;
    NSMutableData *imageData;
    NSURLConnection *connection;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *cacheFile;
@property (nonatomic, assign) id <PTThumbnailLoaderDelegate> delegate;
@property (nonatomic, copy) PTThumbnailLoaderResultBlock resultBlock;
@property (nonatomic, copy) PTThumbnailLoaderFailureBlock failureBlock;

- (void)downloadImage:(NSURL *)aUrl withResultBlock:(PTThumbnailLoaderResultBlock)aResultBlock failureBlock:(PTThumbnailLoaderFailureBlock)aFailureBlock;
- (void)startDownload;
- (void)didFinished;

@end
