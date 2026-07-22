#import "../../InstagramHeaders.h"
#import "../../Utils.h"

static BOOL SCIBypassThemeNewPickerConfirm = NO;
static BOOL SCIBypassThemePickerConfirm = NO;
static BOOL SCIBypassThemePreviewConfirm = NO;

%hook IGDirectThreadThemePickerViewController
- (void)themeNewPickerSectionController:(id)arg1 didSelectTheme:(id)arg2 atIndex:(NSInteger)arg3 {
    if (SCIBypassThemeNewPickerConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"change_direct_theme_confirm"]) {
        NSLog(@"[SCInsta] Confirm change direct theme triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassThemeNewPickerConfirm = YES;
            ((void (*)(id, SEL, id, id, NSInteger))objc_msgSend)(self, @selector(themeNewPickerSectionController:didSelectTheme:atIndex:), arg1, arg2, arg3);
            SCIBypassThemeNewPickerConfirm = NO;
        }];
        return;
    }

    %orig;
}
- (void)themePickerSectionController:(id)arg1 didSelectThemeId:(id)arg2 {
    if (SCIBypassThemePickerConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"change_direct_theme_confirm"]) {
        NSLog(@"[SCInsta] Confirm change direct theme triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassThemePickerConfirm = YES;
            ((void (*)(id, SEL, id, id))objc_msgSend)(self, @selector(themePickerSectionController:didSelectThemeId:), arg1, arg2);
            SCIBypassThemePickerConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end

%hook IGDirectThreadThemeKitSwift.IGDirectThreadThemePreviewController
- (void)primaryButtonTapped {
    if (SCIBypassThemePreviewConfirm) {
        %orig;
        return;
    }

    if ([SCIUtils getBoolPref:@"change_direct_theme_confirm"]) {
        NSLog(@"[SCInsta] Confirm change direct theme triggered");

        [SCIUtils showConfirmation:^{
            SCIBypassThemePreviewConfirm = YES;
            ((void (*)(id, SEL))objc_msgSend)(self, @selector(primaryButtonTapped));
            SCIBypassThemePreviewConfirm = NO;
        }];
        return;
    }

    %orig;
}
%end
