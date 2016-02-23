//
//  ViewController.m
//  ColMem
//
//  Created by Kiddi on 07/06/14.
//  Copyright (c) 2014 KRabbi. All rights reserved.
//

#import "ViewController.h"
#import "CustomActionSheet.h"

@interface ViewController ()
// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

@property (nonatomic) BOOL notLoggedIN;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

@property (nonatomic, strong) CustomActionSheet *customActionSheet;

@end

@implementation ViewController

///GAME CENTER

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                _notLoggedIN = NO;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
                _notLoggedIN = YES;
                
            }
        }
    };
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = LevelStatus - 1;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else {
        
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}


- (IBAction)showGCOptions:(id)sender {
    // Allow the action sheet to be displayed if only the gameCenterEnabled flag is true, meaning if only
    // a player has been authenticated.
    if (_gameCenterEnabled) {
        if (_customActionSheet != nil) {
            _customActionSheet = nil;
        }
        
        // Create a CustomActionSheet object and handle the tapped button in the completion handler block.
        
        _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@"Remember?"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"View Leaderboard", nil];
        
        
        [_customActionSheet showInView:self.view
                 withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {
                     if ([buttonTitle isEqualToString:@"View Leaderboard"]) {
                         [self showLeaderboardAndAchievements:YES];
                     }
                 }];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

/////////GAME CENTER

//Clocks
-(void)TimersGame{
    Movement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BeginGame)userInfo:nil repeats:YES];
}

//GamePlay

-(void)BeginGame{
    
    LevelStat.text = [NSString stringWithFormat:@"Level: %i", LevelStatus];
    
        ScoreText.text = [NSString stringWithFormat:@"Score: %i", Score];
    
    Frame.hidden = NO;
    Counter.hidden = NO;
    
    Counter.text = [NSString stringWithFormat:@"%i", Count+1];
    
    BonusNumber = arc4random()%25;
    
    if (Level > 3){
        if (Count > 0 && Count < Level - 1) {
            if (BonusNumber == 13){
                if (Bonus == NO) {
                    BloonGO = YES;
                }
            }
            
            if (BloonGO == YES) {
                
                OldNumBer = NumBer;
                NumBer = arc4random()%4;
                if (OldNumBer == NumBer && NumBer < 3){
                    NumBer = NumBer + 1;
                }
                else if (OldNumBer == NumBer && NumBer == 3){
                    NumBer = NumBer - 1;
                }
                
                if (NumBer == 0){
                    BloonColor = @"bloon.png";
                }
                else if (NumBer == 1){
                    BloonColor = @"bloonBlue.png";
                }
                else if (NumBer == 2){
                    BloonColor = @"bloonYellow.png";
                }
                else if (NumBer == 3){
                    BloonColor = @"bloonGreen.png";
                }

                
                UIImage *BloonImage = [UIImage imageNamed:BloonColor];
                [Bloon setImage:BloonImage forState:UIControlStateNormal];
                
                BloonGO = NO;
                Bloon.hidden = NO;
                BonusNumber = 10;
                if (iPAD == YES){
                    
                    yBloon = Level*3;
                }
                else{
                    yBloon = Level;
                }
                Bonus = YES;
        
            }
        }
    }
    
    if (NewColor == YES){
        [self Levels];
        OldNumBer = NumBer;
        NumBer = arc4random()%4;
        if (OldNumBer == NumBer && NumBer < 3){
            NumBer = NumBer + 1;
        }
        else if (OldNumBer == NumBer && NumBer == 3){
            NumBer = NumBer - 1;
        }
        
        if (NumBer == 0){
            Color = @"red.png";
            NewColor = NO;
        }
        else if (NumBer == 1){
            Color = @"blue.png";
            NewColor = NO;
        }
        else if (NumBer == 2){
            Color = @"yellow.png";
            NewColor = NO;
        }
        else if (NumBer == 3){
            Color = @"green.png";
            NewColor = NO;
        }
        [Colors addObject:Color];
        Moving.hidden = YES;
    }
    
    
    
    if (Moving.center.y >= yDownLimit) {
        if (FirstRound == NO){
            Moving.hidden = NO;
            Moving.image = [UIImage imageNamed:Color];
            [Movement invalidate];
            [self performSelector:@selector(TimersGame) withObject:nil afterDelay:0.1];
            X = Speed;
            Y = -Speed;
            Count++;
            NewColor = YES;
            [self wallSong];
            
        }
        else{
            X = Speed;
            Y = -Speed;
            FirstRound = NO;
        }
    }
    
    else if (Moving.center.y <= yUpLimit) {
        Moving.hidden = NO;
        Moving.image = [UIImage imageNamed:Color];
        [Movement invalidate];
        [self performSelector:@selector(TimersGame) withObject:nil afterDelay:0.1];
        X = -Speed;
        Y = Speed;
        Count++;
        NewColor = YES;
        [self wallSong];
        
    }
    
    else if (Moving.center.x >= xRightLimit) {
        Moving.hidden = NO;
        Moving.image = [UIImage imageNamed:Color];
        [Movement invalidate];
        [self performSelector:@selector(TimersGame) withObject:nil afterDelay:0.1];
        X = -Speed;
        Y = -Speed;
        Count++;
        NewColor = YES;
        [self wallSong];
        
    }
    
    else if (Moving.center.x <= xLeftLimit) {
        Moving.hidden = NO;
        Moving.image = [UIImage imageNamed:Color];
        [Movement invalidate];
        [self performSelector:@selector(TimersGame) withObject:nil afterDelay:0.1];
        X = Speed;
        Y = Speed;
        Count++;
        NewColor = YES;
        [self wallSong];

    }
    
    if (Bloon.center.y <= 110) {
        Bloon.hidden = YES;
    }
    
    Moving.center = CGPointMake(Moving.center.x + X, Moving.center.y + Y);
    Frame.center = CGPointMake(Frame.center.x + X, Frame.center.y + Y);
    Bloon.center = CGPointMake(BloonRandom, Bloon.center.y - yBloon);
}


//Levels
-(void)Levels{
    if (Count >= Level) {
        Frame.center = CGPointMake(xRightLimit - Delta,yMiddle);
        Moving.center = CGPointMake(xRightLimit - Delta,yMiddle);
        [self LevelOver];
    }
}

-(void)LevelOver{
    [Movement invalidate];
    
    Moving.hidden = YES;
    HeaderName.hidden = YES;
    PushToStart.hidden = YES;
    Frame.hidden = YES;
    Bloon.hidden = YES;
    Count = 0;
    NSLog(@"%@", Colors);
    FramePos = 1;
    yBloon = 0;
    [self PickRight];
}

-(void)PickRight{
    
    Red.hidden = NO;
    Blue.hidden = NO;
    Yellow.hidden = NO;
    Green.hidden = NO;
    Frame.hidden = NO;
    Count++;
    Correct.hidden = YES;
    Counter.text = [NSString stringWithFormat:@"%i", Count];
    Length = [Colors count];
    LengthA = Length;
    NSLog(@"%@",Colors[Count-1]);
    Frame.hidden = NO;
    
}

-(void)CheckColor{
    Moving.hidden = YES;
    
        if (Colors[Count-1] == ColorPick) {
            Correct.hidden = NO;
            Correct.text = @"CORRECT!";
            [self yesSong];
            CorrectAns++;
            Score++;
            Frame.hidden = YES;
            if (CorrectAns == Level) {
                
                Counter.hidden = YES;
                Correct.hidden = NO;
                Correct.text = @"GOOD JOB!";
                [self performSelector:@selector(NextLevel) withObject:nil afterDelay:1];
                
            }
            else{
                [self performSelector:@selector(PickRight) withObject:nil afterDelay:0.5];
                
                if(FramePos == 1){
                   Frame.center = CGPointMake(xMiddle,yUpLimit + Delta);
                    Moving.center = CGPointMake(xMiddle,yUpLimit + Delta);
                    FramePos = 2;
                }
                else if (FramePos == 2){
                    Frame.center = CGPointMake(xLeftLimit + Delta,yMiddle);
                    Moving.center = CGPointMake(xLeftLimit + Delta,yMiddle);
                    FramePos = 3;
                }
                else if (FramePos == 3){
                    Moving.center = CGPointMake(xMiddle,yDownLimit - Delta);
                    Frame.center = CGPointMake(xMiddle,yDownLimit - Delta);
                    FramePos = 4;
                }
                else if (FramePos == 4){
                    Moving.center = CGPointMake(xRightLimit - Delta,yMiddle);
                    Frame.center = CGPointMake(xRightLimit - Delta,yMiddle);
                    FramePos = 1;
                }
            }
            
        }
        else {
            [self noSong];
            Correct.text = @"INCORRECT";
            Correct.hidden = NO;
            Red.hidden = YES;
            Yellow.hidden = YES;
            Blue.hidden = YES;
            Green.hidden = YES;
            Counter.hidden = YES;
            Frame.hidden = YES;
            GameOver.hidden = NO;
            [self performSelector:@selector(GameOver) withObject:nil afterDelay:1.5];
        }
    
    ScoreText.text = [NSString stringWithFormat:@"Score: %i", Score];
    
}

-(void)GameOver{
    
    [self themeSong];
    Started = NO;
    PushToStart.hidden = NO;
    HeaderName.hidden = NO;
    Correct.hidden = YES;
    GameOver.hidden = YES;
    Leaderboard.hidden = NO;
    Instructions1.hidden = NO;
    Instructions2.hidden = NO;
    Bonus = NO;
    BloonGO = NO;
    if (Score > HighScoreInt){
        
        HighScoreInt = Score;
        [[NSUserDefaults standardUserDefaults] setInteger:HighScoreInt forKey:@"HighScoreSaved"];
        
    }
    HighScore.text = [NSString stringWithFormat:@"Best: %i", HighScoreInt];
    LevelStatus = 1;
    Count = 0;
    Level = 3;
    CorrectAns = 0;
    Score = 0;
    yBloon = 0;
    BloonsHit = 0;

}

-(void)NextLevel{
    
    Level++;
    LevelStatus++;
    [self themeSong];
    NextLevel.hidden = NO;
    PushToStart.hidden = NO;
    Correct.hidden = YES;
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    Frame.hidden = YES;
    CorrectAns = 0;
    Started = NO;
    Bonus = NO;
    BloonGO = NO;
    
    
    
    if (Speed >= 10){
        Speed = 10;
    }
    else {
        Speed = Speed * 1.15;
    }

}

- (IBAction)YellowPressed:(id)sender {
    ColorPick = @"yellow.png";
    NSLog(@"%@",ColorPick);
    Moving.hidden = NO;
    Moving.image = [UIImage imageNamed:@"yellow.png"];
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    [self performSelector:@selector(CheckColor) withObject:nil afterDelay:0.5];
}
- (IBAction)RedPressed:(id)sender {
    ColorPick = @"red.png";
    NSLog(@"%@",ColorPick);
    Moving.hidden = NO;
    Moving.image = [UIImage imageNamed:@"red.png"];
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    [self performSelector:@selector(CheckColor) withObject:nil afterDelay:0.5];
}
- (IBAction)GreenPressed:(id)sender {
    ColorPick = @"green.png";
    NSLog(@"%@",ColorPick);
    Moving.hidden = NO;
    Moving.image = [UIImage imageNamed:@"green.png"];
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    [self performSelector:@selector(CheckColor) withObject:nil afterDelay:0.5];
}
- (IBAction)BluePressed:(id)sender {
    ColorPick = @"blue.png";
    NSLog(@"%@",ColorPick);
    Moving.hidden = NO;
    Moving.image = [UIImage imageNamed:@"blue.png"];
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    [self performSelector:@selector(CheckColor) withObject:nil afterDelay:0.5];
}

- (IBAction)BloonPressed:(id)sender {
    UIImage *BloonImage = [UIImage imageNamed:@"+2points.png"];
    [Bloon setImage:BloonImage forState:UIControlStateNormal];
    Score = Score + 2;
    yBloon = 0;
    BloonsHit++;
    [self performSelector:@selector(BloonHidden) withObject:nil afterDelay:1];

}

-(void)BloonHidden{
    Bloon.hidden = YES;
    Bonus = YES;
    if (TwoBloons == NO && LevelStatus > 4){
        
        if(iPAD == NO){
            BloonRandom = arc4random()%200;
            BloonRandom = BloonRandom + 60;
            Bloon.center = CGPointMake(BloonRandom,yDownLimit);
            TwoBloons = YES;
            yBloon = 0;
            Bonus = NO;
        }
        else{
            BloonRandom = arc4random()%568;
            BloonRandom = BloonRandom + 100;
            Bloon.center = CGPointMake(BloonRandom,yDownLimit);
            TwoBloons = YES;
            yBloon = 0;
            Bonus = NO;
        }
        
    }
}

////Music

-(void)noSong{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/no.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 0.3; // 0.0 - no volume; 1.0 full volume
    [audioPlayer play];
    
}

-(void)yesSong{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/yes.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 0.2; // 0.0 - no volume; 1.0 full volume
    [audioPlayer play];
    
}


-(void)wallSong{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wall.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 0.7; // 0.0 - no volume; 1.0 full volume
    [audioPlayer play];
    
}

-(void)themeSong{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/theme.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 0.5; // 0.0 - no volume; 1.0 full volume
    [audioPlayer play];
    
}

- (void)fadeVolumeDown:(AVAudioPlayer *)aPlayer
{
    aPlayer.volume = aPlayer.volume - 0.1;
    if (aPlayer.volume < 0.1) {
        [aPlayer stop];
    } else {
        [self performSelector:@selector(fadeVolumeDown:) withObject:aPlayer afterDelay:0.3];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (Started == NO){
        
        Moving.hidden = YES;
        Frame.hidden = YES;
        HeaderName.hidden = YES;
        PushToStart.hidden = YES;
        Red.hidden = YES;
        Yellow.hidden = YES;
        Blue.hidden = YES;
        Green.hidden = YES;
        NextLevel.hidden = YES;
        LevelStat.hidden = NO;
        GameOver.hidden = YES;
        Leaderboard.hidden = YES;
        ScoreText.hidden = NO;
        TwoBloons = NO;
        Instructions1.hidden = YES;
        Instructions2.hidden = YES;
        
        
        [Colors removeAllObjects];
        
        Moving.center = CGPointMake(xMiddle, yDownLimit);
        Frame.center = CGPointMake(xMiddle,yDownLimit);
        NewColor = YES;
        FirstRound = YES;
        Count = 0;
        [self TimersGame];
        [self performSelector:@selector(fadeVolumeDown:)
                   withObject:audioPlayer
                   afterDelay:0.1
                      inModes:[NSArray arrayWithObject: NSRunLoopCommonModes]];
        if (iPAD == NO){
            
            BloonRandom = arc4random()%200;
            BloonRandom = BloonRandom + 60;
        
            Bloon.center = CGPointMake(BloonRandom,yDownLimit);
                            
        }
        else{
            
            BloonRandom = arc4random()%568;
            BloonRandom = BloonRandom + 100;
                        
            Bloon.center = CGPointMake(BloonRandom,yDownLimit);
            
        }
        
                        
        
    }
    Started = YES;
    
}

- (void)viewDidLoad{
    
    _notLoggedIN = YES;
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"ColorFluxStodutafla";
    
    HighScoreInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    
    HighScore.text = [NSString stringWithFormat:@"Best: %i", HighScoreInt];
    
    [self themeSong];
    
    Colors= [[NSMutableArray alloc] init];
    Moving.hidden = YES;
    HeaderName.hidden = NO;
    PushToStart.hidden = NO;
    Frame.hidden = YES;
    Counter.hidden = YES;
    Correct.hidden = YES;
    NextLevel.hidden = YES;
    LevelStat.hidden = YES;
    Red.hidden = YES;
    Yellow.hidden = YES;
    Blue.hidden = YES;
    Green.hidden = YES;
    GameOver.hidden = YES;
    Bloon.hidden = YES;
    ScoreText.hidden = YES;
    TwoBloons = NO;
    Leaderboard.hidden = _notLoggedIN;
    
    
    result = [[UIScreen mainScreen] bounds].size;
    int screenSize = result.height;
    if (screenSize > 600){
        
        iPAD = YES;
        
        xLeftLimit = 75;
        xRightLimit = 768 - 75;
        yUpLimit = 75 + 75;
        yDownLimit = 853 - 75;
        yMiddle = 1024/2;
        xMiddle = 768/2;
        Speed = 15;
        Delta = 15;
        
        NSLog(@"IPAD");
        
    }

    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
