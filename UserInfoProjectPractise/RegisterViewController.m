//
//  RegisterViewController.m
//  UserInfoProjectPractise
//
//  Created by GuoRui on 10/21/15.
//  Copyright © 2015 GuoRui. All rights reserved.
//

#import "RegisterViewController.h"
#import "ValidateHelper.h"
#import "DBHelper.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_firstName;
@property (weak, nonatomic) IBOutlet UITextField *tf_lastName;
@property (weak, nonatomic) IBOutlet UITextField *tf_email;

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
- (IBAction)click_bt_register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)click_bt_register:(id)sender {
    if(![ValidateHelper validateEmail:self.tf_email.text]){
        //email not valid
        [ValidateHelper emailAlert:self];
    }else if(![ValidateHelper checkPhoneNumer:self.tf_phoneNumber.text]){
        //email not valid
        [ValidateHelper phoneNumberAlert:self];
    }else if(self.tf_firstName.text.length==0||self.tf_lastName.text.length==0||self.tf_address.text.length==0){
        NSString *title=@"";
        if(self.tf_firstName.text.length==0){
        title=@"firstName";
        }else if(self.tf_lastName.text.length==0){
        title=@"lastName";
        }else{
        title=@"address";
        }
        
        [ValidateHelper alertWithTitle:self title:[NSString  stringWithFormat:@" %@field is empty",title] message:[NSString  stringWithFormat:@"please enter %@",title]];
    }else{
        //check if exsit in db
        NSString *email=[DBHelper  selectEmailFromDB:self.tf_email.text];
        
        if(email.length>0){
            //email already exist in db
            [ValidateHelper alertWithTitle:self title:@"email already used" message:@"please use different email"];
        }else{
            //email not exist
            //save to db
            UserInfo *obj=[[UserInfo alloc]initWithParameters:_tf_firstName.text lastName:_tf_lastName.text email:_tf_email.text phoneNumber:_tf_phoneNumber.text address:_tf_address.text];
            NSLog(@"%@",[obj description]);
            [DBHelper saveToDB:obj];
        }
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
