//
//  PTThumbnailLoader.m
//
//  Created by Sergey Lenkov on 13.07.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import "PTThumbnailLoader.h"

@implementation PTThumbnailLoader

@synthesize url;
@synthesize image;
@synthesize indexPath;
@synthesize cacheFile;
@synthesize delegate;
@synthesize resultBlock;
@synthesize failureBlock;

- (void)dealloc {
    [url release];
    [image release];
    [indexPath release];
    [cacheFile release];
    [imageData release];
    [connection release];
    [resultBlock release];
    [failureBlock release];
    [super dealloc];
}

- (void)downloadImage:(NSURL *)aUrl withResultBlock:(PTThumbnailLoaderResultBlock)aResultBlock failureBlock:(PTThumbnailLoaderFailureBlock)aFailureBlock {
    self.url = aUrl;
    self.resultBlock = aResultBlock;
    self.failureBlock = aFailureBlock;

    [self startDownload];
}

- (void)startDownload {
    if (cacheFile && [[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        self.image = [UIImage imageWithContentsOfFile:cacheFile];
        [self didFinished];
    } else {
        imageData = [[NSMutableData data] retain];
        connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    if (delegate) {
        [delegate thumbnailLoader:self didFail:error];
    }
    
    if (self.failureBlock) {
        self.failureBlock(error);
    }    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    self.image = [UIImage imageWithData:imageData];
    
    if (cacheFile) {
        [imageData writeToFile:cacheFile atomically:YES];
    }
    
    [self didFinished];
}

- (void)didFinished {
    if (delegate) {
        [delegate thumbnailLoader:self didLoad:indexPath];
    }
    
    if (self.resultBlock) {
        self.resultBlock(image);
    }
}

@end
