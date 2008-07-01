//
//  FVBitmapContextCache.m
//  FileView
//
//  Created by Adam Maxwell on 10/21/07.
/*
 This software is Copyright (c) 2007-2008
 Adam Maxwell. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 - Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the
 distribution.
 
 - Neither the name of Adam Maxwell nor the names of any
 contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FVBitmapContextCache.h"
#import "FVCGImageUtilities.h"
#import <mach/mach.h>
#import <mach/vm_map.h>

// discard indexed color images (e.g. GIF) and convert to RGBA for FVCGImageDescription compatibility
static inline bool __FVColorSpaceIsIncompatible(CGImageRef image)
{
    CGColorSpaceRef cs = CGImageGetColorSpace(image);
    return CGColorSpaceGetNumberOfComponents(cs) != 3 && CGColorSpaceGetNumberOfComponents(cs) != 1;
}

// may add more checks here in future
bool FVImageIsIncompatible(CGImageRef image)
{
    return __FVColorSpaceIsIncompatible(image) || CGImageGetBitsPerComponent(image) != 8;
}

__attribute__ ((constructor))
static void __WorkaroundNSRoundUpToMultipleOfPageSize()
{
    // workaround for NSRoundUpToMultipleOfPageSize: http://www.cocoabuilder.com/archive/message/cocoa/2008/3/5/200500
    (void)NSPageSize();
}

CGContextRef FVIconBitmapContextCreateWithSize(size_t width, size_t height)
{
    size_t bitsPerComponent = 8;
    size_t nComponents = 4;
    size_t bytesPerRow = FVPaddedRowBytesForWidth(nComponents, width);
    
    size_t requiredDataSize = bytesPerRow * height;
    
    /* 
     CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB) gives us a device independent colorspace, but we don't care in this case, since we're just drawing to the screen, and color conversion when blitting the CGImageRef is a pretty big hit.  See http://www.cocoabuilder.com/archive/message/cocoa/2002/10/31/56768 for additional details, including a recommendation to use alpha in the highest 8 bits (ARGB) and use kCGRenderingIntentAbsoluteColorimetric for rendering intent.
     */
    
    /*
     From John Harper on quartz-dev: http://lists.apple.com/archives/Quartz-dev/2008/Feb/msg00045.html
     "Since you are creating the images you give to CA in the GenericRGB color space, CA will have to copy each image and color-match it to the display before they can be uploaded to the GPU. So the first thing I would try is using a DisplayRGB colorspace when you create the bitmap context. Also, to avoid having the graphics card make another copy, you should align the row bytes of the new image to at least 64 bytes. Finally, it's normally best to create BGRA images on intel machines and ARGB on ppc, so that would be the image format (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host)."
     
     Based on the older post outlined above, I was already using a device RGB colorspace, but former information indicated that 16 byte row alignment was best, and I was using ARGB on both ppc and x86.  Not sure if the alignment comment is completely applicable since I'm not interacting directly with the GPU, but it shouldn't hurt.
     */
    
    char *bitmapData;
    kern_return_t ret;
    ret = vm_allocate(mach_task_self(), (vm_address_t *)&bitmapData, NSRoundUpToMultipleOfPageSize(requiredDataSize), VM_FLAGS_ANYWHERE);
    if (0 != ret) return NULL;
    
    CGColorSpaceRef cspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctxt;
    CGBitmapInfo bitmapInfo = (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    ctxt = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, cspace, bitmapInfo);
    CGColorSpaceRelease(cspace);
    
    CGContextSetRenderingIntent(ctxt, kCGRenderingIntentAbsoluteColorimetric);
    
    // note that bitmapData and the context itself are allocated and not freed here
    
    return ctxt;
}

void FVIconBitmapContextDispose(CGContextRef ctxt)
{
    void *bitmapData = CGBitmapContextGetData(ctxt);
    if (bitmapData) vm_deallocate(mach_task_self(), (vm_address_t)bitmapData, NSRoundUpToMultipleOfPageSize(CGBitmapContextGetBytesPerRow(ctxt) * CGBitmapContextGetHeight(ctxt)));
    CGContextRelease(ctxt);
}

