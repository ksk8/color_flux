//
//  ViewController.h
//  ColMem
//
//  Created by Kiddi on 07/06/14.
//  Copyright (c) 2014 KRabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>

//Breytur
int X;
int Y;
BOOL Started = NO;
int Level = 3;
int Speed = 5;
int NumBer;
int BloonNumber = 0;
int OldNumBer;
int Count = 0;
int i = 0;
int LengthA;
int counter;
int CorrectAns = 0;
int FramePos = 1;
int LevelStatus = 1;
int xLeftLimit = 25;
int xRightLimit = 295;
int yUpLimit = 120;
int yDownLimit = 390;
int yMiddle = 255;
int xMiddle = 160;
int HighScoreInt;
int xBloon = 0;
int yBloon = 0;
int Score = 0;
int BloonRandom;
BOOL END = YES;
BOOL FirstRound;
BOOL NewColor;
BOOL Bonus = NO;
BOOL BloonGO = NO;
int BonusNumber;
BOOL TwoBloons = NO;
int BloonsHit = 0;
BOOL BloonShown = YES;
BOOL iPAD = NO;
int Delta = 5;

CGSize result;

NSInteger Length;


NSString *BloonColor;
NSString *Color;
NSString *ColorPick;
NSMutableArray *Colors;



@interface ViewController : UIViewController <GKGameCenterControllerDelegate>

{
    
    AVAudioPlayer *audioPlayer;
    IBOutlet UIImageView *Moving;
    IBOutlet UIImageView *Frame;
    IBOutlet UIButton *Red;
    IBOutlet UIButton *Yellow;
    IBOutlet UIButton *Blue;
    IBOutlet UIButton *Green;
    IBOutlet UIImageView *HeaderName;
    IBOutlet UILabel *PushToStart;
    IBOutlet UILabel *Counter;
    IBOutlet UILabel *Correct;
    IBOutlet UILabel *NextLevel;
    IBOutlet UILabel *LevelStat;
    IBOutlet UILabel *GameOver;
    IBOutlet UILabel *HighScore;
    IBOutlet UIButton *Bloon;
    IBOutlet UIButton *Leaderboard;
    IBOutlet UILabel *ScoreText;
    IBOutlet UILabel *Instructions1;
    IBOutlet UILabel *Instructions2;
    
    NSTimer *Movement;
    NSTimer *SecondMove;
    NSTimer *Movement2;
}

-(void)BeginGame;
-(void)TimersGame;
-(void)LevelOver;
-(void)Levels;
-(void)PickRight;
-(void)CheckColor;
-(void)GameOver;
-(void)NextLevel;
-(void)themeSong;
-(void)wallSong;
-(void)noSong;
-(void)yesSong;
-(void)BloonHidden;

- (IBAction)showGCOptions:(id)sender;

@end
