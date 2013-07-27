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

#import "LATextAnnotation.h"
#import "LAUtilities.h"
#import "DeviceProfile.h"
#import "LAStyleManager.h"


@implementation LATextAnnotation
@synthesize delegate = _delegate;
@synthesize text;

- (id)initWithFrame:(CGRect)inFrame
{
	if(self = [super initWithFrame:inFrame isReceived:NO])
	{
		
		UIImageView *blurbImage = [[UIImageView alloc] initWithFrame:
								   CGRectMake(0.0f, 0.0f, inFrame.size.width, inFrame.size.height)];
		blurbImage.image = [UIImage imageNamed:@"Green_Transparent_Blurb.png"];
		
		[self addSubview:blurbImage];
		
		CGRect textFrame = inFrame;
		textFrame.origin = CGPointMake(25.0f, 0.0f);
		textFrame.size = CGSizeMake(blurbImage.frame.size.width - 25.0f, 40.0f);
		
		UITextField *textField = [[UITextField alloc] initWithFrame:textFrame];
		textField.tag = 100;
		textField.center = blurbImage.center;
		
		
		textField.textColor = self.annotationColor;
		
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.adjustsFontSizeToFitWidth = YES;
		textField.delegate = self;
		textField.font = [UIFont systemFontOfSize:20.0f];
		textField.textAlignment = UITextAlignmentCenter;
		textField.returnKeyType = UIReturnKeyDone;
		textField.borderStyle = UITextBorderStyleNone;
		[self addSubview:textField];
		[textField becomeFirstResponder];
		[textField release];
		[blurbImage release];
	}
	return self;
}


-(AnnotationType)annotationType
{
    return eText;
}

- (void)dealloc
{
	_delegate = nil;
	[super dealloc];
}
#pragma mark -
#pragma mark UITextFieldDelegate
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) 
// or endEditing:YES called

- (void)textFieldDidEndEditing:(UITextField *)textField             
{
    [textField resignFirstResponder];
    if (![self viewWithTag:200] || ![textField.text length]) 
    {
        [self removeFromSuperview];
        self = nil;
    }
} 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    float calculatedHeight = [LAUtilities calculateHeightOfTextFromWidth:textField.text 
																		:textField.font
																		:textField.frame.size.width 
																		:UILineBreakModeWordWrap];
	

	UILabel * annotationLabel = [[UILabel alloc] 
								 initWithFrame:CGRectMake(textField.frame.origin.x,
														  textField.frame.origin.y - 20.0f,
														  textField.frame.size.width, 
														  calculatedHeight)]; 
	annotationLabel.text = textField.text;
	annotationLabel.numberOfLines = 0;
	annotationLabel.tag = 200;
	annotationLabel.textAlignment = UITextAlignmentCenter;
	annotationLabel.font = textField.font;
	annotationLabel.textColor = textField.textColor;
	annotationLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:annotationLabel];
	[annotationLabel release];
	if([textField.text length])
	{
        self.text = textField.text;
		[_delegate annotation:self didSendAnnotationText:textField.text withFont:textField.font];
	}
    [[self viewWithTag:100] setHidden:YES];
    [textField resignFirstResponder];
	return YES;
}


- (id)initWithFrame:(CGRect)inFrame withText:(NSString *)inText font:(UIFont *)inFont isReceived:(BOOL)isRec{
	if((self = [super initWithFrame:inFrame isReceived:isRec]))
	{
		UIImageView *blurbImage = [[UIImageView alloc] initWithFrame:
								   CGRectMake(0.0f, 0.0f, 193.0f, 165.0f)];
		blurbImage.image = [UIImage imageNamed:@"Green_Transparent_Blurb.png"];
		[self addSubview:blurbImage];
		
		CGRect textFrame = inFrame;
		textFrame.origin = CGPointMake(12.0f, 30.0f);
		textFrame.size = CGSizeMake(blurbImage.frame.size.width - 12.0f - 10.0f, 0.0f);
		
		float calculatedHeight = [LAUtilities calculateHeightOfTextFromWidth:inText 
																			:inFont 
																			:textFrame.size.width
																			:UILineBreakModeWordWrap];
		textFrame.size = CGSizeMake(blurbImage.frame.size.width - 12.0f - 10.0f, calculatedHeight);
		
		UILabel * annotationLabel = [[UILabel alloc] 
									 initWithFrame:textFrame]; 
		annotationLabel.text = inText;
        self.text = inText;
		annotationLabel.numberOfLines = 0;
		annotationLabel.tag = 200;
		annotationLabel.textAlignment = UITextAlignmentCenter;
		annotationLabel.font = inFont;
		
		annotationLabel.textColor = self.annotationColor;
		
		
		annotationLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:annotationLabel];
		[annotationLabel release];
		[blurbImage release];
		
	}
	return self;
}


#pragma mark -
#pragma mark Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
}
@end
