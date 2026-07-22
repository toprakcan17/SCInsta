#import "../../Utils.h"

static BOOL SCIBypassShhModeConfirm = NO;

%hook IGDirectThreadViewController
- (void)swipeableScrollManagerDidEndDraggingAboveSwipeThreshold:(id)arg1 {
    if (SCIBypassShhModeConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Confirm shh mode triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassShhModeConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(swipeableScrollManagerDidEndDraggingAboveSwipeThreshold:), arg1);
            SCIBypassShhModeConfirm = NO;
        }];
        return;
    }

    %orig;
}

- (void)shhModeTransitionButtonDidTap:(id)arg1 {
    if (SCIBypassShhModeConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Confirm shh mode triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassShhModeConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(shhModeTransitionButtonDidTap:), arg1);
            SCIBypassShhModeConfirm = NO;
        }];
        return;
    }

    %orig;
}

- (void)messageListViewControllerDidToggleShhMode:(id)arg1 {
    if (SCIBypassShhModeConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Confirm shh mode triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassShhModeConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(messageListViewControllerDidToggleShhMode:), arg1);
            SCIBypassShhModeConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
