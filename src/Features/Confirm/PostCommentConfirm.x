#import "../../Utils.h"

static BOOL SCIBypassPostCommentConfirm = NO;

%hook IGCommentComposer.IGCommentComposerController
- (void)onSendButtonTap {
    if (SCIBypassPostCommentConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"post_comment_confirm"]) {
        NSLog(@"[SCInsta] Confirm post comment triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassPostCommentConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(onSendButtonTap));
            SCIBypassPostCommentConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
