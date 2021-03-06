//
//  ChangeDataViewController.m
//  WWeChat
//
//  Created by wordoor－z on 16/2/15.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "ChangeDataViewController.h"
#import "ChangeAvaterView.h"
#import "CustomTextField.h"
#import "KSKuaiShouTool.h"
#import "UserInfoManager.h"
#import "RegionTool.h"
#import "Region.h"
#import "KSRegionViewController.h"
//#import "UserInfoManager.h"
//#import "WWeChatApi.h"

@interface ChangeDataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)ChangeAvaterView * changeView;

@property(nonatomic,strong)CustomTextField * nickNameField;

@property(nonatomic,strong)CustomTextField * emailField;

@property(nonatomic,strong)CustomTextField * addressField;


@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, strong) NSArray *dataSource;


@end

@implementation ChangeDataViewController
{
    ChangeType _type;
}
- (instancetype)initWithType:(ChangeType)type
{
    if (self = [super init])
    {
        _type = type;
        
        self.view.userInteractionEnabled = YES;
        
        self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [self setUpNavigationTitleCenter]; // 设置返回按钮不显示文字
        switch (type)
        {
            //更改头像
            case ChangeAvater:
            {
                
                self.title = NSLocalizedStringFromTable(@"Avatar", @"InfoPlist", nil);
                self.view.backgroundColor = [UIColor blackColor];
                
                [self addRightBtnWithImgName:@"ChangeData_more" andSelector:@selector(createChangeView)];
            }
                break;
    
                
            //更改昵称
            case ChangeNickName:
            {
                self.title = NSLocalizedStringFromTable(@"Nickname", @"InfoPlist", nil);

                UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                [saveBtn addTarget:self action:@selector(changeNickRightClick:) forControlEvents:UIControlEventTouchUpInside];
                //    [someButton setShowsTouchWhenHighlighted:YES];
                UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
                self.navigationItem.rightBarButtonItem = mailbutton;
                
                [self createChangeNickNameUI];
            }
                break;
                
            //更改地址
            case ChangeAddress:
            {
                self.title = NSLocalizedStringFromTable(@"Address", @"InfoPlist", nil);

                UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                [saveBtn addTarget:self action:@selector(changeAddressRightClick:) forControlEvents:UIControlEventTouchUpInside];
                //    [someButton setShowsTouchWhenHighlighted:YES];
                UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
                self.navigationItem.rightBarButtonItem = mailbutton;
                
                [self createChangeAddressUI];
            }
                break;
             
            //更改性别
            case ChangeSex:
            {
                self.title = NSLocalizedStringFromTable(@"Sex", @"InfoPlist", nil);
                _dataSource = @[NSLocalizedStringFromTable(@"Man", @"InfoPlist", nil), NSLocalizedStringFromTable(@"Lady", @"InfoPlist", nil)];
                [self createTableView];
            }
                break;
             
            //更改国籍
            case ChangePath:
            {
                self.title = NSLocalizedStringFromTable(@"Country", @"InfoPlist", nil);
                _dataSource = [[RegionTool manager] getParent];
                [self createTableView];
            }
                break;
            
            //更改邮箱
            case ChangeEmail:
            {
                self.title = NSLocalizedStringFromTable(@"Email", @"InfoPlist", nil);
                
                UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [saveBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                [saveBtn addTarget:self action:@selector(changeEmailRightClick:) forControlEvents:UIControlEventTouchUpInside];
                //    [someButton setShowsTouchWhenHighlighted:YES];
                UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
                self.navigationItem.rightBarButtonItem = mailbutton;
                
                [self createChangeEmailUI];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

// 设置导航条头居中，返回按钮中的文字不显示
- (void)setUpNavigationTitleCenter
{
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }
}


//取消按钮
- (void)leftNavCancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 个性签名部分 --

#pragma mark -- 修改性别部分 --
- (UITableView *)createTableView
{
    if (!_tableView)
    {
        _tableView = ({
            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
            
            tableView.showsVerticalScrollIndicator = NO;
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            [self.view addSubview:tableView];
            
            tableView;
        });
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WGiveHeight(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WGiveHeight(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString * identifier = @"ChangeSexCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    if (_dataSource.count == 2) { // 性别
        cell.textLabel.text = _dataSource[indexPath.row];
    } else { // 国籍
        Region *region = _dataSource[indexPath.row];
        cell.textLabel.text = region.country;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (_dataSource.count == 2) {
        NSString *sex = [[NSString alloc] init];
        if (indexPath.row == 0) {
            sex = @"1";
        } else if (indexPath.row == 1) {
            sex = @"2";
        }
        [KSKuaiShouTool userInfoWithParam:@{@"sex":sex} withCompleted:^(id result) {
            NSLog(@"ret_code=%@",[result objectForKey:@"ret_code"]);
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (self.sexBlock) {
                    self.sexBlock(indexPath.row+1);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.f];
            hud.label.numberOfLines = 3;
            hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        }];
        
    } else {
        Region *region = _dataSource[indexPath.row];
        KSRegionViewController *regionVC = [[KSRegionViewController alloc] init];
        regionVC.regionID = region.region_id;
        [self.navigationController pushViewController:regionVC animated:YES];
    }
    
//    [[WWeChatApi giveMeApi]updataSexWithIsMan:indexPath.row == 0?YES:NO andSuccess:^(id response) {
    
//        [hub hideAnimated:YES];
//        [self.tableView reloadData];
//        
//    } andFailure:^(NSError *error) {
//        
//    }];
}

#pragma mark -- 修改昵称部分 --

- (void)createChangeNickNameUI
{
    self.nickNameField.text = _nick_name;
}

- (void)changeNickRightClick:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.f];
    hud.label.numberOfLines = 3;

//    [[WWeChatApi giveMeApi]updataUserNameWithName:_nickNameField.text andSuccess:^(id response) {
//        [hud hideAnimated:YES];
    if (_nickNameField.text.length < 3) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 6", @"InfoPlist", nil);
    } else {
        [KSKuaiShouTool userInfoWithParam:@{@"nick_name":_nickNameField.text} withCompleted:^(id result) {
            NSLog(@"ret_code=%@",[result objectForKey:@"ret_code"]);
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (self.nick_nameBlock) {
                    self.nick_nameBlock(_nickNameField.text);
                }
                [hud hideAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
            }
            
        } failure:^(NSError *error) {
            hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        }];
       
    }
//    } andFailure:^(NSError *error) {
//        
//    }];
}

- (UITextField *)nickNameField
{
    if (!_nickNameField)
    {
        _nickNameField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, WGiveHeight(15+64), self.view.frame.size.width, WGiveHeight(45))];
        _nickNameField.backgroundColor = [UIColor whiteColor];
        _nickNameField.clearButtonMode = UITextFieldViewModeAlways;
        [_nickNameField becomeFirstResponder];
        [_nickNameField addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_nickNameField];
    }
    return _nickNameField;
}

- (void)changeFieldText:(UITextField *)sender
{
    NSLog(@"change");
//    if ([sender.text isEqualToString:[[UserInfoManager manager]userName]])
//    {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
//    else
//    {
//        if (sender.text.length > 0)
//        {
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//        }
//    }
}

#pragma mark -- 修改地址部分 --
- (void)createChangeAddressUI
{
    self.addressField.text = _address;
}

- (void)changeAddressRightClick:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.f];
    
    //    [[WWeChatApi giveMeApi]updataUserNameWithName:_nickNameField.text andSuccess:^(id response) {
    //        [hud hideAnimated:YES];
    if (_addressField.text.length < 2) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 3", @"InfoPlist", nil);
    } else {
        
        [KSKuaiShouTool userInfoWithParam:@{@"address":_addressField.text} withCompleted:^(id result) {
            NSLog(@"ret_code=%@",[result objectForKey:@"ret_code"]);
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (self.addressBlock) {
                    self.addressBlock(_addressField.text);
                }
                [hud hideAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
            }
            
        } failure:^(NSError *error) {
            hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        }];
        
        
    }
    //    } andFailure:^(NSError *error) {
    //
    //    }];
}

- (UITextField *)addressField
{
    if (!_addressField)
    {
        _addressField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, WGiveHeight(15+64), self.view.frame.size.width, WGiveHeight(45))];
        _addressField.backgroundColor = [UIColor whiteColor];
        _addressField.clearButtonMode = UITextFieldViewModeAlways;
        [_addressField becomeFirstResponder];
        [_addressField addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_addressField];
    }
    return _nickNameField;
}

#pragma mark -- 修改邮箱部分 --
- (void)createChangeEmailUI
{
    self.emailField.text = _email;
}

- (void)changeEmailRightClick:(UIButton *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.f];
    
    //    [[WWeChatApi giveMeApi]updataUserNameWithName:_nickNameField.text andSuccess:^(id response) {
    //        [hud hideAnimated:YES];
    if (_emailField.text.length < 3) {
        hud.label.text = NSLocalizedStringFromTable(@"Account number format error,the length can not less than 3", @"InfoPlist", nil);
    } else {
        [KSKuaiShouTool userInfoWithParam:@{@"email":_emailField.text} withCompleted:^(id result) {
            NSLog(@"ret_code=%@",[result objectForKey:@"ret_code"]);
            if ([[result objectForKey:@"ret_code"] intValue] == 0) {
                if (self.emailBlock) {
                    self.emailBlock(_emailField.text);
                }
                [hud hideAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
            }
            
        } failure:^(NSError *error) {
            hud.label.text = NSLocalizedStringFromTable(@"Network error, please try again later!", @"InfoPlist", nil);
        }];
        
        
    }
    //    } andFailure:^(NSError *error) {
    //
    //    }];
}

- (UITextField *)emailField
{
    if (!_emailField)
    {
        _emailField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, WGiveHeight(15+64), self.view.frame.size.width, WGiveHeight(45))];
        _emailField.backgroundColor = [UIColor whiteColor];
        _emailField.clearButtonMode = UITextFieldViewModeAlways;
        _emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [_emailField becomeFirstResponder];
        [_emailField addTarget:self action:@selector(changeFieldText:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_emailField];
    }
    return _emailField;
}

//- (void)changeFieldText:(UITextField *)sender
//{
//    NSLog(@"change");
//    //    if ([sender.text isEqualToString:[[UserInfoManager manager]userName]])
//    //    {
//    //        self.navigationItem.rightBarButtonItem.enabled = NO;
//    //    }
//    //    else
//    //    {
//    //        if (sender.text.length > 0)
//    //        {
//    //            self.navigationItem.rightBarButtonItem.enabled = YES;
//    //        }
//    //    }
//}

#pragma mark -- 修改头像部分 --

- (void)createChangeView
{
    if (!_changeView)
    {
        NSLog(@"bounds=%f",self.navigationController.view.bounds.size.height);
        _changeView = [[ChangeAvaterView alloc]initWithFrame:self.navigationController.view.bounds andBtnArr:@[
                                                                                          NSLocalizedStringFromTable(@"Camera", @"InfoPlist", nil),
                                                                                          NSLocalizedStringFromTable(@"Photos", @"InfoPlist", nil),
                                                                                          NSLocalizedStringFromTable(@"Save the picture", @"InfoPlist", nil)
                                                                                          ]];
        UIButton * cameraBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 0];
        UIButton * photoBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 1];
        UIButton * saveBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 2];
        [cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [photoBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_changeView];
    [_changeView show];
}

- (void)cameraBtnClick:(UIButton *)sender
{
    [_changeView hide];
    NSLog(@"拍照");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{

        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)photoClick:(UIButton *)sender
{
    [_changeView hide];
    NSLog(@"相册");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{

    }];
}

- (void)saveClick:(UIButton *)sender
{
  [_changeView hide];
  UIImageWriteToSavedPhotosAlbum(self.avaterView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeCustomView;
        
        UIImage * CheckImage = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        hud.customView = [[UIImageView alloc] initWithImage:CheckImage];
        
        hud.square = YES;
        hud.label.text = @"保存成功";
        
        [hud hideAnimated:YES afterDelay:1.f];
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
//        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * smallImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
//        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"正在上传头像";
            [KSKuaiShouTool updataAvatarWithImg:smallImage withCompleted:^(id result) {
                _avaterView.image = smallImage;
                // 将图片保存到缓存中
                [[UserInfoManager manager]saveImgDataWithImg:smallImage];

                [hud hideAnimated:YES];
            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
            }];
            
//            [[WWeChatApi giveMeApi]updataAvaterWithImg:smallImage andSuccess:^(id response) {
//                
//                _avaterView.image = smallImage;
//                
//                 [MBProgressHUD hideHUDForView:self.view animated:YES];
//                
//                [[UserInfoManager manager]saveImgDataWithImg:smallImage];
//
//            } andFailure:^(NSError *error) {
//
//                NSLog(@"error:%@",error.localizedDescription);
//                
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            }];

        }];

    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

- (UIImageView *)avaterView
{
    if (!_avaterView)
    {
        _avaterView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [self.view addSubview:_avaterView];
    }
    return _avaterView;
}

//压缩图片方法
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}

@end
