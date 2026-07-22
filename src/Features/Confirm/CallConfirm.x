#import "../../Utils.h"

static BOOL SCIBypassAudioCallConfirm = NO;
static BOOL SCIBypassVideoCallConfirm = NO;

%hook IGDirectThreadCallButtonsCoordinator
// Voice Call
- (void)_didTapAudioButton:(id)arg1 {
    if (SCIBypassAudioCallConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Call confirm triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassAudioCallConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(_didTapAudioButton:), arg1);
            SCIBypassAudioCallConfirm = NO;
        }];
        return;
    }

    %orig;
}

// Video Call
- (void)_didTapVideoButton:(id)arg1 {
    if (SCIBypassVideoCallConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Call confirm triggered");
        
        [SCIUtils showConfirmation:^{
            SCIBypassVideoCallConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(_didTapVideoButton:), arg1);
            SCIBypassVideoCallConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
