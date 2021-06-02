#include "NPColor.h"
#include <RemoteLog.h>

//static int notifCenterChanged;
//static BOOL enabled;
static UIImage *SPColorArtworkImage;
static UIColor *averageArtworkColor;
static UIColor *invertColor;

UIColor* getAverageColor(UIImage *image) {
    
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [image drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                     green:data[1] / 255.0f
                                      blue:data[0] / 255.0f
                                     alpha:1];
    UIGraphicsEndImageContext();
    return color;
}

UIColor* getInvertColor(UIColor *color) {
    CGFloat alpha;

    CGFloat red, green, blue;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [UIColor colorWithRed:1.0 - red green:1.0 - green blue:1.0 - blue alpha:alpha];
    }

    CGFloat hue, saturation, brightness;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:1.0 - hue saturation:1.0 - saturation brightness:1.0 - brightness alpha:alpha];
    }

    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:1.0 - white alpha:alpha];
    }

    return nil;
}

CGFloat lightness(UIColor *color) {
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    CGFloat lightness = (2 - saturation) * brightness / 2;

    return lightness;
}


%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
	%orig;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
			SPColorArtworkImage = [UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)];
			averageArtworkColor = getAverageColor(SPColorArtworkImage);
			if(lightness(averageArtworkColor) >= .7) {
				averageArtworkColor = [UIColor grayColor];
			}
			invertColor = getInvertColor(averageArtworkColor);
		}
	});
}

%end

%hook MRUArtworkView

-(void)setIconImage:(UIImage *)arg1 {
	UIImage *temp = [[UIImage alloc] init];
	%orig(temp);
}

%end


%hook MRUNowPlayingViewController

-(void)viewWillAppear:(BOOL)arg1 {
	//BOOL tempOrig = %orig;
	//if(tempOrig) {
		%orig(arg1);
		[self NPColorize];
	//}
	//return tempOrig;
}

%new
-(void)NPColorize {
	if(self.layout !=0 && self.layout == 4) {
		if([self.viewIfLoaded.superview.superview.superview.superview isKindOfClass:%c(PLPlatterView)]) {
			//SPColorArtworkImage = ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.artworkView.artworkImage;

			/*if([((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.titleMarqueeView.contentView.layer isKindOfClass:%c(CAReplicatorLayer)]) {
				((CAReplicatorLayer *) ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.titleMarqueeView.contentView.layer).instanceColor = [invertColor CGColor];
				((CAReplicatorLayer *) ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.subtitleMarqueeView.contentView.layer).instanceColor = [invertColor CGColor];
			}*/

			//((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.routeLabel.textColor = invertColor;

			((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.artworkView.iconShadowView.hidden = YES;

			//CAReplicatorLayer *tempLayer = [[CAReplicatorLayer alloc] initWithLayer:((MRUNowPlayingView *) self.viewIfLoaded).controlsView.volumeControlsView.slider.subviews[0].layer.sublayers[0]];
			//tempLayer.instanceColor = [invertColor CGColor];
			//[((MRUNowPlayingView *) self.viewIfLoaded).controlsView.volumeControlsView.slider.subviews[0].layer insertSublayer:tempLayer atIndex:0];

			//((MRUNowPlayingView *) self.viewIfLoaded).controlsView.volumeControlsView.slider.subviews[1].

			//((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.routingButton.packageView
			
			
			CGRect replacementFrame = self.viewIfLoaded.superview.superview.superview.superview.subviews[0].frame;

			CAShapeLayer *replacementLayer = [[CAShapeLayer alloc] init];

			replacementLayer.frame = replacementFrame;
			replacementLayer.cornerRadius = 13;
			replacementLayer.masksToBounds = true;
			replacementLayer.backgroundColor = [averageArtworkColor CGColor];

			UIView *replacementView = [[UIView alloc] initWithFrame:replacementFrame];

			[replacementView.layer insertSublayer:replacementLayer atIndex:0];
			[[(CSNotificationAdjunctListViewController *)self.parentViewController.parentViewController.parentViewController stackView].arrangedSubviews[0].subviews[0] setBackgroundView:replacementView];

		}

	}
}

/*-(void)viewWillAppear:(BOOL)arg1 {
	[self NPColorize];
	%orig(arg1);
}*/

//%new
//-(void)NPColorUpdate {
	//NSArray *tempArray = [self.adjunctListViewController stackView].arrangedSubviews;
	//if(tempArray != nil && [tempArray count] != 0) {
		/*
		if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0] isKindOfClass:%c(CSAdjunctItemView)]) {
			if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0] isKindOfClass:%c(PLPlatterView)]) {
				if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1] isKindOfClass:%c(PLPlatterCustomContentView)]) {
					if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0] isKindOfClass:%c(CSMediaControlsView)]) {
						if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0] isKindOfClass:%c(UIView)]) {
							if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0] isKindOfClass:%c(MRUNowPlayingView)]) {
								artworkImage = [[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0] artworkImage];
							}
						}
					}
				}
			}
			*/
		//}

/*	if(self.layout !=0 && self.layout == 4) {
		if([self.viewIfLoaded.superview.superview.superview.superview isKindOfClass:%c(PLPlatterView)]) {
			RLog(@"ArtworkImage");
			SPColorArtworkImage = ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.artworkView.artworkImage;

			averageArtworkColor = getAverageColor(SPColorArtworkImage);

			CGRect replacementFrame = self.viewIfLoaded.superview.superview.superview.superview.subviews[0].frame;

			CAShapeLayer *replacementLayer = [[CAShapeLayer alloc] init];

			replacementLayer.frame = replacementFrame;
			replacementLayer.cornerRadius = 13;
			replacementLayer.masksToBounds = true;
			replacementLayer.backgroundColor = [averageArtworkColor CGColor];

			UIView *replacementView = [[UIView alloc] initWithFrame:replacementFrame];

			[replacementView.layer insertSublayer:replacementLayer atIndex:0];
			[[(CSNotificationAdjunctListViewController *)self.parentViewController.parentViewController.parentViewController stackView].arrangedSubviews[0].subviews[0] setBackgroundView:replacementView];
		}

	}

}*/

/*-(void)viewWillAppear:(BOOL)arg1 {
	MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue());
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NPColorUpdate) name:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	return %orig(arg1);
}*/

%end


/*%hook CSNotificationAdjunctListViewController

-(void)viewWillAppear:(BOOL)arg1 {
	NSArray *tempArray = [self stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {
		if([[[self stackView].arrangedSubviews objectAtIndex:0] isKindOfClass:%c(CSAdjunctItemView)]) {
			if([[[self stackView].arrangedSubviews objectAtIndex:0].subviews[0] isKindOfClass:%c(PLPlatterView)]) {
				if([[[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1] isKindOfClass:%c(PLPlatterCustomContentView)]) {
					if([[[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0] isKindOfClass:%c(CSMediaControlsView)]) {
						if([[[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0] isKindOfClass:%c(UIView)]) {
							if([[[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0] isKindOfClass:%c(MRUNowPlayingView)]) {
								//averageArtworkColor = getAverageColor(SPColorArtworkImage);
								//invertColor = getInvertColor(averageArtworkColor);
								RLog(@"TEXT");
								((MRUNowPlayingView *) [[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.titleLabel.textColor = invertColor;
								((MRUNowPlayingView *) [[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.subtitleLabel.textColor = invertColor;
								((MRUNowPlayingView *) [[self stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.routeLabel.titleLabel.textColor = invertColor;
							}
						}
					}
				}
			}
		}
	}
	%orig(arg1);
}

%end*/

//%hook CSCombinedListViewController

/*-(void)viewDidAppear:(BOOL)arg1 {
	%orig(arg1);
	NSArray *tempArray = [self.adjunctListViewController stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {
		if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0] isKindOfClass:%c(CSAdjunctItemView)]) {
			if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0] isKindOfClass:%c(PLPlatterView)]) {
				if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1] isKindOfClass:%c(PLPlatterCustomContentView)]) {
					if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0] isKindOfClass:%c(CSMediaControlsView)]) {
						if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0] isKindOfClass:%c(UIView)]) {
							if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0] isKindOfClass:%c(MRUNowPlayingView)]) {
								averageArtworkColor = getAverageColor(SPColorArtworkImage);
								invertColor = getInvertColor(averageArtworkColor);
								RLog(@"TEXT");
								((MRUNowPlayingView *) [[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.titleLabel.textColor = invertColor;
								((MRUNowPlayingView *) [[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.subtitleLabel.textColor = invertColor;
								((MRUNowPlayingView *) [[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.labelView.routeLabel.titleLabel.textColor = invertColor;
							}
						}
					}
				}
			}
		}
	}
}*/

/*-(void)viewWillAppear:(BOOL)arg1 {
	//BOOL tempOrig = %orig;
	if([self.adjunctListViewController.childViewControllers count] != 0) {
		if([self.adjunctListViewController.childViewControllers[0].childViewControllers count] != 0) {
			[self.adjunctListViewController.childViewControllers[0].childViewControllers[0].childViewControllers[0] NPColorUpdate];
		}
	}
	NSArray *tempArray = [self.adjunctListViewController stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {
		if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0] isKindOfClass:%c(CSAdjunctItemView)]) {
			if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0] isKindOfClass:%c(PLPlatterView)]) {
				if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1] isKindOfClass:%c(PLPlatterCustomContentView)]) {
					if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0] isKindOfClass:%c(CSMediaControlsView)]) {
						if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0] isKindOfClass:%c(UIView)]) {
							if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0] isKindOfClass:%c(MRUNowPlayingView)]) {
								((MRUNowPlayingView *) [[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0]).controlsView.headerView.artworkView.iconView.hidden = YES;
							}
						}
					}
				}
			}
		}
	}
	//return tempOrig;
	return %orig(arg1);
}*/

//%end