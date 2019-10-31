//
//  UserInfoController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/8/15.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "UserInfoController.h"
#import "ChangeDataViewController.h"
#import "ChangeAvaterView.h"
#import "UserInfoManager.h"
#import "RegionTool.h"
#import "Region.h"
#import "KSKuaiShouTool.h"
#import "PersonCell.h"
#import "ModifyPasswordController.h"
#import "SDImageCache.h"
//#import <SDWebImage/SDWebImage.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfoSetting.h"

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserInfoController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)ChangeAvaterView * changeView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *userInfoSource;


@end

@implementation UserInfoController
{
    UIImage * _avaterImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
//    [self setSaveBtn];
    [self createTableView];
    
    self.title = NSLocalizedStringFromTable(@"Set the user information", @"InfoPlist", nil);
}

- (void)setData {

    _dataSource = @[@[NSLocalizedStringFromTable(@"Avatar", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Nickname", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Sex", @"InfoPlist", nil)],
                    @[NSLocalizedStringFromTable(@"Email", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Country", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Address", @"InfoPlist", nil)],
                    @[NSLocalizedStringFromTable(@"Change the password", @"InfoPlist", nil),NSLocalizedStringFromTable(@"Sign out", @"InfoPlist", nil)]];
    NSString *country = [[NSString alloc] init];
    NSString *parent = [[NSString alloc] init];
    NSArray *array = [[RegionTool manager] getRegionWithParent:_userInfo.region_parent];
    for (Region *region in array) {
        if (region.region_id == _userInfo.region_id) {
            country = region.country;
        }
    }
    array = [[RegionTool manager] getParent];
    for (Region *region in array) {
        if (region.region_id == _userInfo.region_parent) {
            parent = region.country;
        }
    }
    
    NSString *nationality = [NSString stringWithFormat:@"%@-%@",parent,country];
    if (_userInfo.region_id == 4) {  // 国籍为空
        nationality = @"";
    }
    
    NSString *sex = [[NSString alloc] init];
    if (_userInfo.sex == 1) { // 男
        sex = NSLocalizedStringFromTable(@"Man", @"InfoPlist", nil);
    } else if(_userInfo.sex == 2) {
        sex = NSLocalizedStringFromTable(@"Lady", @"InfoPlist", nil);
    }
    _userInfoSource = @[@[@"",_userInfo.nick_name,sex],
                        @[_userInfo.email,nationality,_userInfo.address],
                        @[@"",@""]];
    
}



#pragma mark - Table view  delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    NSArray * rowArr = _dataSource[section];
    return rowArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        PersonCell * cell = [[PersonCell alloc]init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    static NSString * identifier = @"PersonCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    

    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//养成习惯在WillDisplayCell中处理数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        PersonCell *personCell = (PersonCell *)cell;
        [personCell.avatarView sd_setImageWithURL:[NSURL URLWithString:[[UserInfoManager manager] avatarUrl]] placeholderImage:[UIImage imageNamed:@"img_default"]];

    }
    
    cell.detailTextLabel.text = _userInfoSource[indexPath.section][indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        //修改头像
        if (indexPath.row == 0)
        {
            [self createChangeView];
        }
        //修改用户名
        else if(indexPath.row == 1)
        {
            ChangeDataViewController *vc = [[ChangeDataViewController alloc]initWithType:ChangeNickName];
            vc.nick_name = _userInfo.nick_name;
            vc.nick_nameBlock = ^(NSString *nick_name) {
                self.userInfo.nick_name = nick_name;
                [self setData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        // 性别
        else if(indexPath.row == 2)
        {
            ChangeDataViewController *vc = [[ChangeDataViewController alloc]initWithType:ChangeSex];
            vc.sexBlock = ^(NSInteger sex){
                self.userInfo.sex = sex;
                [self setData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    }
    else if (indexPath.section == 1)
    {
        //邮箱
        if (indexPath.row == 0)
        {
            ChangeDataViewController *vc = [[ChangeDataViewController alloc]initWithType:ChangeEmail];
            vc.email = _userInfo.email;
            vc.emailBlock = ^(NSString *email) {
                self.userInfo.email = email;
                [self setData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        //国籍
        else if(indexPath.row == 1)
        {
            ChangeDataViewController *vc = [[ChangeDataViewController alloc]initWithType:ChangePath];
            vc.nick_name = _userInfo.nick_name;
            vc.nick_nameBlock = ^(NSString *nick_name) {
                self.userInfo.nick_name = nick_name;
                [self setData];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        //地址
        else if(indexPath.row == 2)
        {
            ChangeDataViewController *vc = [[ChangeDataViewController alloc]initWithType:ChangeAddress];
            vc.address = _userInfo.address;
            vc.addressBlock = ^(NSString *address) {
                self.userInfo.address = address;
                [self setData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) { // 修改密码
            ModifyPasswordController *vc = [[ModifyPasswordController alloc] init];
            vc.modifyBlock = ^(){
              
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) { // 退出登陆
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.f];
            [self cancelLogin];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- 退出登陆
- (void)cancelLogin{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];  // 我的关注刷新标志
    [defaults setBool:YES forKey:@"followView"];
    [defaults synchronize];
//    FBSDKLoginManager *login=[[FBSDKLoginManager alloc]init];
//    [login logOut];
    if (self.tokenBlock) {
        self.tokenBlock();
    }
}

#pragma mark -- 修改头像部分 --

- (void)createChangeView
{
    if (!_changeView)
    {
        NSLog(@"bounds=%f",self.navigationController.view.bounds.size.height);
        _changeView = [[ChangeAvaterView alloc]initWithFrame:self.navigationController.view.bounds andBtnArr:@[
                                                                                                               NSLocalizedStringFromTable(@"Camera", @"InfoPlist", nil),
                                                                                                               NSLocalizedStringFromTable(@"Photos", @"InfoPlist", nil),]];

        UIButton * cameraBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 0];
        UIButton * photoBtn = (UIButton *)[_changeView viewWithTag:_changeView.thisTag + 1];
        [cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [photoBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
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
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.label.text = @"正在上传头像";
            [KSKuaiShouTool updataAvatarWithImg:smallImage withCompleted:^(id result) {
                _avaterView.image = smallImage;
                // 将图片保存到缓存中
//                [[UserInfoManager manager]saveImgDataWithImg:smallImage];
                // 更改图片时清除本机缓存
                [[SDImageCache sharedImageCache] removeImageForKey:[[UserInfoManager manager] avatarUrl]];
                [self.tableView reloadData];
//                [hud hideAnimated:YES];
            } failure:^(NSError *error) {
//                [hud hideAnimated:YES];
            }];
            
            
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
        _avaterView = [[UIImageView alloc]initWithFrame:CGRectMake(0, WGiveHeight(100), self.view.frame.size.width, self.view.frame.size.width)];
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


#pragma mark - 字段持久缓存(保存在数据库)
- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *)getValueWithKey:(NSString *)key {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:key];//根据键值取出name
    return token;
}


- (UITableView *)createTableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSceenWidth, kSceenHeight-64) style:UITableViewStyleGrouped];
        //        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger region_id = [[NSUserDefaults standardUserDefaults]integerForKey:@"region_id"];
    if (region_id != 0) {
        _userInfo.region_id = region_id;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"region_id"];
    }
    
    NSInteger region_parent = [[NSUserDefaults standardUserDefaults]integerForKey:@"region_parent"];
    if (region_parent != 0) {
        _userInfo.region_parent = region_parent;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"region_parent"];
    }

    [self setData];
    
    [self.tableView reloadData];
}

@end
