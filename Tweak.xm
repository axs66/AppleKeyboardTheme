#import <UIKit/UIKit.h>
#import <objc/runtime.h>

%hook UIInputWindowController

- (void)viewDidLoad {
    %orig;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    UIColor *keyboardColor = [UIColor colorWithRed:[[defaults objectForKey:@"red"] floatValue]
                                           green:[[defaults objectForKey:@"green"] floatValue]
                                            blue:[[defaults objectForKey:@"blue"] floatValue]
                                           alpha:[[defaults objectForKey:@"alpha"] floatValue]];
    
    if (!keyboardColor) {
        keyboardColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    
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
        }
    }
}

%end
