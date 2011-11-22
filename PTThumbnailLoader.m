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

- (void)dealloc {
    [url release];
    [image release];
    [indexPath release];
    [cacheFile release];
    [imageData release];
    [connection release];
    [super dealloc];
}

- (void)startDownload {
    imageData = [[NSMutableData data] retain];
    connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    if (delegate) {
        [delegate thumbnailLoader:self didFail:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    self.image = [UIImage imageWithData:imageData];
    
    if (cacheFile) {
        [imageData writeToFile:cacheFile atomically:YES];
    }
    
    if (delegate) {
        [delegate thumbnailLoader:self didLoad:indexPath];
    }
}

@end
