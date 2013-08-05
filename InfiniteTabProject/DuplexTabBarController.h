//
//  ViewController.h
//  Created by http://github.com/iosdeveloper
//

#import <UIKit/UIKit.h>
#import "InfiniTabBar.h"
#import "KOTabs.h"

/**
 A tab delegate with bottom tab and top tab
 */
@protocol DuplexTabbarDelegate <NSObject>

//number of bottom tab
- (NSInteger)bottomTabCount;

//get the indexed bottomtab
-(InfiniTabBar*)bottomTab;

//switch to indexed bottom tab
- (void)switchToTabBarForBottomTab:(NSNumber*)index;


/*topbar related to bottom tab*/

//number of top tab
- (NSInteger)topTabCount:(NSInteger)bottomTabIndex;

//get the topttab for indexed bottomtab
-(KOTabs*)topTab:(NSInteger)bottomTabIndex;

//switch to indexed top tab
- (void)switchToTabBarForTopTab:(NSNumber*)index;
@end


@interface DuplexTabBarController : UIViewController <InfiniTabBarDelegate,KOTabsDelegate>

@property (nonatomic, retain) id<DuplexTabbarDelegate> delegate;
@property (nonatomic, retain) InfiniTabBar *bottomTabBar;
@property (nonatomic, retain) KOTabs *topTabs;
@end