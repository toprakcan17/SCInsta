#import "../../Utils.h"
#import "../../InstagramHeaders.h"

static BOOL SCIBypassFollowConfirm = NO;

// Follow button on profile page
%hook IGFollowController
- (void)_didPressFollowButton {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    // Get user follow status (check if already following user)
    NSInteger UserFollowStatus = self.user.followStatus;

    // Only show confirm dialog if user is not following
    if (UserFollowStatus == 2) {
        if ([SCIUtils getBoolPref:@"follow_confirm"]) {
            NSLog(@"[SCInsta] Confirm follow triggered");

            [SCIUtils showConfirmation:^{
                SCIBypassFollowConfirm = YES;
                ((void (*)(id, SEL))objc_msgSend)(self, @selector(_didPressFollowButton));
                SCIBypassFollowConfirm = NO;
            }];
            return;
        }
    }

    %orig;
}
%end

// Follow button on discover people page
%hook IGDiscoverPeopleButtonGroupView
- (void)_onFollowButtonTapped:(id)arg1 {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(_onFollowButtonTapped:), arg1);
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
- (void)_onFollowingButtonTapped:(id)arg1 {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(_onFollowingButtonTapped:), arg1);
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

// Suggested for you (home feed & profile) follow button
%hook IGHScrollAYMFCell
- (void)_didTapAYMFActionButton {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(_didTapAYMFActionButton));
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
%hook IGHScrollAYMFActionButton
- (void)_didTapTextActionButton {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(_didTapTextActionButton));
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

// Follow button on reels
%hook IGUnifiedVideoFollowButton
- (void)_hackilyHandleOurOwnButtonTaps:(id)arg1 event:(id)arg2 {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL, id, id))objc_msgSend)(self, @selector(_hackilyHandleOurOwnButtonTaps:event:), arg1, arg2);
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

// Follow text on profile (when collapsed into top bar) 
%hook IGProfileViewController
- (void)navigationItemsControllerDidTapHeaderFollowButton:(id)arg1 {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL, id))objc_msgSend)(self, @selector(navigationItemsControllerDidTapHeaderFollowButton:), arg1);
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

// Follow button on suggested friends (in story section)
%hook IGStorySectionController
- (void)followButtonTapped:(id)arg1 cell:(id)arg2 {
    if (SCIBypassFollowConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"follow_confirm"]) {
        NSLog(@"[SCInsta] Confirm follow triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassFollowConfirm = YES;
            ((void (*)(id, SEL, id, id))objc_msgSend)(self, @selector(followButtonTapped:cell:), arg1, arg2);
            SCIBypassFollowConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

// Follow all button in group chats (3+ members) people view
static void (*orig_listSectionController)(id, SEL, id, id);

static void hooked_listSectionController(id self, SEL _cmd, id arg1, id arg2) {
    if ([SCIUtils getBoolPref:@"follow_confirm"]) {

        [SCIUtils showConfirmation:^{
            orig_listSectionController(self, _cmd, arg1, arg2);
        }];

        return;
    }

    orig_listSectionController(self, _cmd, arg1, arg2);
}

%ctor {
    Class cls = objc_getClass("IGDirectDetailMembersKit.IGDirectThreadDetailsMembersListViewController");
    if (!cls) return;

    MSHookMessageEx(
        cls,
        @selector(listSectionController:didTapHeaderButtonWithViewModel:),
        (IMP)hooked_listSectionController,
        (IMP *)&orig_listSectionController
    );
}
