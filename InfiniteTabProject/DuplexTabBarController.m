//
//  ViewController.m
//  Created by http://github.com/iosdeveloper
//

#import "DuplexTabBarController.h"
#import "KOTabs.h"
#import "KOTabView.h"
#import "RMSelectorObj.h"


@interface DuplexTabBarController()
{
    NSMutableDictionary* topbarSelectors;
    NSMutableDictionary* bottombarSelectors;
}

@end


@implementation DuplexTabBarController

@synthesize bottomTabBar;
@synthesize topTabs;
@synthesize delegate;


#pragma mark viewcontroller lifecycle

- (void)dealloc {
	[bottomTabBar release];
	[topTabs release];
    [topbarSelectors release];
    [bottombarSelectors release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO::bottombar Selectors
    if(delegate)
    {
        for (NSInteger i = 0; i < [delegate bottomTabCount]; ++i)
        {
            [self registerBottombarSelector:i withSelector:@selector(switchToTabBarForBottomTab:) withObject:delegate];
        }
        
        
        //add bottomtab
        self.bottomTabBar = [delegate bottomTab];
        
        if(self.bottomTabBar)
        {
            [self.view addSubview:self.bottomTabBar];
        }
        
        [self updateTopBar:0];
        
        [delegate switchToTabBarForBottomTab:0];
    }
}
-(void)updateTopBar:(NSInteger)bottomIndex
{
    for (NSInteger i = 0; i < [delegate topTabCount:bottomIndex]; ++i) {
        [self registerTopbarSelector:i withSelector:@selector(switchToTabBarForTopTab:) withObject:delegate];
    }
    
    //add toptab
    if (self.topTabs) {
        [self.topTabs removeFromSuperview];
    }
    self.topTabs = [delegate topTab:bottomIndex];
    if (self.topTabs) {
        [self.view addSubview:self.topTabs];
    }
}
#pragma mark InfiniTabBarDelegate
- (void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag {
    if(tabBar.tag==tag)
    {
        return;
    }
    NSLog(@"switch bottom from item:%d to item:%d",tabBar.tag,tag);
    
    //update topbar with this bottom bar
    [self updateTopBar:tag];
    
    RMSelectorObj* tmp = [self getBottombarSelector:tag];
    if(tmp)
    {
        [tmp.obj performSelectorOnMainThread:tmp.selector withObject:[NSNumber numberWithInt:tag] waitUntilDone:YES];
    }
}
- (void)infiniTabBar:(InfiniTabBar *)tabBar willSelectItemWithTag:(int)tag
{
//    [self infiniTabBar:tabBar didScrollToTabBarWithTag:tag];
}
- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag {
    [self infiniTabBar:tabBar didScrollToTabBarWithTag:tag];
}

#pragma mark - KOTabbedViewDelegate
- (void)tabs:(KOTabs *)tabs willSwitchItem:(NSInteger)index
{
    if(self.topTabs.activeBarIndex==index)
    {
        return;
    }
    NSLog(@"switch topbar from item:%d to item:%d",self.topTabs.activeBarIndex,index);
    
    RMSelectorObj* tmp = [self getTopbarSelector:index];
    if(tmp)
    {
        [tmp.obj performSelectorOnMainThread:tmp.selector withObject:[NSNumber numberWithInt:index] waitUntilDone:YES];
    }
}
- (void)tabs:(KOTabs *)tabs didSwitchItem:(NSInteger)index
{
}

- (void)tabs:(KOTabs *)tabs didCloseItem:(NSInteger)item
{
	
}

#pragma mark util methods
-(RMSelectorObj*)getBottombarSelector:(NSInteger)tag
{
    return [bottombarSelectors objectForKey:[NSString stringWithFormat:@"%d",tag]];
}

-(RMSelectorObj*)getTopbarSelector:(NSInteger)tag
{
    return [topbarSelectors objectForKey:[NSString stringWithFormat:@"%d",tag]];
}

-(void)registerBottombarSelector:(NSInteger)tag withSelector:(SEL)selector  withObject:(id)object
{
    if (!bottombarSelectors) {
        bottombarSelectors = [[NSMutableDictionary alloc]init];
    }
    RMSelectorObj* tmp = [[[RMSelectorObj alloc]init]autorelease];
    tmp.obj = object;
    tmp.selector = selector;
    [bottombarSelectors setValue:tmp forKey:[NSString stringWithFormat:@"%d",tag]];
}

-(void)registerTopbarSelector:(NSInteger)index withSelector:(SEL)selector withObject:(id)object
{
    if (!topbarSelectors) {
        topbarSelectors = [[NSMutableDictionary alloc]init];
    }
    RMSelectorObj* tmp = [[[RMSelectorObj alloc]init]autorelease];
    tmp.obj = object;
    tmp.selector = selector;
    [topbarSelectors setValue:tmp forKey:[NSString stringWithFormat:@"%d",index]];
}
@end