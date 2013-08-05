//
//  MakeupDuplexTabBarController.m
//  InfiniteTabProject
//
//  Created by Ramonqlee on 8/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "MakeToastController.h"
#import "SQLiteManager.h"
#import "RMArticlesView.h"
#import "RMArticle.h"

#define kMakeToastDBName @"data.sql"

@interface MakeToastController()

@property(nonatomic,retain)RMArticlesView* articleController;
@end

@implementation MakeToastController
- (void)viewDidLoad {
    super.delegate = self;
    [super viewDidLoad];
}

#pragma mark DuplexTabbarDelegate
//number of bottom tab
- (NSInteger)bottomTabCount
{
    return 2;
}

//get the indexed bottomtab
-(InfiniTabBar*)bottomTab
{
    // Items
	UITabBarItem *favorites = [[[UITabBarItem alloc] initWithTitle:@"祝酒词" image:[UIImage imageNamed:@"maketoast.png"] tag:0]autorelease];
    UITabBarItem *qiushi = [[[UITabBarItem alloc] initWithTitle:@"糗事" image:[UIImage imageNamed:@"maketoast.png"] tag:0]autorelease];
	UITabBarItem *topRated = [[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"maketoast.png"] tag:0]autorelease];
	UITabBarItem *featured = [[[UITabBarItem alloc] initWithTitle:@"推荐" image:[UIImage imageNamed:@"maketoast.png"] tag:0]autorelease];
	UITabBarItem *setting = [[[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"maketoast.png"] tag:0]autorelease];
    
	// Tab bar
	InfiniTabBar* bottomTabBar = [[[InfiniTabBar alloc] initWithItems:[NSArray arrayWithObjects:favorites,
                                                                       qiushi,
                                                                       topRated,
                                                                       featured,
                                                                       setting,
                                                                       nil]]autorelease];
    
	
	// Don't show scroll indicator
	bottomTabBar.showsHorizontalScrollIndicator = YES;
	bottomTabBar.infiniTabBarDelegate = self;
	bottomTabBar.bounces = YES;
    [bottomTabBar selectItemWithTag:0];
	
    return bottomTabBar;
    
}

//switch to indexed bottom tab
- (void)switchToTabBarForBottomTab:(NSNumber*)index
{
    NSLog(@"switchToTabBarForBottomTab to index:%d",[index intValue]);
    [self switchTopTabForBottomBar:[NSNumber numberWithInt:0] forBottombar:index.intValue];
}

-(void)switchTopTabForBottomBar:(NSNumber *)index forBottombar:(NSInteger)bottomIndex
{
    CGRect rc = self.view.frame;
    rc.size.height = kDeviceHeight - kTabHeight - kTopTabHeight;
    rc.origin.y = kTopTabHeight;
    
    if(self.articleController)
    {
        [self.articleController removeFromSuperview];
    }
    else
    {
        self.articleController = [[RMArticlesView alloc]initWithFrame:rc];
    }
    
    
    KOTabView* tabView = [[self.topTabs tabViews]objectAtIndex:index.intValue];

    NSArray* data = [self getSqlData:kMakeToastDBName withKeyWord:tabView.name];
    [self.articleController setData:data];
    self.articleController.delegate = self;
    
    [self.view addSubview:self.articleController];
}

//number of top tab
- (NSInteger)topTabCount:(NSInteger)bottomTabIndex
{
    return 6;
}

//get the indexed topttab
-(KOTabs*)topTab:(NSInteger)bottomTabIndex
{
    KOTabView *tabView1 = [[KOTabView alloc] initWithFrame:self.view.frame];
	[tabView1 setBackgroundColor:[UIColor purpleColor]];
	[tabView1 setIndex:0];
    [tabView1 setClosable:NO];
	[tabView1 setName:@"祝酒词"];
	
	KOTabView *tabView2 = [[KOTabView alloc] initWithFrame:self.view.bounds];
	[tabView2 setBackgroundColor:[UIColor greenColor]];
	[tabView2 setIndex:1];
    [tabView2 setClosable:NO];
	[tabView2 setName:@"敬酒词"];
	
	KOTabView *tabView3 = [[KOTabView alloc] initWithFrame:self.view.bounds];
	[tabView3 setBackgroundColor:[UIColor redColor]];
	[tabView3 setIndex:2];
    [tabView3 setClosable:NO];
	[tabView3 setName:@"拒酒词"];
    
    KOTabView *tabView4 = [[KOTabView alloc] initWithFrame:self.view.bounds];
	[tabView4 setBackgroundColor:[UIColor yellowColor]];
	[tabView4 setIndex:3];
    [tabView4 setClosable:NO];
	[tabView4 setName:@"劝酒词"];
    
    KOTabView *tabView5 = [[KOTabView alloc] initWithFrame:self.view.bounds];
	[tabView5 setBackgroundColor:[UIColor blueColor]];
	[tabView5 setIndex:4];
    [tabView5 setClosable:NO];
	[tabView5 setName:@"提酒词"];
    
    KOTabView *tabView6 = [[KOTabView alloc] initWithFrame:self.view.bounds];
	[tabView6 setBackgroundColor:[UIColor blueColor]];
	[tabView6 setIndex:5];
    [tabView6 setClosable:NO];
	[tabView6 setName:@"挡酒词"];
	
	NSMutableArray *tabViews = [NSMutableArray arrayWithObjects:tabView1, tabView2, tabView3, tabView4,tabView5,tabView6,nil];
	
    CGRect rc = self.view.bounds;
    rc.size.height -= kTabHeight;
	KOTabs *tabs = [[[KOTabs alloc] initWithFrame:rc]autorelease];
	[tabs setDelegate:(id<KOTabsDelegate>)self];
	
	[tabs setTabViews:tabViews];
	[tabs setActiveBarIndex:0];
	[tabs setActiveViewIndex:0];
	
    return tabs;
}

//switch to indexed top tab
- (void)switchToTabBarForTopTab:(NSNumber*)index
{
    NSLog(@"switchToTabBarForTopTab to index %d",[index intValue]);
    
    [self switchTopTabForBottomBar:index forBottombar:self.bottomTabBar.currentTabBarTag];
    //	textView.text = dump;
    //	[webView loadHTMLString:dump baseURL:nil];
    
}

#pragma mark util methods
-(NSArray*)getSqlData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:dbName]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM Content where Title LIKE '%%%@%%'",keywords];
    
    NSLog(@"query:%@",query);
    
    NSArray* rows=[dbManager getRowsForQuery:query];
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary* row in rows) {
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [row objectForKey:@"Title"];
        article.content = [row objectForKey:@"Content"];
        article.summary = [row objectForKey:@"Summary"];
        
        [data addObject:article];
    }
    return data;
}
@end
