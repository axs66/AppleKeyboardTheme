#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIInputWindowController : NSObject
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (id)valueForKey:(NSString *)key;
@end

// Category declaration to satisfy compiler for private selectors
@interface UIInputWindowController (KeyboardColorTweak)
- (void)applyKeyboardColor;
- (void)setBackgroundColor:(UIColor *)color forView:(UIView *)view;
@end

%hook UIInputWindowController

- (void)viewDidLoad {
    %orig;
    [self applyKeyboardColor];
}

%new
- (void)applyKeyboardColor {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    
    // 获取颜色值，如果没有设置则使用默认值
    float red = [[defaults objectForKey:@"red"] floatValue] ?: 0.9;
    float green = [[defaults objectForKey:@"green"] floatValue] ?: 0.9;
    float blue = [[defaults objectForKey:@"blue"] floatValue] ?: 0.9;
    float alpha = [[defaults objectForKey:@"alpha"] floatValue] ?: 1.0;
    
    UIColor *keyboardColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    // 安全访问 view（KVC 包裹 try/catch），并检查类型
    UIView *controllerView = nil;
    @try {
        id v = [self valueForKey:@"view"];
        if ([v isKindOfClass:[UIView class]]) {
            controllerView = (UIView *)v;
        }
    } @catch (NSException *exception) {
        NSLog(@"KeyboardColorTweak: view KVC failed: %@", exception);
        return;
    }
    if (controllerView == nil) {
        return;
    }
    
    // 修改键盘背景颜色
    for (UIView *subview in controllerView.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
            subview.backgroundColor = keyboardColor;
            
            // 递归设置子视图背景色
            [self kct_applyBackgroundColor:keyboardColor toView:subview];
        }
    }
}

%new
- (void)kct_applyBackgroundColor:(UIColor *)color toView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIKBKeyView")] || 
            [subview isKindOfClass:NSClassFromString(@"UIKBKeyplaneView")]) {
            subview.backgroundColor = color;
        }
        [self kct_applyBackgroundColor:color toView:subview];
    }
}

%end
