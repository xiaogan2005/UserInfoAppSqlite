//
//  LoginViewController.m
//  UserInfoProjectPractise
//
//  Created by GuoRui on 10/21/15.
//  Copyright © 2015 GuoRui. All rights reserved.
//

#import "LoginViewController.h"

#import "ValidateHelper.h"
#import "DBHelper.h"
#import "WelcomeViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_email;

- (IBAction)click_bt_login:(id)sender;


@property  UserInfo *userInfo;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tf_email.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark check input format

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






- (IBAction)click_bt_login:(id)sender {
    if(![ValidateHelper validateEmail:self.tf_email.text]){
        //email not valid
        [ValidateHelper emailAlert:self];
    }
    else{
        NSString *temp=[DBHelper selectEmailFromDB:self.tf_email.text];
        NSString *email=temp;
        if(email.length==0){
            [ValidateHelper alertWithTitle:self title:@"user not exist"  message:@"user not exist" ];
        }else{
        //jump  to detail
            _userInfo=[DBHelper selectAllFromDBwithEmail:self.tf_email.text];
            NSLog(@"this is in page %@",_userInfo.email);
        }
    }
    
}

#pragma mark segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //wrong page
    
    if([[segue identifier] isEqualToString:@"gotoWelcomePage"]){
        WelcomeViewController *viewController=[segue destinationViewController];
        
        NSLog(@"going to welcome");
        NSLog(@"%@",[_userInfo email]);
        viewController.userInfo=_userInfo;
        
        
        
    }
    
}
#pragma mark textfield delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//dismiss keyboard when done edditing text field
    NSLog(@"shouldreturn");
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];//dismiss keyboard when done edditing text field
    NSLog(@"shouldend");
    return YES;
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch begin");
    [self.tf_email resignFirstResponder];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // have to remove , cause it automatically called [textField becomeFirstResponder];
    return YES;
}


@end
