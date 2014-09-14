////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "UIView+Position.h"
#import <FXBlurView/FXBlurView.h>
#import "ICLoader.h"
#import "INFRootController.h"
#import "UIFont+ApplicationFonts.h"
#import "UIColor+Hex.h"

static NSString *icProgressHudLogoImageName;

@interface ICLoader ()

@property(nonatomic, strong) FXBlurView *contentView;
@property(nonatomic, strong, readonly) UIView *backgroundTintView;
@property(nonatomic, strong, readonly) UIImageView *logoView;
@property(nonatomic, strong, readonly) UIView *centerDot;
@property(nonatomic, strong, readonly) UIView *leftDot;
@property(nonatomic, strong, readonly) UIView *rightDot;
@property(nonatomic, strong, readonly) UILabel *label;

@end

@implementation ICLoader

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (instancetype)present
{
    @synchronized (self)
    {
        INFRootController *controller = (INFRootController *) [UIApplication sharedApplication].keyWindow.rootViewController;

        dispatch_async(dispatch_get_main_queue(), ^
        {
            ICLoader *progressHUD = [[ICLoader alloc] initWithWithImageName:icProgressHudLogoImageName];
            [progressHUD.contentView setUnderlyingView:controller.view];
            [progressHUD setAlpha:0];
            [controller.view addSubview:progressHUD];
            [controller.view setUserInteractionEnabled:NO];

            [UIView transitionWithView:progressHUD duration:0.33 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^
            {
                [progressHUD setFrame:controller.view.bounds];
                [progressHUD setAlpha:1.0];
            } completion:nil];
        });

        return controller.progressHUD;
    }
}

+ (void)dismiss
{
    INFRootController *controller = (INFRootController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (ICLoader *progressHUD in [ICLoader allHUDsForView:controller.view])
        {
            [UIView transitionWithView:progressHUD duration:0.25 options:UIViewAnimationOptionTransitionFlipFromTop animations:^
            {
                [progressHUD setAlpha:0.0];
            } completion:^(BOOL finished)
            {
                [progressHUD removeFromSuperview];
                [controller.view setUserInteractionEnabled:YES];
            }];
        }
    });
}


+ (NSArray *)allHUDsForView:(UIView *)view
{
    NSMutableArray *theHUDs = [NSMutableArray array];
    for (UIView *candidate in view.subviews)
    {
        if ([candidate isKindOfClass:[self class]])
        {
            [theHUDs addObject:candidate];
        }
    }
    return [NSArray arrayWithArray:theHUDs];
}

+ (void)setImageName:(NSString *)imageName
{
    icProgressHudLogoImageName = imageName;
}

/* ====================================================================================================================================== */
#pragma mark - Initializers

- (id)initWithWithImageName:(NSString *)imageName
{
    if (imageName.length == 0)
    {
        [NSException raise:NSInvalidArgumentException
            format:@"ICLoader requires a logo image. Set with [ICLoader setImageName:anImageName]"];
    }

    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _contentView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [_contentView setBlurEnabled:YES];
        [_contentView setDynamic:YES];
        [_contentView setBlurRadius:15];
        [_contentView setTintColor:[UIColor colorWithHexRGB:0x686868]];

        [_contentView.layer setCornerRadius:45];
        [self addSubview:_contentView];

        [self initBackground:imageName];
        [self initDots];
        [self initLabel];
        [self animateToDot:_rightDot];
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"*** %@ in dealloc ***", NSStringFromClass([self class]));
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentView centerInRect:self.bounds];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)initBackground:(NSString *)logoImageName
{
    _backgroundTintView = [[UIView alloc] initWithFrame:_contentView.bounds];
    [_backgroundTintView setBackgroundColor:[UIColor colorWithHexRGB:0x000000 alpha:0.35]];
    [_contentView addSubview:_backgroundTintView];

    UIImage *image = [UIImage imageNamed:logoImageName];
    _logoView = [[UIImageView alloc] initWithImage:image];
    [_logoView setViewSize:image.size];
    [_logoView centerInRect:CGRectMake(0, 7, 90, 45)];

    [_logoView setContentMode:UIViewContentModeScaleAspectFit];
    [_contentView addSubview:_logoView];

}

- (void)initDots
{

    CGFloat dodWidth = 5;
    CGFloat centerX = (_contentView.frame.size.width - dodWidth) / 2;
    CGFloat dotY = ((_contentView.frame.size.height - dodWidth) / 2) + 9;

    _centerDot = [[UIView alloc] initWithFrame:CGRectMake(centerX, dotY, dodWidth, dodWidth)];
    [_centerDot setBackgroundColor:[UIColor whiteColor]];
    [_centerDot.layer setCornerRadius:_centerDot.width / 2];
    [_centerDot.layer setOpacity:1.0];
    [_contentView addSubview:_centerDot];

    _leftDot = [[UIView alloc] initWithFrame:CGRectMake(centerX - 11, dotY, dodWidth, dodWidth)];
    [_leftDot setBackgroundColor:[UIColor whiteColor]];
    [_leftDot.layer setCornerRadius:_leftDot.width / 2];
    [_leftDot.layer setOpacity:0.5];
    [_contentView addSubview:_leftDot];

    _rightDot = [[UIView alloc] initWithFrame:CGRectMake(centerX + 11, dotY, dodWidth, dodWidth)];
    [_rightDot setBackgroundColor:[UIColor whiteColor]];
    [_rightDot.layer setCornerRadius:_rightDot.width / 2];
    [_rightDot.layer setOpacity:0.5];
    [_contentView addSubview:_rightDot];
}

- (void)initLabel
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(2 + (_contentView.frame.size.width - 65) / 2, 60, 65, 14)];
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont applicationFontOfSize:10]];
    [_label setText:@"Loading..."];
    [_contentView addSubview:_label];
}


- (void)animateToDot:(UIView *)dot
{
    __weak ICLoader *weakSelf = self;
    __weak UIView *centerDot = _centerDot;
    __weak UIView *leftDot = _leftDot;
    __weak UIView *rightDot = _rightDot;

    [UIView transitionWithView:weakSelf duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
        [centerDot.layer setOpacity:dot == centerDot ? 1.0 : 0.5];
        [rightDot.layer setOpacity:dot == rightDot ? 1.0 : 0.5];
        [leftDot.layer setOpacity:dot == leftDot ? 1.0 : 0.5];
    } completion:^(BOOL complete)
    {
        if (dot == centerDot)
        {
            [weakSelf animateToDot:rightDot];
        }
        else if (dot == rightDot)
        {
            [weakSelf animateToDot:leftDot];
        }
        else
        {
            [weakSelf animateToDot:centerDot];
        }
    }];
}


@end
