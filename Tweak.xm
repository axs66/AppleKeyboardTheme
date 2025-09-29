#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>

@interface UIInputWindowController : NSObject
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (id)valueForKey:(NSString *)key;
@end

// Category declaration to satisfy compiler for private selectors
@interface UIInputWindowController (KeyboardColorTweak)
- (void)applyKeyboardColor;
- (void)kct_applyBackgroundColor:(UIColor *)color toView:(UIView *)view;
@end

static NSString *const kKCTDefaultsSuite = @"com.yourcompany.keyboardcolor";
static CFStringRef const kKCTDarwinNotify = CFSTR("com.yourcompany.keyboardcolor/ReloadPrefs");
static NSString *const kKCTLocalNotify = @"kct_prefs_changed";

static inline UIColor *kct_currentKeyboardColor(BOOL *outEnabled) {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kKCTDefaultsSuite];

    NSNumber *enabledNum = [defaults objectForKey:@"enabled"];
    BOOL enabled = enabledNum ? enabledNum.boolValue : YES;
    if (outEnabled) { *outEnabled = enabled; }

    NSNumber *rNum = [defaults objectForKey:@"red"];
    NSNumber *gNum = [defaults objectForKey:@"green"];
    NSNumber *bNum = [defaults objectForKey:@"blue"];
    NSNumber *aNum = [defaults objectForKey:@"alpha"];
    CGFloat red = rNum ? rNum.floatValue : 0.9f;
    CGFloat green = gNum ? gNum.floatValue : 0.9f;
    CGFloat blue = bNum ? bNum.floatValue : 0.9f;
    CGFloat alpha = aNum ? aNum.floatValue : 1.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

%hook UIInputWindowController

- (void)viewDidLoad {
    %orig;
    [self applyKeyboardColor];

    // Listen for in-process relay of Darwin prefs change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyKeyboardColor)
                                                 name:kKCTLocalNotify
                                               object:nil];
}

-(void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kKCTLocalNotify object:nil];
    } @catch (__unused NSException *ex) {}
    %orig;
}

-(void)viewDidAppear:(BOOL)animated {
    %orig;
    [self applyKeyboardColor];
}

%new
- (void)applyKeyboardColor {
    BOOL enabled = YES;
    UIColor *keyboardColor = kct_currentKeyboardColor(&enabled);
    
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
            subview.backgroundColor = enabled ? keyboardColor : nil;
            
            // 递归设置子视图背景色
            [self kct_applyBackgroundColor:(enabled ? keyboardColor : nil) toView:subview];
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

static void kct_darwin_callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    // Relay into process default center so active controllers can react
    [[NSNotificationCenter defaultCenter] postNotificationName:kKCTLocalNotify object:nil];
}

%ctor {
    // Subscribe once per process to Darwin notification
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    kct_darwin_callback,
                                    kKCTDarwinNotify,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}
