//
//  DViewController.m
//  DParallax
//
//  Created by Darshan on 19/06/12.
//  Copyright (c) 2012 Darshan. All rights reserved.
//

#import "DViewController.h"

#define FIRST_RATIO     0.6
#define SECOND_RATIO    0.8
#define THIRD_RATIO     1.0
#define FOURTH_RATIO    1.2

@interface DImageView : UIImageView

@property int index;

@end
@implementation DImageView

@synthesize index;

@end


@protocol DParallaxDelegate <NSObject>

-(void) didSelectBoardAtIndex:(int) index;

@end
@interface DParallaxView : UIView <UIScrollViewDelegate>
{
    UIScrollView *mMainView;
    
    UIScrollView *mFirstView;
    UIScrollView *mSecondView;
    UIScrollView *mThirdView;
    UIScrollView *mFourthView;
    
    UIImageView *mFirstImageFront;
    UIImageView *mFirstImageBack;
    int mFirstFrontIndex;
    int mFirstBackIndex;
    
    UIImageView *mSecondImageFront;
    UIImageView *mSecondImageBack;
    int mSecondFrontIndex;
    int mSecondBackIndex;
    
    UIImageView *mThirdImageFront;
    UIImageView *mThirdImageBack;
    int mThirdFrontIndex;
    int mThirdBackIndex;

    
    UIImageView *mFourthImageFront;
    UIImageView *mFourthImageBack;
    int mFourthFrontIndex;
    int mFourthBackIndex;
    
}

@property (nonatomic,strong) NSArray *boards;//has an array of dictionaries. each dictionary has "title" -> nsstring, "isChecked" -> NSNumber 
@property (weak)   id<DParallaxDelegate> delegate;
@property (nonatomic) int currentPage;

-(void) tile;
@end

@implementation DParallaxView

@synthesize boards;
@synthesize delegate;
@synthesize currentPage;

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        mMainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [mMainView setShowsHorizontalScrollIndicator:NO];
        mMainView.delegate = self;
        mMainView.pagingEnabled = NO;
        [self addSubview:mMainView];
        
        mFirstView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mFirstView.userInteractionEnabled = NO;
        mFirstView.delegate = self;
        mFirstView.backgroundColor = [UIColor clearColor];
        mFirstImageFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_1st.png"]];
        [mFirstView addSubview:mFirstImageFront];
        mFirstImageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_1st.png"]];
        mFirstImageBack.frame = CGRectMake(-960,0,960,self.bounds.size.height);
        [mFirstView addSubview:mFirstImageBack];
        mFirstView.contentSize = CGSizeMake(960, self.bounds.size.height);
        [self insertSubview:mFirstView belowSubview:mMainView];
        mFirstFrontIndex = -100;
        mFirstBackIndex = -100;
        
        mSecondView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mSecondView.userInteractionEnabled = NO;
        mSecondView.delegate = self;
        mSecondView.backgroundColor = [UIColor clearColor];
        mSecondImageFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_2nd.png"]];
        [mSecondView addSubview:mSecondImageFront];
        mSecondImageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_2nd.png"]];
        mSecondImageBack.frame = CGRectMake(-960,0,960,self.bounds.size.height);
        [mSecondView addSubview:mSecondImageBack];
        mSecondView.contentSize = CGSizeMake(960, self.bounds.size.height);
        [self insertSubview:mSecondView belowSubview:mFirstView];
        mSecondFrontIndex = -100;
        mSecondBackIndex = -100;
        
        mThirdView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mThirdView.userInteractionEnabled = NO;
        mThirdView.delegate = self;
        mThirdView.backgroundColor = [UIColor clearColor];
        mThirdImageFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_3rd.png"]];
        [mThirdView addSubview:mThirdImageFront];
        mThirdImageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_3rd.png"]];
        mThirdImageBack.frame = CGRectMake(-960,0,960,self.bounds.size.height);
        [mThirdView addSubview:mThirdImageBack];
        mThirdView.contentSize = CGSizeMake(960, self.bounds.size.height);
        [self insertSubview:mThirdView belowSubview:mSecondView];
        mThirdFrontIndex = -100;
        mThirdBackIndex = -100;
        
        
        mFourthView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mFourthView.userInteractionEnabled = NO;
        mFourthView.delegate = self;
        mFourthView.backgroundColor = [UIColor clearColor];
        mFourthImageFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_4th.png"]];
        [mFourthView addSubview:mFourthImageFront];
        mFourthImageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_4th.png"]];
        mFourthImageBack.frame = CGRectMake(-960,0,960,self.bounds.size.height);
        [mFourthView addSubview:mFourthImageBack];
        mFourthView.contentSize = CGSizeMake(960, self.bounds.size.height);
        [self insertSubview:mFourthView belowSubview:mThirdView];
        mFourthBackIndex = -100;
        mFourthFrontIndex = -100;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == mMainView) {
        mFirstView.contentOffset    = CGPointMake(mMainView.contentOffset.x * FIRST_RATIO, mMainView.contentOffset.y);
        mSecondView.contentOffset   = CGPointMake(mMainView.contentOffset.x * SECOND_RATIO, mMainView.contentOffset.y);
        mThirdView.contentOffset    = CGPointMake(mMainView.contentOffset.x * THIRD_RATIO, mMainView.contentOffset.y);
        mFourthView.contentOffset   = CGPointMake(mMainView.contentOffset.x * FOURTH_RATIO, mMainView.contentOffset.y);
        [self tile];
    }
}
-(void) setBoards:(NSArray*) arr
{
    boards = arr;
    mMainView.contentSize   = CGSizeMake(320*([boards count]/3),self.bounds.size.height);
    mFirstView.contentSize  = CGSizeMake(320*([boards count]/3)*FIRST_RATIO,self.bounds.size.height);
    mSecondView.contentSize = CGSizeMake(320*([boards count]/3)*SECOND_RATIO,self.bounds.size.height);
    mThirdView.contentSize  = CGSizeMake(320*([boards count]/3)*THIRD_RATIO,self.bounds.size.height);
    mFourthView.contentSize = CGSizeMake(320*([boards count]/3)*FOURTH_RATIO,self.bounds.size.height);
    self.currentPage = 0;
    [self tile];
}
#pragma mark -
#pragma mark Tiling and page configuration

-(void) tile
{
    //page number mapping of view
    //-1,0,1,2,3,4 -> 1 
    //5,6,7,8,9,10 -> 7 page for front view (front view is placed at 1,7,13,19)
    
    //2,3,4,5,6,7 -> 4 page
    //8,9,10,11,12,13 -> 10 page
    int firstCurrentPage = (int)floor(mFirstView.contentOffset.x/320.0);
    
    if(mFirstFrontIndex != (((firstCurrentPage+1)/6)*6)+1) {
        mFirstFrontIndex = (((firstCurrentPage+1)/6)*6)+1;
        mFirstImageFront.frame = CGRectMake( (mFirstFrontIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    if(mFirstBackIndex != (((firstCurrentPage+4)/6)*6)-2) {
        mFirstBackIndex = (((firstCurrentPage+4)/6)*6)-2;
        mFirstImageBack.frame = CGRectMake( (mFirstBackIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    
    int secondCurrentPage = (int)floor(mSecondView.contentOffset.x/320.0);
    
    if(mSecondFrontIndex != (((secondCurrentPage+1)/6)*6)+1) {
        mSecondFrontIndex = (((secondCurrentPage+1)/6)*6)+1;
        mSecondImageFront.frame = CGRectMake( (mSecondFrontIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    if(mSecondBackIndex != (((secondCurrentPage+4)/6)*6)-2) {
        mSecondBackIndex = (((secondCurrentPage+4)/6)*6)-2;
        mSecondImageBack.frame = CGRectMake( (mSecondBackIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    

    int thirdCurrentPage = (int)floor(mThirdView.contentOffset.x/320.0);
    
    if(mThirdFrontIndex != (((thirdCurrentPage+1)/6)*6)+1) {
        mThirdFrontIndex = (((thirdCurrentPage+1)/6)*6)+1;
        mThirdImageFront.frame = CGRectMake( (mThirdFrontIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    if(mThirdBackIndex != (((thirdCurrentPage+4)/6)*6)-2) {
        mThirdBackIndex = (((thirdCurrentPage+4)/6)*6)-2;
        mThirdImageBack.frame = CGRectMake( (mThirdBackIndex-1)*320, 0, 960, self.bounds.size.height);
    }

    //fourth
    int fourthCurrentPage = (int)floor(mFourthView.contentOffset.x/320.0);
    
    if(mFourthFrontIndex != (((fourthCurrentPage+1)/6)*6)+1) {
        mFourthFrontIndex = (((fourthCurrentPage+1)/6)*6)+1;
        mFourthImageFront.frame = CGRectMake( (mFourthFrontIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    if(mFourthBackIndex != (((fourthCurrentPage+4)/6)*6)-2) {
        mFourthBackIndex = (((fourthCurrentPage+4)/6)*6)-2;
        mFourthImageBack.frame = CGRectMake( (mFourthBackIndex-1)*320, 0, 960, self.bounds.size.height);
    }
    
    
}

@end

@interface DViewController ()
{
    DParallaxView *mParallax;
}
@end

@implementation DViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    mParallax = [[DParallaxView alloc] initWithFrame:self.view.bounds];
    NSArray *arr=[ NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"One",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Two",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Three",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Four",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Five",[NSNumber numberWithBool:YES], nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Six",[NSNumber numberWithBool:YES], nil],

                  nil];
    mParallax.boards = arr;
    [self.view addSubview:mParallax];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

@end
