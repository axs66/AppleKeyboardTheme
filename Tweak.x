%hook UIKeyboardLayoutStar

- (void)setBackgroundImage:(UIImage *)image {
    UIImage *customImage = [UIImage imageNamed:@"Background.png"];
    %orig(customImage);
}

%end
