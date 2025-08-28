#import <UIKit/UIKit.h>
#import <os/log.h>

%hook UIKeyboardLayoutStar

- (void)didMoveToWindow {
    %orig;
    
    @try {
        NSString *imagePath = @"/var/jb/Library/Keyboard/Themes/CustomBackground.theme/Background.png";
        UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
        
        if (customImage && [self respondsToSelector:@selector(setBackgroundImage:)]) {
            [self setBackgroundImage:customImage];
            os_log_debug(OS_LOG_DEFAULT, "[KeyboardTheme] Successfully applied background");
        }
    } @catch (NSException *e) {
        os_log_error(OS_LOG_DEFAULT, "[KeyboardTheme] Error: %@", e.reason);
    }
}

%end
