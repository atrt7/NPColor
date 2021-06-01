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


%group Colorize

%hook MRUNowPlayingViewController

+(void)init {
	MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue());
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NPColorUpdate) name:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	%orig;
}

%new
-(void)NPColorUpdate {
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

	RLog(@"ArtworkImage");
	SPColorArtworkImage = ((MRUNowPlayingView *) self.viewIfLoaded).controlsView.headerView.artworkView.artworkImage;
}

%end

%hook CSCombinedListViewController

-(void)_updateListViewContentInset {
	//BOOL tempOrig = %orig;
	[self NPColorUpdate];
	NSArray *tempArray = [self.adjunctListViewController stackView].arrangedSubviews;
	if(tempArray != nil && [tempArray count] != 0) {
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
			RLog(@"Changed Color");
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

		}

	//return tempOrig;
	%orig;
}

%end
%end

%ctor {
	//NotifCenterChanged = NO;
	if (![NSProcessInfo processInfo]) return;
    NSString* processName = [NSProcessInfo processInfo].processName;
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString* executablePath = args[0];
        if (executablePath) {
            NSString* processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;
    %init(Colorize);
}