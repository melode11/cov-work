/*
 Copyright (c) 2007-2011, GlobalLogic Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list
 of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.
 Neither the name of the GlobalLogic Inc. nor the names of its contributors may be
 used to endorse or promote products derived from this software without specific
 prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 OF THE POSSIBILITY OF SUCH DAMAGE."
 */

#define RELEASE(_OBJ_) {if(_OBJ_){[_OBJ_ release];_OBJ_ = nil;}}

#define MAX_PACKET_SIZE		1000
//#define UDP_SERVER_PORT		9696
//#define SERVER_ADDRESS		@"174.129.98.151" //@"172.16.2.33"
//#define SIMULATOR_ADDRESS	@"172.17.163.30"//@"172.17.163.14"
//
//
#define TCP_SERVER_ADDRESS	@"172.17.163.30"  //Simulator  	
//							//@"172.17.6.120" //iPad Nagpur
//							//@"172.16.3.215" //iPad Noida
//
#define X_PIX_NORMALIZED   320.0f
#define Y_PIX_NORMALIZED   412.0f

#define X_PIX_IPAD   508.0f
#define Y_PIX_IPAD   654.0f

#define X_PIX_IPHONE   320.0f
#define Y_PIX_IPHONE   412.0f

#define X_RATIO_IPHONE	(X_PIX_IPHONE/X_PIX_NORMALIZED) //1.6666666667f
#define Y_RATIO_IPHONE 	(Y_PIX_IPHONE/Y_PIX_NORMALIZED) //1.6666666667f

#define X_RATIO_IPAD	(X_PIX_IPAD/X_PIX_NORMALIZED) //1.6666666667f
#define Y_RATIO_IPAD 	(Y_PIX_IPAD/Y_PIX_NORMALIZED) //1.6666666667f
#define YX_ASPECT_RATIO    (Y_PIX_NORMALIZED/X_PIX_NORMALIZED)



#define THUMBNAILSIZE 100
#define REFERENCERECT CGRectMake(800, 630, THUMBNAILSIZE<<1, THUMBNAILSIZE)
typedef enum _AnnotationType
{
	eCircle,
	eDrawing,
    eText,
    eArrow,
	eSnapRequest,
	eSnapResponse,
	eNone,
}AnnotationType;

typedef AnnotationType AnnotationTool;

typedef enum {
    eBrushTool
} HPDrawingTool;

typedef enum {
    eTouchBegin = 1,
    eTouchMove = 2,
    eTouchEnd = 3
} LATouchEvent;

#define DRAWING_VIEW_TAG 6600
