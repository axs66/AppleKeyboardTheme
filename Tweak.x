#import <UIKit/UIKit.h>
// 从私有框架导入头文件（需确保Theos已配置私有框架路径）
#import <UIKit/UIKeyboardLayoutStar.h> 
#import <UIKit/UIKeyboardImpl.h>


%hook UIKeyboardLayoutStar

- (void)didMoveToWindow {
    %orig;
    
    // 安全类型检查
    if (![self respondsToSelector:@selector(setBackgroundImage:)]) {
        return;
    }
    
    NSString *imagePath = @"/var/jb/Library/Keyboard/Themes/CustomBackground.theme/Background.png";
    UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
    
    if (customImage) {
        [self setBackgroundImage:customImage]; 
    }
}

%end
