//
//  PartyDetialViewController.m
//  Combo
//
//  Created by yilinlin on 13-3-19.
//  Copyright (c) 2013年 yilinlin. All rights reserved.
//

#import "PartyDetialViewController.h"

@interface PartyDetialViewController ()

@end

@implementation PartyDetialViewController
@synthesize tableview;
@synthesize items;
@synthesize p_id;
@synthesize party;
@synthesize userUUid;
@synthesize numberUUID;
@synthesize creatUser,joinUser;
@synthesize FlowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    numFlogLogout=0;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"partynavigation"] forBarMetrics:UIBarMetricsDefault];
    // NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:239.0/255 green:105.0/255 blue:87.0/255 alpha:1] forKey:UITextAttributeTextColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:239.0/255.0 green:105.0/255.0 blue:87.0/255.0 alpha:1.0],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:18],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 40, 35);
    [backbutton setImage:[UIImage imageNamed:@"partyback"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    [self getUUidForthis];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUUidForthis];
    mark=0;
    //[UIApplication sharedApplication].delegate=self;
    //self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView* table=[[UITableView alloc]initWithFrame:mainscreen style:UITableViewStyleGrouped];
    self.tableview=table;
    [self.view addSubview:self.tableview];
    self.tableview.backgroundView=nil;
    self.tableview.backgroundColor=[UIColor colorWithRed:241.0/255 green:241.0/255 blue:236.0/255 alpha:1];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    //======================================
    stringA=[[NSMutableString alloc]initWithCapacity:100];
    
    //==================请求数据========================================
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00105?p_id=%@&&uuid=%@",p_id,userUUid];
    NSString *stringP=globalURL(str);
    NSLog(@"shuchuwangzhi::::::::::::::::%@",stringP);
    NSURL* url=[NSURL URLWithString:stringP];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];
    //==============================
    label = [[UILabel alloc] initWithFrame:CGRectMake(70,100,180,100)];
    label.numberOfLines =0;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:110.0/255 green:109.0/255 blue:109.0/255 alpha:1];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    //=======================================
    
    
    self.navigationItem.hidesBackButton=YES;
    
}
-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *stringUUID=[stringmutable objectAtIndex:0];
    NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    self.userUUid=stringUUID;
    if (userUUid==nil) {
        userUUid=@"10002";
    }
    self.numberUUID=[NSNumber numberWithInt:[stringUUID intValue]];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (numFlogLogout==0) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        self.party =[bizDic objectForKey:@"partys"];
        NSLog(@"hhhhhhhhhhhhhhhhhhhhhh%@",party);
        self.creatUser=[party objectForKey:@"creaters"];
        self.joinUser=[party objectForKey:@"participants"];
        NSDictionary* userdict=[self.creatUser objectAtIndex:0];
        label.text=[userdict objectForKey:@"USER_NICK"];
        NSString *stringButton=[[party objectForKey:@"P_STATUS"]substringToIndex:1];
        if ([stringButton isEqualToString:@"Y"]||[stringButton isEqualToString:@"W"]) {
            UIButton *jionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *stringStatus=[party objectForKey:@"take_status"];
            if (![[stringStatus substringToIndex:1] isEqualToString:@"Y"]) {
                UIButton *buttonGoParty=[UIButton buttonWithType:UIButtonTypeCustom];
                [buttonGoParty setImage:[UIImage imageNamed:@"Pjoin"] forState:UIControlStateNormal];
                buttonGoParty.titleLabel.text=@"加入派对";
                if ([stringButton isEqualToString:@"W"]) {
                    [buttonGoParty addTarget:self action:@selector(buttonNojoinWaite) forControlEvents:UIControlEventTouchUpInside];
                }
                else{
                    [buttonGoParty addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                [buttonGoParty setFrame:CGRectMake(0,mainscreenhight-107, 160, 44)];
                [self.view addSubview:buttonGoParty];
            }
            else
            {
                [jionButton setImage:[UIImage imageNamed:@"Pout"] forState:UIControlStateNormal];
                jionButton.titleLabel.text=@"我不去了";
                [jionButton addTarget:self action:@selector(buttonNojoin:) forControlEvents:UIControlEventTouchUpInside];
                [jionButton setFrame:CGRectMake(0,mainscreenhight-107, 160, 44)];
                [self.view addSubview:jionButton];
                
                
            }
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(158, mainscreenhight-100, 2, 30)];
            imageView.image=[UIImage imageNamed:@"CutOffRule.png"];
            
            [self.view addSubview:imageView];
            //==========邀请按钮===============================
            UIButton *inviteButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [inviteButton setImage:[UIImage imageNamed:@"Pinvite"] forState:UIControlStateNormal];
            [inviteButton addTarget:self action:@selector(showFriendView:) forControlEvents:UIControlEventTouchUpInside];
            [inviteButton setFrame:CGRectMake(160,mainscreenhight-107, 160, 44)];
            [self.view addSubview:inviteButton];
            
        }
        
        FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
        FlowView.delegate = self;
        FlowView.dataSource = self;
        FlowView.minimumPageAlpha = 0.7;
        FlowView.minimumPageScale = 0.6;
        [tableview reloadData];
    }
}
-(void)buttonNojoinWaite
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在等待创建者同意" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)buttonNojoin:(UIButton *)btn
{
    NSString *stringPid=[party objectForKey:@"P_ID"];
    for (NSDictionary *dicJion in [party objectForKey:@"creaters"])
    {
        if ([[dicJion objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID]) {
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你是联合创建人，不能退出活动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
        }
    }
    
    for ( NSDictionary *dicParty in [party objectForKey:@"participants"])
    {
        numFlogLogout=1;
        NSLog(@"qqqqqqqqqqqqqqqqqqq%@",[dicParty objectForKey:@"USER_ID"]);
        NSLog(@"wwwwwwwwwwwwwwwwwww%@",self.userUUid);
        if ([[dicParty objectForKey:@"USER_ID"] isEqualToNumber:self.numberUUID])
        {
            
            NSString* str=@"mac/party/IF00041";
            NSString* strURL=globalURL(str);
            NSURL *url=[NSURL URLWithString:strURL];
            NSLog(@"pidssssssssssss%@",stringPid);
            ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
            [rrequest setPostValue:self.userUUid forKey: @"uuid"];
            [rrequest setPostValue:stringPid forKey: @"p_id"];
            [rrequest setDelegate:self];
            [rrequest startAsynchronous];
            
        }
        
    }
}
-(void)ButtonClick:(UIButton *)btn
{
    
    NSString *stringStatus=[party objectForKey:@"IN_STATUS"];
    if ([[stringStatus substringToIndex:1] isEqualToString:@"Y"]) {
        NSString* str=@"mac/party/IF00053";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
        [request setPostValue:self.userUUid forKey: @"uuid"];
        [request setPostValue:self.p_id forKey:@"p_id"];
        //[request setDelegate:self];
        [request startSynchronous];
    }
    else
    {
        //btn.selected=!btn.selected;
        invit=[[InvitViewController alloc]init];
        invit.temp=2;
        invit.from_p_id=self.p_id;
        NSLog(@"输出pid%@",invit.from_p_id);
        [self.navigationController pushViewController:invit animated:YES];
    }
    
}
-(void)showFriendView:(UIButton *)btF
{
    btF.selected=!btF.selected;
    NSLog(@"join");
    if ([[party objectForKey:@"P_TYPE"]intValue]==1) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=4;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        [self.navigationController pushViewController:friend animated:YES];
        
    }
    else if ([[party objectForKey:@"P_TYPE"]intValue]==2) {
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    else if([[party objectForKey:@"P_TYPE"]intValue]==3){
        friend=[[CheckOneViewController alloc]init];
        friend.spot=2;
        friend.from_p_id=[party objectForKey:@"P_ID"];
        friend.from_c_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:friend animated:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,[UIFont systemFontOfSize:20],
                          UITextAttributeFont,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
//========================== 分组个数============================================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 266;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 120;
}
//=====================行的间距======================================================
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int row=[indexPath row];
    if (row==0) {
        return 22;
    }
    if (row==1) {
        return 33;
    }
    if (row==2) {
        return 47;
    }
    if (row==3) {
        return 36;
    }
    if (row==4) {
        UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 16;
}
//==================cell的内容=====================================================
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellAccessoryNone;
    if (indexPath.row==0) {
        
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party0"]];        
        //不属于任何活动
        if ([[party objectForKey:@"P_TYPE"]intValue]==1)
        {
            UIImageView* NCImage=[[UIImageView alloc]initWithFrame:CGRectMake(199, 0, 101, 22)];
            NCImage.image=[UIImage imageNamed:@"NCButton"];
            [cell.contentView addSubview:NCImage];
        }
        else{
            UIButton* Cbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            Cbutton.frame=CGRectMake(199, 0, 101, 22);
            [Cbutton setImage:[UIImage imageNamed:@"CButton"] forState:UIControlStateNormal];
            [Cbutton addTarget:self action:@selector(JumpCollection) forControlEvents:UIControlEventTouchDown];
            UILabel* CLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 101, 22)];
            CLabel.text=[party objectForKey:@"C_TITLE"];
            CLabel.textColor=[UIColor whiteColor];
            CLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
            NSLog(@"CLabel.text:%@",[party objectForKey:@"C_TITLE"]);
            CLabel.backgroundColor=[UIColor clearColor];
            CLabel.textAlignment=NSTextAlignmentCenter;
            [Cbutton addSubview:CLabel];
            [cell.contentView addSubview:Cbutton];
        }
        return cell;
    }
    
    
    if (indexPath.row==1) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party1"]];
        UILabel* timelabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 33)];
        timelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        timelabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
        NSInteger time=[[party objectForKey:@"P_STIME"]integerValue];
        NSLog(@"%d",time);
        NSDate* date=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",date);
        NSString *confromTimespStr = [formatter stringFromDate:date];
        timelabel.text=confromTimespStr;
        [cell.contentView addSubview:timelabel];
        return cell;
    }
    if (indexPath.row==2) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party2"]];
        UILabel* addrlabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 33)];
        addrlabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        addrlabel.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        addrlabel.text=[party objectForKey:@"P_LOCAL"];
        [cell.contentView addSubview:addrlabel];
        return cell;
    }
    if (indexPath.row==3) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party3"]];
        return cell;
         
    }
    if (indexPath.row==4) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party4"]];
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        labelName.numberOfLines = 0;
        labelName.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        labelName.textColor=[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1];
        labelName.backgroundColor=[UIColor clearColor];
        labelName.textColor=[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1];
        [cell.contentView addSubview:labelName];
        
        
        CGRect cellFrame = CGRectMake(30, 15.0, 265, 60);
        labelName.text=[party objectForKey:@"P_INFO"];
        CGRect rect = cellFrame;
        labelName.frame = rect;
        [labelName sizeToFit];
        cellFrame.size.height = labelName.frame.size.height+75;
        [cell setFrame:cellFrame];
        return cell;
    }
        if (indexPath.row==5) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"party5"]];
        return cell;
    }
        

    return cell;
}
//=========================界面跳转=======================================
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        mapViewController=[[MyMapViewController alloc] init];
        //[mapViewController initData:self.party];
        //转换出现问题，待解决
        
        float lat=[[self.party objectForKey:@"LAT"]floatValue];
        float lng=[[self.party objectForKey:@"LNG"]floatValue];
        NSLog(@"2++++++%f %f",lat,lng);
        [mapViewController initData:lat and:lng];
        [mapViewController initTitle:[self.party objectForKey:@"P_TITLE"]];
        [self.navigationController pushViewController:mapViewController animated:YES];
        
    }
}
//==================头部放置动画效果===============================================
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageviewMidal=[[UIImageView alloc]initWithFrame:CGRectMake(159, 216, 2.5, 44)];
    UIImageView *PStatusImage=[[UIImageView alloc]initWithFrame:CGRectMake(7, 170, 307, 23)];
    if ([[[party objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"Y"]) {
        PStatusImage.image=[UIImage imageNamed:@"PY"];
    }
    else
    {
        if ([[[party objectForKey:@"P_STATUS"]substringToIndex:1]isEqualToString:@"W"]) {
            PStatusImage.image=[UIImage imageNamed:@"PW"];
        }
        else
        {
            
            PStatusImage.image=[UIImage imageNamed:@"PN"];
            
        }
    }
    imageviewMidal.image=[UIImage imageNamed:@"fangzhongjian"];
    UIButton* personButton=[UIButton buttonWithType:UIButtonTypeCustom];
    personButton.frame=CGRectMake(0, 216, 159, 44);
    
    NSString *stringPerson=[NSString stringWithFormat:@"%d 创建者",self.creatUser.count];
    personButton.titleLabel.text=stringPerson;
    personButton.tag=501;
    UIButton* personButtonUnin=[UIButton buttonWithType:UIButtonTypeCustom];
    personButtonUnin.frame=CGRectMake(161.5, 216, 160, 44);
    NSString *stringPersonUnin=[NSString stringWithFormat:@"%d创建者",self.joinUser.count];
    personButtonUnin.titleLabel.text=stringPersonUnin;
    personButtonUnin.tag=502;
    if (mark==0) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"CreatersSelect"] forState:UIControlStateNormal];
        personButton.userInteractionEnabled=NO;
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"Parters"] forState:UIControlStateNormal];
        [personButtonUnin addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        //lableNumc.layer.shadowOpacity=0.5;
        [personButton addSubview:lableNumc];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.shadowColor=[UIColor darkGrayColor];
        lableNumJ.textAlignment = NSTextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
    }
    if (mark==1) {
        [personButton setBackgroundImage:[UIImage imageNamed:@"Creaters"] forState:UIControlStateNormal];
        [personButton addTarget:self action:@selector(segmentClickJion:) forControlEvents:UIControlEventTouchUpInside];
        [personButtonUnin setBackgroundImage:[UIImage imageNamed:@"PartersSelect"] forState:UIControlStateNormal];
        personButtonUnin.userInteractionEnabled=NO;
        UILabel *lableNumc=[[UILabel alloc]initWithFrame:CGRectMake(30, -2, 50, 50)];
        lableNumc.textColor=[UIColor colorWithRed:123/255.0f green:140/255.0f blue:155/255.0f alpha:1];
        lableNumc.backgroundColor=[UIColor clearColor];
        lableNumc.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumc.shadowColor=[UIColor darkGrayColor];
        lableNumc.font=[UIFont systemFontOfSize:25];
        lableNumc.text=[NSString stringWithFormat:@"%d",self.creatUser.count];
        [personButton addSubview:lableNumc];
        UILabel *lableNumJ=[[UILabel alloc]initWithFrame:CGRectMake(-5, -2, 50, 50)];
        lableNumJ.textColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.backgroundColor=[UIColor clearColor];
        lableNumJ.shadowColor=[UIColor colorWithRed:239/255.0f green:105/255.0f blue:87/255.0f alpha:1];
        lableNumJ.font=[UIFont systemFontOfSize:25];
        lableNumJ.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
        lableNumJ.text=[NSString stringWithFormat:@"%d",self.joinUser.count];
        lableNumJ.textAlignment = NSTextAlignmentRight;
        [personButtonUnin addSubview:lableNumJ];
        
    }
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0,100, 320, 266)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiangbeijing"]];
    [view addSubview:FlowView];
    [view addSubview:label];
    [view addSubview:PStatusImage];
    [view addSubview:personButton];
    [view addSubview:personButtonUnin];
    [view addSubview:imageviewMidal];
    return view;
    
}



//=================选择哪个Segment改变图片的位置======================================
- (void)segmentClick:(UIButton *)btn
{
    
    mark=1;
    if ([self.joinUser count]!=0) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:0];
        label.text=[userdict objectForKey:@"USER_NICK"];
        [FlowView removeFromSuperview];
        FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
        FlowView.delegate = self;
        FlowView.dataSource = self;
        FlowView.minimumPageAlpha = 0.7;
        FlowView.minimumPageScale = 0.6;
        [tableview reloadData];
        
    }
}
-(void)segmentClickJion:(UIButton *)btn
{
    mark=0;
    NSDictionary* userdict=[self.creatUser objectAtIndex:0];
    label.text=[userdict objectForKey:@"USER_NICK"];
    [FlowView removeFromSuperview];
    FlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0,0,320,140)];
	FlowView.delegate = self;
    FlowView.dataSource = self;
    FlowView.minimumPageAlpha = 0.7;
    FlowView.minimumPageScale = 0.6;
    [tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(120,120);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView
{
    NSLog(@"Scrolled to page # %d", pageNumber);
    
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];
            
        }
    }
    
    
    if (OldPage < pageNumber)
    {
        label.center = CGPointMake(320+75,label.center.y);
    }else if(OldPage > pageNumber)
    {
        label.center = CGPointMake(-75,label.center.y);
    }
    
    label.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         label.center = CGPointMake(160,label.center.y);
         
     }completion:^(BOOL finished)
     {
         
     }];
    
    OldPage = pageNumber;
}

-(void)scrollViewdidend
{
    label.alpha = 1.0;
}

- (void)didScroll:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView point:(CGPoint)thePoint
{
    
    
    float point_x = (label.center.x - 1*(thePoint.x - oldPoint.x));
    
    label.center = CGPointMake(point_x,label.center.y);
    
    NSLog(@"000000   %f",point_x);
    if (label.center.x - (thePoint.x - oldPoint.x) -160 > 0)
    {
        label.alpha = fabs((double)((320-point_x)/160));
    }else
    {
        label.alpha = fabs((double)point_x/160);
    }
    oldPoint = thePoint;
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:pageNumber];
        label.text=[userdict objectForKey:@"USER_NICK"];
        
        
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:pageNumber];
            label.text=[userdict objectForKey:@"USER_NICK"];
            
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (mark==0) {
        return [self.creatUser count];
        
    }
    else{
        
        return [self.joinUser count];
        
    }
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    NSLog(@"index = %d",index);
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    
    NSURL *urlPic;
    if (mark==0) {
        NSDictionary* userdict=[self.creatUser objectAtIndex:index];
        urlPic=[NSURL URLWithString:[userdict objectForKey:@"USER_PIC"]];
    }
    if (mark==1) {
        if ([self.joinUser count]>0) {
            
            NSDictionary* userdict=[self.joinUser objectAtIndex:index];
            urlPic=[NSURL URLWithString:[userdict objectForKey:@"U_PIC"]];
        }
    }
    
    if (!imageView)
    {
        imageView = [[UIImageView alloc] init];
        //imageView.layer.cornerRadius = 70;
        imageView.tag = index+1000;
        imageView.layer.masksToBounds = YES;
        
        imageView.userInteractionEnabled = YES;
        
        [imageView setImageWithURL:urlPic refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];//[UIImage imageNamed:@"13.jpg"];
        //imageView.layer.borderWidth=5;
        imageView.layer.shadowColor= [UIColor blackColor].CGColor;
        imageView.layer.shadowOpacity=20;
        imageView.layer.shadowOffset = CGSizeMake(0, 3);
        imageView.layer.borderColor=[[UIColor whiteColor] CGColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }
    //    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    [imageView setImageWithURL:urlPic refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    return imageView;
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"-----%d",sender.view.tag);
    NSString *string_userId;
    if (mark==0) {
        
        NSDictionary* userdict=[self.creatUser objectAtIndex:sender.view.tag-1000];
        string_userId=[userdict objectForKey:@"USER_ID"];
    }
    if (mark==1) {
        NSDictionary* userdict=[self.joinUser objectAtIndex:sender.view.tag-1000];
        string_userId =[userdict objectForKey:@"USER_ID"];
    }
    friendsViewController=[[friendinfoViewController alloc] init];
    friendsViewController.user_id=string_userId;
    NSLog(@"wqqqqqqqqqqqqqqqqq%@",friendsViewController.user_id);
    [self.navigationController pushViewController:friendsViewController animated:YES];
    
}

//================================设置隐藏tableBar====================================
-(void)JumpCollection
{
    if ([[party objectForKey:@"P_TYPE"]intValue]==3) {
        addrdetail=[[AddrDetailViewController alloc]init];
        addrdetail.C_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:addrdetail animated:YES];
    }

    if ([[party objectForKey:@"P_TYPE"]intValue]==2)
    {
        acdetail=[[DetailViewController alloc]init];
        acdetail.C_id=[party objectForKey:@"C_ID"];
        [self.navigationController pushViewController:acdetail animated:YES];
    }
}
-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}

@end
