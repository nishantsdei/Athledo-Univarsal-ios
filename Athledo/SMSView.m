//
//  SMSView.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "SMSView.h"
#import "SWRevealViewController.h"
#import "MessageInboxCell.h"
#import "SMSCustomCell.h"

@interface SMSView ()
{
    NSArray *arrGroupsListData;
    NSArray *arrMemberListData;
    NSArray *arrHistoryListData;
    
    UIToolbar *toolBar;
    NSMutableDictionary *DicCellCheckBoxState;
    int keyboardHeight;
    
    UIButton *btnAllcheck;
    BOOL ShowOnceSuccessAlert;
    
    id currentTextview;
    
}

@end

@implementation SMSView
@synthesize arrFilterdData;
#pragma mark UIViewController life cyle
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _ObjSegment.selectedSegmentIndex = 0;
    
    if (arrFilterdData.count > 0) {
        [btnAllcheck setSelected:NO];
        [arrFilterdData removeAllObjects];
        [self FilterData:arrMemberListData];
        [_tableview reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSMSListData];
    _ObjSegment.selectedSegmentIndex = 0;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        keyboardHeight = kbSize.height;
        if ([currentTextview  isKindOfClass:[UITextView class]]) {
            
            if (iosVersion < 8) {
                // [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
                keyboardHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                //[SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
                keyboardHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
            
        }
        
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([currentTextview  isKindOfClass:[UITextView class]]) {
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(keyboardHeight+22)) :toolBar];
        }
    }];
    _textview.font = Textfont;
    DicCellCheckBoxState = [[NSMutableDictionary alloc] init];
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    self.title = @"Send sms";
    
    //NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithObjects:@[[@"Dinesh",@"Kumar",@"9718937613",@"26",@"Mohali",@"2006",[[arr objectAtIndex:i] valueForKey:@"email"],[[arr objectAtIndex:i] valueForKey:@"school"],[[arr objectAtIndex:i] valueForKey:@"zip"],[NSNumber numberWithBool:NO]] forKeys:@[@"firstname",@"lastname",@"cellphone",@"age",@"city",@"class_year",@"email",@"school",@"zip",@"isCheck"]];
    
    //arrMemberListData = [[NSArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjects:@[@"Dinesh",@"9718937613",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"phone",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"Nishant",@"9718937613",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"phone",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"Varsha",@"9718937613",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"phone",@"isCheck"]], nil];
    
    // arrGroupsListData = [[NSArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjects:@[@"1st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"group",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"2st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"group",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"3st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"group",@"isCheck"]], nil];
    
    // arrHistoryListData = [[NSArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjects:@[@"1st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"2st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"isCheck"]],[NSMutableDictionary dictionaryWithObjects:@[@"3st Varsity",[NSNumber numberWithBool:NO]] forKeys:@[@"name",@"isCheck"]], nil];
    
    arrFilterdData = [[NSMutableArray alloc] init];
    // [arrFilterdData addObjectsFromArray:arrMemberListData];
    _textview.layer.borderWidth = .5;
    _textview.layer.cornerRadius = 9;
    _textview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    [SingletonClass ShareInstance].delegate = self;
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [self.view addSubview:toolBar];
    
    btnAllcheck = (UIButton *)[self.view viewWithTag:AllSelectedTag];
    
    [btnAllcheck setBackgroundImage:UncheckImage forState:UIControlStateNormal];
    [btnAllcheck setBackgroundImage:CheckImage forState:UIControlStateSelected];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CellDelegate
-(void)CheckBoxEvent:(id)sender
{
    CheckboxButton *button=(CheckboxButton*)sender;
    
    if ([[button backgroundImageForState:UIControlStateNormal] isEqual:CheckImage]) {
        [button setBackgroundImage:UncheckImage forState:UIControlStateNormal];
        [[arrFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
    }else
    {
        [button setBackgroundImage:CheckImage forState:UIControlStateNormal];
        [[arrFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
    }
    
    int AllStatusCount = 0;
    for (int i=0; i<arrFilterdData.count; i++) {
        
        if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue]) {
            AllStatusCount = AllStatusCount + 1;
        }
    }
    if (AllStatusCount == arrFilterdData.count) {
        [btnAllcheck setSelected:YES];
    }else
    {
        [btnAllcheck setSelected:NO];
    }
    
}

#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFilterdData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMScustomCell";
    static NSString *CellNib = @"SMSCustomCell";
    SMSCustomCell *cell = (SMSCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSCustomCell *)[nib objectAtIndex:0];
    }
    @try {
        
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            cell.lblName.hidden = NO;
            cell.lblPhoneNumber.hidden = NO;
            cell.btnSelectContact.hidden = NO;
            btnAllcheck.hidden = NO;
            _lblSelectAll.hidden = NO;
            
            cell.lblName.text=[[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"firstname"] stringByAppendingFormat:@" %@", [[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
            cell.lblName.textColor = [UIColor darkGrayColor];
            cell.lblName.font = Textfont;
            cell.lblPhoneNumber.text = [[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"cellphone"];
            cell.lblPhoneNumber.textColor = [UIColor lightGrayColor];
            cell.lblPhoneNumber.font = Textfont;
            CheckboxButton *cellCheckBox = (CheckboxButton *)cell.btnSelectContact;
            
            BOOL checkBoxState = [[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue];
            if (checkBoxState == YES) {
                [cellCheckBox setBackgroundImage:CheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = YES;
            }else
            {
                [cellCheckBox setBackgroundImage:UncheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = NO;
            }
            
        }else if (_ObjSegment.selectedSegmentIndex ==1)
        {
            cell.lblName.text=[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.lblName.textColor = [UIColor darkGrayColor];
            cell.lblName.font = Textfont;
            cell.lblName.hidden = NO;
            cell.lblPhoneNumber.hidden = YES;
            cell.btnSelectContact.hidden = NO;
            btnAllcheck.hidden = NO;
            _lblSelectAll.hidden = NO;
            CheckboxButton *cellCheckBox = (CheckboxButton *)cell.btnSelectContact;
            BOOL checkBoxState = [[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue];
            if (checkBoxState == YES) {
                [cellCheckBox setBackgroundImage:CheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = YES;
            }else
            {
                [cellCheckBox setBackgroundImage:UncheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = NO;
            }
        }else if (_ObjSegment.selectedSegmentIndex ==2)
        {
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    cell.cellDelegate=self;
    cell.btnSelectContact.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD) {
        return 70;
    }else
    {
        return 50;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ObjSegment.selectedSegmentIndex == 0) {
        AthleteDetail *athleteDetails = [[AthleteDetail alloc] initWithNibName:@"AthleteDetail" bundle:nil];
        athleteDetails.objAthleteDetails = [arrFilterdData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:athleteDetails animated:YES];
    }
}

#pragma mark SearchBar Delegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    currentTextview = searchBar;
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [arrFilterdData removeAllObjects];
    [self ValueChange:_ObjSegment];
    [_tableview reloadData];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        if (arrFilterdData.count == 0) {
            [SingletonClass initWithTitle:@"" message:@"No Notes" delegate:nil btn1:@"Ok"];
        }
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                //Check for empty Text box
                NSString *strError = @"";
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    [arrFilterdData removeAllObjects];
                    [self PrepareSearchPredicate:theSearchBar.text];
                    [_tableview reloadData];
                    [theSearchBar endEditing:YES];
                }
            }else{
                [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
#pragma mark UITextview Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.39f
                     animations:^{
                         [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(keyboardHeight+22)) :toolBar];
                     }
                     completion:^(BOOL finished){
                     }];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentTextview = textView;
    if ([_textview.text isEqualToString:@"Compose New Sms"]) {
        _textview.text = @"";
    }
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textview.text.length == 0) {
        _textview.text = @"Compose New Sms";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 140) {
        [SingletonClass initWithTitle:@"" message:@"The message body exceeds the 160 character limit" delegate:nil btn1:@"Ok"];
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark UISegmentControl Delegate
- (IBAction)ValueChange:(id)sender {
    
    UISegmentedControl *objSegment=(UISegmentedControl *)sender;
    if (objSegment.selectedSegmentIndex==0) {
        [arrFilterdData removeAllObjects];
        [self FilterData:arrMemberListData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [btnAllcheck setSelected:NO];
        [_tableview reloadData];
    }else if (objSegment.selectedSegmentIndex==1) {
        [arrFilterdData removeAllObjects];
        [self FilterData:arrGroupsListData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [btnAllcheck setSelected:NO];
        [_tableview reloadData];
    }else if (objSegment.selectedSegmentIndex==2) {
        History *history = [[History alloc] initWithNibName:@"History" bundle:nil];
        [self.navigationController pushViewController:history animated:YES];
    }
}
#pragma mark UIToolBar Delegate
-(void)Done
{
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(keyboardHeight+22)) :toolBar];
    [self.view endEditing:YES];
}
#pragma mark WebService Comunication Method
-(void)getSMSListData{
    
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceSendSms :strURL :GetSmsData];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    switch (Tag)
    {
        case GetSmsData :
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                arrMemberListData = [MyResults valueForKey:@"userData"];
                arrGroupsListData = [MyResults valueForKey:@"groupData"];
                [self FilterData:arrMemberListData];
                [_tableview reloadData];
                
            }else{
                [SingletonClass initWithTitle:@"" message:@"No records found" delegate:nil btn1:@"Ok"];
            }
            break;
        }
    }
}

#pragma mark Class Utility
-(void)PrepareSearchPredicate:(NSString *)theSearchBarText
{
    if (_ObjSegment.selectedSegmentIndex == 0) {
        NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                 [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                    [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        NSPredicate *lastNameLowerCase= [NSPredicate predicateWithFormat:
                                         [@"SELF['lastname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *lastNameOrginaltext = [NSPredicate predicateWithFormat:
                                            [@"SELF['lastname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        NSPredicate *phone= [NSPredicate predicateWithFormat:
                             [@"SELF['cellphone'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        //NSArray *res = [arrMemberListData  valueForKey:@"UserProfile"];
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lowerCase]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:orginaltext]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lastNameLowerCase]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lastNameOrginaltext]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:phone]] ;
        
        for (int i=0; i< arrFilterdData.count; i++) {
            
            [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
        
    }else if (_ObjSegment.selectedSegmentIndex == 1) {
        NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                 [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                    [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        
        //NSArray *res = [arrMemberListData  valueForKey:@"UserProfile"];
        [arrFilterdData addObjectsFromArray:[arrGroupsListData filteredArrayUsingPredicate:lowerCase]] ;
        [arrFilterdData addObjectsFromArray:[arrGroupsListData filteredArrayUsingPredicate:orginaltext]] ;
        for (int i=0; i< arrFilterdData.count; i++) {
            
            [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
    }
}
-(void)FilterData:(id)data
{
    @try {
        NSArray *arr = (NSArray *)data;
        if (_ObjSegment.selectedSegmentIndex == 0) {
            for (int i=0; i< arr.count; i++) {
                NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithObjects:@[[[arr objectAtIndex:i] valueForKey:@"firstname"],[[arr objectAtIndex:i] valueForKey:@"lastname"],[[arr objectAtIndex:i] valueForKey:@"cellphone"],[[arr objectAtIndex:i] valueForKey:@"age"],[[arr objectAtIndex:i] valueForKey:@"city"],[[arr objectAtIndex:i] valueForKey:@"class_year"],[[arr objectAtIndex:i] valueForKey:@"email"],[[arr objectAtIndex:i] valueForKey:@"school"],[[arr objectAtIndex:i] valueForKey:@"zip"],[[arr objectAtIndex:i] valueForKey:@"country"],[[arr objectAtIndex:i] valueForKey:@"address"],[[arr objectAtIndex:i] valueForKey:@"image"],[[arr objectAtIndex:i] valueForKey:@"class_year"],[[arr objectAtIndex:i] valueForKey:@"state"],[NSNumber numberWithBool:NO]] forKeys:@[@"firstname",@"lastname",@"cellphone",@"age",@"city",@"class_year",@"email",@"school",@"zip",@"country",@"address",@"image",@"class_year",@"state",@"isCheck"]];
                [arrFilterdData addObject:dicTemp];
                dicTemp = nil;
            }
        }else if (_ObjSegment.selectedSegmentIndex == 1) {
            
            [arrFilterdData addObjectsFromArray:arr];
            for (int i=0; i< arrFilterdData.count; i++) {
                
                [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
            }
            //            for (int i=0; i< arr.count; i++) {
            //                NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithObjects:@[[arr objectAtIndex:i] ,[NSNumber numberWithBool:NO]] forKeys:@[@"group",@"isCheck"]];
            //                [arrFilterdData addObject:dicTemp];
            //                dicTemp = nil;
            //            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
- (IBAction)selectAllCheckBox:(id)sender {
    CheckboxButton *button=(CheckboxButton*)sender;
    if (button.isSelected) {
        [button setSelected:NO];
        for (int i=0; i<arrFilterdData.count; i++) {
            [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
    }else
    {
        [button setSelected:YES];
        for (int i=0; i<arrFilterdData.count; i++) {
            [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
        }
    }
    [_tableview reloadData];
}
-(void)SendSMS:(id)sender
{
    ShowOnceSuccessAlert = TRUE;
    BOOL selectedNumber = NO;
    NSString *strError = @"";
    if(_textview.text.length < 1 || [_textview.text isEqualToString:@"Compose New Sms"] )
    {
        strError = @"Please enter sms text";
    }else if(selectedNumber == NO )
    {
        for (int i=0; i<arrFilterdData.count ; i++) {
            
            if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                selectedNumber = YES;
                break;
            }
        }
        if (selectedNumber == NO) {
            strError = @"Please select receiver";
        }
        
    }
    if(strError.length>2)
    {
        [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
        return;
    }
    
    for (int i=0; i<arrFilterdData.count ; i++ ) {
        
        if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
            
            if (_ObjSegment.selectedSegmentIndex == 0) {
                NSString *phoneNumber = [[arrFilterdData objectAtIndex:i]valueForKey:@"cellphone"] ? [[arrFilterdData objectAtIndex:i]valueForKey:@"cellphone"] :@"" ;
                if([phoneNumber isEqualToString:@""])
                    continue;
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json", accountSID]]];
                [request setUsername:accountSID];
                [request setPassword:authToken];
                [request addPostValue:FromPhoneNumber forKey:@"From"];
                [request addPostValue:phoneNumber forKey:@"To"];
                [request addPostValue:_textview.text forKey:@"Body"];
                [request setDelegate:self];
                [request setDidStartSelector:@selector(requestStarted:)];
                [request setDidFinishSelector:@selector(requestFinished:)];
                [request setDidFailSelector:@selector(requestFailed:)];
                [request setUploadProgressDelegate:self];
                [request setTimeOutSeconds:50000];
                [request startAsynchronous];
                
            }else  if (_ObjSegment.selectedSegmentIndex == 1) {
                
                NSDictionary *phoneDic = [[arrFilterdData objectAtIndex:i]valueForKey:@"memberPhone"];
                NSArray *arrTemp = [phoneDic allValues];
                
                for (int i=0 ; i < arrTemp.count; i++) {
                    
                    NSString *phoneNumber = [arrTemp objectAtIndex:i] ? [arrTemp objectAtIndex:i] :@"" ;
                    if([phoneNumber isEqualToString:@""])
                        continue;
                    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json", accountSID]]];
                    [request setUsername:accountSID];
                    [request setPassword:authToken];
                    [request addPostValue:FromPhoneNumber forKey:@"From"];
                    [request addPostValue:phoneNumber forKey:@"To"];
                    [request addPostValue:_textview.text forKey:@"Body"];
                    [request setDelegate:self];
                    [request setDidStartSelector:@selector(requestStarted:)];
                    [request setDidFinishSelector:@selector(requestFinished:)];
                    [request setDidFailSelector:@selector(requestFailed:)];
                    [request setUploadProgressDelegate:self];
                    [request setTimeOutSeconds:50000];
                    [request startAsynchronous];
                }
            }
        }
    }
}
#pragma mark- ASIHTTPRequest class delegate
- (void)requestStarted:(ASIHTTPRequest *)theRequest {
}
- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    @try {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseDict = [parser objectWithString:[theRequest responseString ]];
        if ([[responseDict valueForKey:@"status"] isEqualToString:@"queued"] && ShowOnceSuccessAlert==TRUE ) {
            ShowOnceSuccessAlert=FALSE;
            [SingletonClass initWithTitle:@"" message:@"SMS has been send successfully" delegate:nil btn1:@"Ok"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)theRequest {
    
}
@end