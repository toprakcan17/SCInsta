#import "../../Utils.h"

static BOOL SCIBypassApproveFollowRequestConfirm = NO;
static BOOL SCIBypassIgnoreFollowRequestConfirm = NO;

%hook IGPendingRequestView
- (void)_onApproveButtonTapped {
    if (SCIBypassApproveFollowRequestConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_request_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow request triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassApproveFollowRequestConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(_onApproveButtonTapped));
            SCIBypassApproveFollowRequestConfirm = NO;
        }];
        return;
    }

    %orig;
}
- (void)_onIgnoreButtonTapped {
    if (SCIBypassIgnoreFollowRequestConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_request_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow request triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassIgnoreFollowRequestConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(_onIgnoreButtonTapped));
            SCIBypassIgnoreFollowRequestConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
