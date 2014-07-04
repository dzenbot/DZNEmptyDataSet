//
//  UIImage+Effect.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 4/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "UIImage+Effect.h"
#import "UIColor+Hex.h"
#import "NSObject+System.h"
#import "CGGeometry+Size.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@implementation UIImage (Effect)

- (UIImage *)imageWithMask:(UIImage *)maskImg
{
    CGSize size = self.size;
    
    //// Draws the masked over the background colored image.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

	CGColorSpaceRef colorSpace;
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imageRef = [self CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, bitmapInfo);
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
	CGColorSpaceRelease(colorSpace);
	
	if (context == NULL) return nil;

	CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), maskImg.CGImage);
	CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIImage *maskedImg = [UIImage imageWithCGImage:mainViewContentBitmapContext scale:self.scale orientation:(self.imageOrientation)];
	CGImageRelease(mainViewContentBitmapContext);
    
    UIGraphicsEndImageContext();
    
	return maskedImg;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    //// Draws the background colored image.
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width*[NSObject density], size.height*[NSObject density]);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat minEdgeSize = cornerRadius*2+1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}





- (UIImage *)coloredImage:(UIColor *)color
{
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    UIImage *colorImg = [UIImage imageWithColor:color andSize:size];
    return [colorImg imageWithMask:self];
}

- (UIImage *)imageToGrayscale
{
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(self.size,YES,0.0);
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [self drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}

/**
 Based on Tommy's answer on StackOverflow
 http://stackoverflow.com/questions/6672517/is-programmatically-inverting-the-colors-of-an-image-possible
 */
- (UIImage *)inverted
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = self.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;
            
            // perform the colour inversion
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
//    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGFloat scale = [UIScreen mainScreen].scale+1;
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage scale:scale orientation:self.imageOrientation];
     
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}

- (UIImage *)circular
{
    // Begin a new image that will be the new image with the rounded corners
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [bezierPath addClip];
    
    // Draw the image
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    
    CGPathRef path = [bezierPath CGPath];
    CGContextAddPath(context, path);
    
    CGContextSetLineWidth(context, 0);
    CGContextStrokeEllipseInRect(context, rect);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)circularWithBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width
{
    // Begin a new image that will be the new image with the rounded corners
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [bezierPath addClip];
    
    // Draw the image
    [self drawInRect:rect];
    
    if (color && width > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, YES);

        CGContextSetStrokeColorWithColor(context,color.CGColor);
        
        CGPathRef path = [bezierPath CGPath];
        CGContextAddPath(context, path);
        
        CGContextSetLineWidth(context, width);
        CGContextStrokeEllipseInRect(context, rect);
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)circularWithOutterBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *circularImage = [self circular];

    CGSize canvasSize = CGSizeMake(self.size.width+width, self.size.height+width);
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0);

    CGSize size = CGSizeMake(roundf((self.size.width/scale)+(width/scale)), roundf((self.size.height/scale)+(width/scale)));
    UIImage *circularBorder = [[UIImage imageWithColor:color andSize:size] circular];

    [circularBorder drawAtPoint:CGPointZero];
    
    CGPoint position = CGPointMake(roundf(width/2), roundf(width/2));
    [circularImage drawAtPoint:position];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
