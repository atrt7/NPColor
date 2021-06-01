#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <MediaRemote/MediaRemote.h>
#import <QuartzCore/CABackdropLayer.h>

@class MRUNowPlayingHeaderView, MRUNowPlayingControlsView, MRUNowPlayingView, MRUArtworkView, MRUNowPlayingView;

@protocol MTRecipeMaterialSettingsProviding
@end

@interface MTMaterialLayer : CABackdropLayer
@property (setter=_setRecipeSettings:,getter=_recipeSettings,nonatomic,retain) id<MTRecipeMaterialSettingsProviding> recipeSettings;
@end

@interface MRUArtworkView : UIView
@property (nonatomic,retain) UIImage * artworkImage;
-(UIImage *)artworkImage;
@end

@interface MRUNowPlayingHeaderView : UIControl
@property (nonatomic,readonly) MRUArtworkView * artworkView;
-(MRUArtworkView *)artworkView;
@end

@interface MRUNowPlayingControlsView : UIView
@property (assign,nonatomic) long long layout;
@property (nonatomic,readonly) MRUNowPlayingHeaderView * headerView;
@end

@interface MRUNowPlayingView : UIView
@property (nonatomic,readonly) MRUNowPlayingControlsView * controlsView;
@end

@interface MRUNowPlayingViewController : UIViewController
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
-(UIStackView *)stackView;
@end

@interface CSCombinedListViewController : UIViewController
@property (nonatomic,retain) CSNotificationAdjunctListViewController * adjunctListViewController;
@property (nonatomic,readonly) BOOL hasContent;
@property (getter=isShowingMediaControls,nonatomic,readonly) BOOL showingMediaControls;
-(BOOL)hasContent;
-(void)_updateListViewContentInset;
-(BOOL)isShowingMediaControls;
-(void)NPColorUpdate;
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
@end

@interface CSMediaControlsView : CSCoverSheetViewBase
@end