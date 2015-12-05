/*
 Copyright (c) 2003-2015, Sveinbjorn Thordarson <sveinbjornt@gmail.com>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.
 
 3. Neither the name of the copyright holder nor the names of its contributors may
 be used to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "Alerts.h"

@implementation Alerts

+ (void)alert:(NSString *)message subText:(NSString *)subtext style:(NSAlertStyle)style {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:subtext];
    [alert setAlertStyle:style];
    [[alert window] setPreventsApplicationTerminationWhenModal:YES];
    [alert runModal];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)alert:(NSString *)message subTextFormat:(NSString *)formatString, ...
{
    va_list args;
    va_start(args, formatString);
    NSString *formattedString = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
#if !__has_feature(objc_arc)
    [formattedString autorelease];
#endif
    [self alert:message subText:formattedString];
}

+ (void)alert:(NSString *)message subText:(NSString *)subtext {
    [self alert:message subText:subtext style:NSWarningAlertStyle];
}

+ (void)fatalAlert:(NSString *)message subText:(NSString *)subtext {
    [self alert:message subText:subtext style:NSCriticalAlertStyle];
    [[NSApplication sharedApplication] terminate:self];
}

+ (void)fatalAlert:(NSString *)message subTextFormat:(NSString *)formatString, ... {
    va_list args;
    va_start(args, formatString);
    NSString *formattedString = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
#if !__has_feature(objc_arc)
    [formattedString autorelease];
#endif
    [self fatalAlert:message subText:formattedString];
}

#pragma mark -

+ (void)sheetAlert:(NSString *)message subText:(NSString *)subtext forWindow:(NSWindow *)window {
    [self sheetAlert:message subText:subtext style:NSCriticalAlertStyle forWindow:window];
}

+ (void)sheetAlert:(NSString *)message subText:(NSString *)subtext style:(NSAlertStyle)style forWindow:(NSWindow *)window {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:subtext];
    [alert setAlertStyle:style];
    [alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:nil];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

#pragma mark -

+ (BOOL)proceedAlert:(NSString *)message subText:(NSString *)subtext withAction:(NSString *)action {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:action];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:message];
    [alert setInformativeText:subtext];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    BOOL ret = ([alert runModal] == NSAlertFirstButtonReturn);
#if !__has_feature(objc_arc)
    [alert release];
#endif
    return ret;
}

@end
