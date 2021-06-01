#include "NPColor.h"
#include <RemoteLog.h>

//static BOOL NotifCenterChanged;
//static BOOL enabled;
static UIImage *SPColorArtworkImage;
static UIColor *averageArtworkColor;

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
    CGColorRef oldCGColor = color.CGColor;
    int numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);
    
    // can not invert - the only component is the alpha
    // e.g. color == [UIColor groupTableViewBackgroundColor]
    if (numberOfComponents <= 1) {
        return [UIColor colorWithCGColor:oldCGColor];
    }
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    int i = - 1;
    while (++i < numberOfComponents - 1) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    newComponentColors[i] = oldComponentColors[i]; // alpha
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    return newColor;
}


%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
	%orig;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
			SPColorArtworkImage = [UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)];
		}
	});
}

%end

%hook MRUNowPlayingViewController

-(BOOL)isOnScreen {
	BOOL tempOrig = %orig;
	if(tempOrig) {
		[self NPColorize];
	}
	return tempOrig;
}

%new
-(void)NPColorize {
	if(self.layout !=0 && self.layout == 4) {
		if([self.viewIfLoaded.superview.superview.superview.superview isKindOfClass:%c(PLPlatterView)]) {
			//SPColorArtworkImage = ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.artworkView.artworkImage;

			RLog(@"ArtworkImage");

			averageArtworkColor = getAverageColor(SPColorArtworkImage);

			UIColor *invertColor = getInvertColor(averageArtworkColor);

			((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.titleLabel.textColor = invertColor;
			((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.labelView.subtitleLabel.textColor = invertColor;

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

-(BOOL)isShowingMediaControls {
	NSArray *tempArray = [self stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {
	}
	return %orig;
}

%end*/

//%hook CSCombinedListViewController

//-(void)viewWillAppear:(BOOL)arg1 {
	//BOOL tempOrig = %orig;
	/*if([self.adjunctListViewController.childViewControllers count] != 0) {
		if([self.adjunctListViewController.childViewControllers[0].childViewControllers count] != 0) {
			[self.adjunctListViewController.childViewControllers[0].childViewControllers[0].childViewControllers[0] NPColorUpdate];
		}
	}*/
	/*NSArray *tempArray = [self.adjunctListViewController stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {*/
		/*
		if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0] isKindOfClass:%c(CSAdjunctItemView)]) {
			if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0] isKindOfClass:%c(PLPlatterView)]) {
				if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1] isKindOfClass:%c(PLPlatterCustomContentView)]) {
					if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0] isKindOfClass:%c(CSMediaControlsView)]) {
						if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0] isKindOfClass:%c(UIView)]) {
							if([[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0] isKindOfClass:%c(MRUNowPlayingView)]) {
								SPColorArtworkImage = [[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0] artworkImage];
							}
						}
					}
				}
			}
			*/
			/*RLog(@"Changed Color");
			averageArtworkColor = getAverageColor(SPColorArtworkImage);

			CGRect replacementFrame = [[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0].subviews[0].frame;

			CAShapeLayer *replacementLayer = [[CAShapeLayer alloc] init];

			replacementLayer.frame = replacementFrame;
			replacementLayer.cornerRadius = 13;
			replacementLayer.masksToBounds = true;
			replacementLayer.backgroundColor = [averageArtworkColor CGColor];

			UIView *replacementView = [[UIView alloc] initWithFrame:replacementFrame];

			[replacementView.layer insertSublayer:replacementLayer atIndex:0];
			[[[self.adjunctListViewController stackView].arrangedSubviews objectAtIndex:0].subviews[0] setBackgroundView:replacementView];

		}*/

	//return tempOrig;
	//return %orig;
//}

//%end