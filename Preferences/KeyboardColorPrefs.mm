#import "KeyboardColorPrefs.h"
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation KeyboardColorPrefs

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)resetDefaults {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    [defaults setObject:@(YES) forKey:@"enabled"];
    [defaults setObject:@(0.9) forKey:@"red"];
    [defaults setObject:@(0.9) forKey:@"green"];
    [defaults setObject:@(0.9) forKey:@"blue"];
    [defaults setObject:@(0.3) forKey:@"alpha"];
    [defaults synchronize];

    // Notify tweak for live refresh
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                         CFSTR("com.yourcompany.keyboardcolor/ReloadPrefs"),
                                         NULL, NULL, true);

    [self reloadSpecifiers];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已重置"
                                                                   message:@"键盘颜色已恢复默认"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.title = @"键盘颜色";
    
    // 设置导航栏样式
    if (@available(iOS 13.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 刷新设置项
    [self reloadSpecifiers];
}

@end
