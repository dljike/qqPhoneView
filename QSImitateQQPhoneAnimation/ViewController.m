//
//  ViewController.m
//  QSImitateQQPhoneAnimation
//
//  Created by JosQiao on 16/5/19.
//  Copyright © 2016年 QiaoShi. All rights reserved.
//

#import "ViewController.h"
#import "QQPhoneViewController.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 表格 */
@property(nonatomic,strong)UITableView *tableView;

/** 数据 */
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - TableViewDelegate/TableViewDataSource

#pragma mark - UITableViewDataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return  cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            QQPhoneViewController *qqPhoneVC = [[QQPhoneViewController alloc] init];
            [self.navigationController pushViewController:qqPhoneVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Getter
- (UITableView *)tableView
{
    
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.frame = self.view.bounds;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        [_dataArray addObject:@"仿QQ电话转场"];
    }
    return _dataArray;
}

@end
