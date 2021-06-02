#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <MediaRemote/MediaRemote.h>
//#import <MediaControls/MediaControls.h>
#import <SpringBoard/SBMediaController.h>
#import <QuartzCore/CABackdropLayer.h>

@class MPVolumeSlider, MRUNowPlayingHeaderView, MRUNowPlayingControlsView, MRUNowPlayingView, MRUArtworkView, MRUNowPlayingView, MRUNowPlayingLabelView, MRUNowPlayingRoutingButton, MPButton, MPRouteLabel, MPUMarqueeView, _MPUMarqueeContentView, MPAVRoute, MTVisualStyling, MRUNowPlayingVolumeControlsView, MRUNowPlayingVolumeSlider, MRUVolumeSlider;

@interface MPAVRoute : NSObject
@end

@protocol MTRecipeMaterialSettingsProviding
@end

@interface CCUICAPackageView : UIView
@end

@interface MRUShadowView : UIView
@end

@interface MPButton : UIButton
@end

@interface MPRouteLabel : UIView
@property (nonatomic,retain) MPAVRoute * route;
@property (nonatomic,readonly) UILabel * titleLabel;
@property (nonatomic,retain) UIColor * textColor;
@property (assign,setter=_setTextColorFollowsTintColor:,nonatomic) BOOL _textColorFollowsTintColor;
-(void)_setTextColorFollowsTintColor:(BOOL)arg1;
@end

@interface MRUNowPlayingRoutingButton : MPButton
@property (nonatomic,retain) CCUICAPackageView * packageView;
@end

@interface MTMaterialLayer : CABackdropLayer
@property (setter=_setRecipeSettings:,getter=_recipeSettings,nonatomic,retain) id<MTRecipeMaterialSettingsProviding> recipeSettings;
@end

@interface MRUArtworkView : UIView
@property (nonatomic,retain) UIImage * artworkImage;
@property (nonatomic,retain) UIImageView * iconView;
@property (nonatomic,retain) MRUShadowView * iconShadowView;
-(UIImage *)artworkImage;
-(UIImage *)iconImage;
-(void)setIconImage:(UIImage *)arg1;
-(id)initWithFrame:(CGRect)arg1;
@end

@interface _MPUMarqueeContentView : UIView
+(Class)layerClass;
-(void)_intrinsicContentSizeInvalidatedForChildView:(id)arg1 ;
@end

@interface MPUMarqueeView : UIView
@property (nonatomic,readonly) UIView * contentView;
@end

@interface MPVolumeSlider : UISlider
@end

@interface MRUVolumeSlider : MPVolumeSlider
@end

@interface MRUNowPlayingVolumeSlider : MRUVolumeSlider
@end

@interface MRUNowPlayingVolumeControlsView : UIView
@property (nonatomic,readonly) MRUNowPlayingVolumeSlider * slider;
//@property (nonatomic,readonly) MRUVolumeStepperView * stepper;
@end

@interface MRUNowPlayingLabelView : UIView
@property (nonatomic,retain) UILabel * titleLabel;
@property (nonatomic,retain) UILabel * subtitleLabel;
@property (nonatomic,retain) MPRouteLabel * routeLabel;
@property (nonatomic,retain) MPUMarqueeView * subtitleMarqueeView;
@property (nonatomic,retain) MPUMarqueeView * titleMarqueeView;
@end

@interface MTVisualStyling : NSObject
@property (nonatomic,copy,readonly) UIColor * color;
@end

@interface MRUNowPlayingHeaderView : UIControl
@property (nonatomic,retain) MRUNowPlayingLabelView * labelView;
@property (nonatomic,readonly) MRUArtworkView * artworkView;
@property (nonatomic,readonly) MRUNowPlayingRoutingButton * routingButton;
-(MRUArtworkView *)artworkView;
@end

@interface MTVisualStylingProvider : NSObject
@property (getter=_styleNamesToVisualStylings,nonatomic,retain) NSMutableDictionary * styleNamesToVisualStylings;
@end

@interface MRUVisualStylingProvider : NSObject
@property (nonatomic,retain) MTVisualStylingProvider * visualStylingProvider;
@end

@interface MRUNowPlayingControlsView : UIView
@property (assign,nonatomic) long long layout;
@property (nonatomic,readonly) MRUNowPlayingHeaderView * headerView;
@property (nonatomic,retain) MRUVisualStylingProvider * stylingProvider;
@property (nonatomic,readonly) MRUNowPlayingVolumeControlsView * volumeControlsView;
@end

@interface MRUNowPlayingView : UIView
@property (nonatomic,readonly) MRUNowPlayingControlsView * controlsView;
@end

@interface MRUNowPlayingViewController : UIViewController
@property (assign,nonatomic) long long layout;
@property (nonatomic,readonly) MRUArtworkView * artworkView;
-(void)NPColorize;
-(void)viewWillAppear:(BOOL)arg1;
-(void)loadView;
-(void)viewDidLoad;
-(BOOL)isOnScreen;
@end

@interface PLPlatterView : UIView
@property (nonatomic,retain) UIView * backgroundView;
-(void)setBackgroundView:(UIView *)arg1;
@end

@interface MTMaterialView : UIView
@property (copy,readonly) NSString * description;
@property (getter=_materialLayer,nonatomic,readonly) MTMaterialLayer * materialLayer;
+(id)materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2 initialWeighting:(double)arg3 scaleAdjustment:(/*^block*/id)arg4;
@end

@interface CSAdjunctListView : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface NCNotificationListView : UIView
@end

@protocol CSAdjunctListModelDelegate <NSObject>

@required
-(void)adjunctListModel:(id)arg1 didRemoveItem:(id)arg2;
-(void)adjunctListModel:(id)arg1 didAddItem:(id)arg2;
@end

@interface CSNotificationAdjunctListViewController : UIViewController <CSAdjunctListModelDelegate>
@property (nonatomic,retain) UIStackView * stackView;
-(BOOL)isShowingMediaControls;
-(UIStackView *)stackView;
@end

@interface CSCombinedListViewController : UIViewController
@property (nonatomic,retain) CSNotificationAdjunctListViewController * adjunctListViewController;
@property (nonatomic,readonly) BOOL hasContent;
@property (getter=isShowingMediaControls,nonatomic,readonly) BOOL showingMediaControls;
-(BOOL)hasContent;
-(void)_updateListViewContentInset;
@end

@interface SBFTouchPassThroughView : UIView
-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 ;
@end

@interface CSCoverSheetViewBase : SBFTouchPassThroughView
@property (nonatomic,copy,readonly) NSArray * presentationRegions; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(NSArray *)presentationRegions;
-(id<UICoordinateSpace>)presentationCoordinateSpace;
-(BOOL)isCoverSheetView;
-(void)loadView;
@end

@interface CSMediaControlsView : CSCoverSheetViewBase
@end