//
//  UserInfoSetting.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "UserInfoSetting.h"
#import "CustomTextField.h"
#import "KSKuaiShouTool.h"

@interface UserInfoSetting()
@property (weak, nonatomic) UITextField *nameTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *passwordTextField2;
@property (weak, nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic) UIButton *registBtn;

@end

@implementation UserInfoSetting
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    
    [_nameTextField becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}


- (void)buildUI {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Set the user information", @"InfoPlist", nil)];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"InfoPlist", nil) forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [bar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:bar];
    
//    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, 64)];
//    [self.view addSubview:bar];
//    
//    //    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 40)];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    //    [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//    [backBtn setTitle:NSLocalizedStringFromTable(@"Back", @"InfoPlist", nil) forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    [bar addSubview:backBtn];
//    
//    //    [someButton setShowsTouchWhenHighlighted:YES];
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = mailbutton;
    
    
    UITextField *nameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 90, kSceenWidth - 20, 40)];
    nameTextField.placeholder = NSLocalizedStringFromTable(@"Please enter the account", @"InfoPlist", nil);
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.backgroundColor = [UIColor whiteColor];
    //    nameTextField.layer.cornerRadius = 5;
    nameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nameTextField];
    _nameTextField = nameTextField;
    
    UITextField *passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 131, kSceenWidth - 20, 40)];
    passwordTextField.placeholder = NSLocalizedStringFromTable(@"Please enter the password", @"InfoPlist", nil);
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 密码不显示
    passwordTextField.secureTextEntry = YES;
    passwordTextField.backgroundColor = [UIColor whiteColor];
    //    passwordTextField.layer.cornerRadius = 5;
    [passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTextField];
    _passwordTextField = passwordTextField;
    
    UITextField *passwordTextField2 = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 172, kSceenWidth - 20, 40)];
    passwordTextField2.placeholder = NSLocalizedStringFromTable(@"Please enter the password again", @"InfoPlist", nil);
    passwordTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 密码不显示
    passwordTextField2.secureTextEntry = YES;
    passwordTextField2.backgroundColor = [UIColor whiteColor];
    //    passwordTextField2.layer.cornerRadius = 5;
    [passwordTextField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTextField2];
    _passwordTextField2 = passwordTextField2;
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(10, 240, kSceenWidth-20, 30);
    [registBtn setTitle:NSLocalizedStringFromTable(@"Sign up", @"InfoPlist", nil) forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(register) forControlEvents:UIControlEventTouchUpInside];
    registBtn.layer.cornerRadius = 5;
    registBtn.backgroundColor = KSBlue;
    [self.view addSubview:registBtn];
    _registBtn = registBtn;
    
    //    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelBtn.frame = CGRectMake((kSceenWidth - 80)/4+kSceenWidth/2, 240, 40, 30);
    //    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:cancelBtn];
    //    _cancelBtn = cancelBtn;
    
}

- (void)register {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 3;
    [hud hideAnimated:YES afterDelay:1.f];
    if (_nameTextField.text.length < 6) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 6", @"InfoPlist", nil);
    } else if (_passwordTextField.text.length < 6 || _passwordTextField2.text.length < 6) {
        hud.label.text = NSLocalizedStringFromTable(@"Password mistake,can not less than 6 in length", @"InfoPlist", nil);
    } else if (![_passwordTextField.text isEqualToString:_passwordTextField2.text]){
        hud.label.text = NSLocalizedStringFromTable(@"Passwords don't match", @"InfoPlist", nil);
        //        NSLog(@"密码1:%@ 2:%@",_passwordTextField.text,_passwordTextField2.text);
    } else {
        [KSKuaiShouTool userRegisterWithName:_nameTextField.text andPassword:_passwordTextField.text WithCompleted:^(id result) {
//            Login *regist = [Login mj_objectWithKeyValues:result];
//            if (regist.ret_code == 0 && regist.result.token.length > 0) {
//                if (self.tokenBlock) {
//                    self.tokenBlock(regist.result.token,YES);
//                    //                    NSLog(@"密码1:%@ 2:%@",_passwordTextField.text,_passwordTextField2.text);
//                }
//                [self dismissViewControllerAnimated:YES completion:nil];
//            } else if (regist.ret_code == 1003) {
//                hud.label.text = NSLocalizedStringFromTable(@"Registered user name already exists", @"InfoPlist", nil);
//            }
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
    
    
    if (textField == self.nameTextField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.numberOfLines = 3;
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length is not greater than 20", @"InfoPlist", nil);
            [hud hideAnimated:YES afterDelay:1.f];
        }
    }
    if (textField == self.passwordTextField || textField == self.passwordTextField2) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.numberOfLines = 2;
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedStringFromTable(@"Password mistake,length is not greater than 16", @"InfoPlist", nil);
            [hud hideAnimated:YES afterDelay:1.f];
        }
    }
}
@end
