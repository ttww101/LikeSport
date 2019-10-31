
//
//  FindPasswordController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/23.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "ModifyPasswordController.h"
#import "KSHttpTool.h"
#import "KSConstant.h"
#import <CommonCrypto/CommonDigest.h>
#import "CustomTextField.h"

@interface ModifyPasswordController ()

@property (weak, nonatomic) UITextField *oldPasswordTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *passwordTextField2;
@property (weak, nonatomic) UIButton *saveBtn;

@end

@implementation ModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    
    [_oldPasswordTextField becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)buildUI {
//    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
//    //    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //    [bar setShadowImage:[UIImage new]];
//    [self.view addSubview:bar];
//    
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
////    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
//    [bar addSubview:backBtn];
//    //    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"InfoPlist", nil) forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    //    [someButton setShowsTouchWhenHighlighted:YES];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = mailbutton;
    
    
    
    UITextField *oldPasswordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 30, kSceenWidth - 20, 40)];
    oldPasswordTextField.placeholder = NSLocalizedStringFromTable(@"The original password", @"InfoPlist", nil);
    oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPasswordTextField.backgroundColor = [UIColor whiteColor];
    //    nameTextField.layer.cornerRadius = 5;
//    oldPasswordTextField.text = @"qq1234";
    oldPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [oldPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:oldPasswordTextField];
    _oldPasswordTextField = oldPasswordTextField;
    
    UITextField *newPasswordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 71, kSceenWidth - 20, 40)];
    newPasswordTextField.placeholder = NSLocalizedStringFromTable(@"The new password", @"InfoPlist", nil);
    newPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 密码不显示
//    newPasswordTextField.secureTextEntry = YES;
    newPasswordTextField.backgroundColor = [UIColor whiteColor];
    //    passwordTextField.layer.cornerRadius = 5;
//    newPasswordTextField.text = @"qq12345";
    newPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [newPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:newPasswordTextField];
    _passwordTextField = newPasswordTextField;
    
    UITextField *newPasswordTextField2 = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 112, kSceenWidth - 20, 40)];
    newPasswordTextField2.placeholder = NSLocalizedStringFromTable(@"Please enter the new password again", @"InfoPlist", nil);
    newPasswordTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 密码不显示
//    newPasswordTextField2.secureTextEntry = YES;
    newPasswordTextField2.backgroundColor = [UIColor whiteColor];
    //    passwordTextField2.layer.cornerRadius = 5;
//    newPasswordTextField2.text = @"qq12345";
    newPasswordTextField2.keyboardType = UIKeyboardTypeASCIICapable;
    [newPasswordTextField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:newPasswordTextField2];
    _passwordTextField2 = newPasswordTextField2;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(10, 180, kSceenWidth-20, 30);
    [saveBtn setTitle:NSLocalizedStringFromTable(@"Send", @"InfoPlist", nil) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.backgroundColor = KSBlue;
    [self.view addSubview:saveBtn];
    _saveBtn = saveBtn;
    
    //    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelBtn.frame = CGRectMake((kSceenWidth - 80)/4+kSceenWidth/2, 240, 40, 30);
    //    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:cancelBtn];
    //    _cancelBtn = cancelBtn;
    
}

- (void)modifyPassword {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:1] animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 3;

    [hud hideAnimated:YES afterDelay:1.f];
    if (_oldPasswordTextField.text.length < 6) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 6", @"InfoPlist", nil);
    } else if (_passwordTextField.text.length < 6 || _passwordTextField2.text.length < 6) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 6", @"InfoPlist", nil);
    } else if (![_passwordTextField.text isEqualToString:_passwordTextField2.text]){
        hud.label.text = NSLocalizedStringFromTable(@"Passwords don't match", @"InfoPlist", nil);
//        NSLog(@"密码1:%@ 2:%@",_passwordTextField.text,_passwordTextField2.text);
    } else if ([_oldPasswordTextField.text isEqualToString:_passwordTextField.text]) {
        hud.label.text = NSLocalizedStringFromTable(@"The new password cannot be the same as the original password", @"InfoPlist", nil);
    } else {
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/api/users/user_password_set?",appUrl];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        
        // sign 加密
        NSString *sign = [NSString stringWithFormat:@"http://app.likesport.com/api/users/user_password_setapp_id=106oldpassword=%@password=%@token=%@",_oldPasswordTextField.text,_passwordTextField.text,token];
//        NSLog(@"sing=%@",sign);
        const char *cStr = [sign UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, sign.length, digest );
        NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [result appendFormat:@"%02x", digest[i]];
        
        NSDictionary *dic = @{@"token":token,@"app_id":@106,@"oldpassword":_oldPasswordTextField.text,@"password":_passwordTextField.text,@"sign":result};

        
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"修改密码请求链接%@",url);
        [KSHttpTool GETWithSignURL:url params:dic success:^(id responseObject) {
            //            Login *last = [Login mj_objectWithKeyValues:responseObject];
            int ret_code = [[responseObject objectForKey:@"ret_code"] integerValue];
            if (ret_code == 0) {
                if (self.modifyBlock) {
                    self.modifyBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                hud.label.text = NSLocalizedStringFromTable(@"Modify the success", @"InfoPlist", nil);
            } else if (ret_code == 1002) {

                hud.label.text = NSLocalizedStringFromTable(@"Illegal operation, the user does not exist", @"InfoPlist", nil);
            } else if (ret_code == 1008) {
                hud.label.text = NSLocalizedStringFromTable(@"Password mistake,can not less than 6 in length", @"InfoPlist", nil);
            } else if (ret_code == 1001) {
                hud.label.text = NSLocalizedStringFromTable(@"The original password mistake", @"InfoPlist", nil);
            }  else {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark - 字段持久缓存(保存在数据库)
- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    //获得UIImage实例
    [defaults synchronize];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    
    if (textField == self.oldPasswordTextField) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:20];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedStringFromTable(@"Password mistake,length is not greater than 16", @"InfoPlist", nil);
            [hud hideAnimated:YES afterDelay:1.f];
        }
    }
    if (textField == self.passwordTextField || textField == self.passwordTextField2) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedStringFromTable(@"Password mistake,length is not greater than 16", @"InfoPlist", nil);
            [hud hideAnimated:YES afterDelay:1.f];
        }
    }
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

@end