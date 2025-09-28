#import <UIKit/UIKit.h>
#import <objc/runtime.h>

%hook UIInputWindowController

- (void)viewDidLoad {
    %orig;
    
    [self applyKeyboardColor];
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    [self applyKeyboardColor];
}

- (void)applyKeyboardColor {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    
    // 获取颜色值，如果没有设置则使用默认值
    float red = [[defaults objectForKey:@"red"] floatValue] ?: 0.9;
    float green = [[defaults objectForKey:@"green"] floatValue] ?: 0.9;
    float blue = [[defaults objectForKey:@"blue"] floatValue] ?: 0.9;
    float alpha = [[defaults objectForKey:@"alpha"] floatValue] ?: 1.0;
    
    UIColor *keyboardColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    // 安全访问view属性
    UIView *controllerView = nil;
    @try {
        controllerView = [self valueForKey:@"view"];
    } @catch (NSException *exception) {
        NSLog(@"KeyboardColorTweak: Failed to access view - %@", exception);
        return;
    }
    
    // 修改键盘背景颜色
    for (UIView *subview in controllerView.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
            subview.backgroundColor = keyboardColor;
            
            // 递归设置子视图背景色
            [self setBackgroundColor:keyboardColor forView:subview];
        }
    }
}

- (void)setBackgroundColor:(UIColor *)color forView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIKBKeyView")] || 
            [subview isKindOfClass:NSClassFromString(@"UIKBKeyplaneView")]) {
            subview.backgroundColor = color;
        }
        [self setBackgroundColor:color forView:subview];
    }
}

%end
