#import <UIKit/UIKit.h>
#import <TextInput/TextInput.h> // 替代TextInputUI导入

%hook UIInputWindowController

- (void)viewDidLoad {
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
    
    // 修改键盘背景颜色
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
            subview.backgroundColor = keyboardColor;
        }
    }
}

%end

%ctor {
    NSLog(@"KeyboardColorTweak loaded");
}
