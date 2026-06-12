#import <UIKit/UIKit.h>

static inline BOOL isIpad(void) {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

#pragma mark - 修复缩放叠加（核心）

%hook UIView

- (void)setTransform:(CGAffineTransform)transform {
    if (isIpad()) {
        // 防止重复缩放
        if (transform.a < 0.7 && transform.a > 0.1) {
            transform = CGAffineTransformMakeScale(transform.a, transform.a);
        }
    }
    %orig(transform);
}

%end

#pragma mark - 强制恢复右侧按钮大小

%hook UIView

- (void)layoutSubviews {
    %orig;

    if (!isIpad()) return;

    for (UIView *sub in self.subviews) {
        // 识别右侧按钮区域
        if (sub.bounds.size.width < 120 && sub.bounds.size.height > 200) {

            if (sub.transform.a < 0.7) {
                sub.transform = CGAffineTransformIdentity;
            }
        }
    }
}

%end

#pragma mark - 干掉 iPad 系统菜单（让原插件生效）

%hook UIView

- (void)didMoveToWindow {
    %orig;

    if (!isIpad()) return;

    NSString *cls = NSStringFromClass([self class]);

    if ([cls containsString:@"ContextMenu"] ||
        [cls containsString:@"UIContextMenu"] ||
        [cls containsString:@"Menu"]) {

        self.hidden = YES;
        self.alpha = 0.0;
    }
}

%end
