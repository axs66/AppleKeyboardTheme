#import <UIKit/UIKit.h>
#import <TextInputUI/TextInputUI.h>

%hook UIKBKeyplaneView

- (void)layoutSubviews {
    %orig;
    
    // 从偏好设置读取颜色
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    UIColor *keyboardColor = [UIColor colorWithRed:[[defaults objectForKey:@"red"] floatValue]
                                           green:[[defaults objectForKey:@"green"] floatValue]
                                            blue:[[defaults objectForKey:@"blue"] floatValue]
                                           alpha:[[defaults objectForKey:@"alpha"] floatValue]];
    
    if (!keyboardColor) {
        // 默认颜色（浅灰色）
        keyboardColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    
    self.backgroundColor = keyboardColor;
    
    // 修改按键颜色
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIKBKeyView")]) {
            subview.backgroundColor = keyboardColor;
        }
    }
}

%end

%ctor {
    NSLog(@"KeyboardColorTweak loaded");
}
