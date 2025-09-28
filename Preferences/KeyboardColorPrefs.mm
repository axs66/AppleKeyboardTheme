#import "KeyboardColorPrefs.h"

@implementation KeyboardColorPrefs

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)resetDefaults {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourcompany.keyboardcolor"];
    [defaults setObject:@(0.9) forKey:@"red"];
    [defaults setObject:@(0.9) forKey:@"green"];
    [defaults setObject:@(0.9) forKey:@"blue"];
    [defaults setObject:@(1.0) forKey:@"alpha"];
    [defaults synchronize];
    
    [self reloadSpecifiers];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已重置"
                                                                   message:@"键盘颜色已恢复默认"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
