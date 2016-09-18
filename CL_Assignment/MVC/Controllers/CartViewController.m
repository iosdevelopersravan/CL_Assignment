//
//  CartViewController.m
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import "CartViewController.h"
#import "Constants.h"
#import "Cart.h"
#import "CartTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *cartArray;
@property(nonatomic,weak) IBOutlet UILabel *priceLabel;
@property(nonatomic,weak) IBOutlet UILabel *backgroundLabel;
@end


@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  NSLOCALIZEDSTRING(@"CART");
    self.tblView.estimatedRowHeight = 148.0 ;
    self.tblView.estimatedRowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCartList];
    //[self removeSelectedProduct:nil];
}

-(void)getCartList{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Cart"];
    self.cartArray = [[App_Delegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tblView reloadData];
    [self updatePrice];
}

-(void)removeSelectedProduct:(UIButton *)sender{
    
    Cart *cartObj = [self.cartArray objectAtIndex:sender.tag];
    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:App_Delegate.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"productname == %@", cartObj.productname];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[App_Delegate.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [App_Delegate.managedObjectContext deleteObject:product];
        [self.cartArray removeObjectAtIndex:sender.tag];
    }
    [App_Delegate.managedObjectContext save:&error];
    [self.tblView reloadData];
    [self updatePrice];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cartArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    if (cell==nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"CartTableViewCell" owner:nil options:0];
        cell = [array objectAtIndex:0];
    }
    Cart *cartObj = [self.cartArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = cartObj.productname;
    cell.priceLabel.text = [cartObj.price stringValue];
    cell.vendorNameLabel.text = cartObj.vendorName;
    cell.vendorAddressLabel.text = cartObj.vendorAddress;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:cartObj.productImage]
                             placeholderImage:nil];
    [cell.callVendorButton addTarget:self action:@selector(callToVendorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.callVendorButton.tag = indexPath.row;
    
    [cell.removeFromCartButton addTarget:self action:@selector(removeSelectedProduct:) forControlEvents:UIControlEventTouchUpInside];
    cell.removeFromCartButton.tag = indexPath.row;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)callToVendorButtonPressed:(UIButton *)sender{
    Cart *cartObj = [self.cartArray objectAtIndex:sender.tag];
    NSString *callToVendor=cartObj.phoneNumber;
    callToVendor=[callToVendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    callToVendor=[callToVendor stringByReplacingOccurrencesOfString:@"(" withString:@""];
    callToVendor=[callToVendor stringByReplacingOccurrencesOfString:@")" withString:@""];
    callToVendor=[callToVendor stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callToVendor]]];
}

-(void)updatePrice{
    _priceLabel.hidden = YES;
    _backgroundLabel.hidden = YES;
    int total = 0;
    for (Cart *cartObj in self.cartArray)
    {
        total += [cartObj.price intValue];
    }
    if (total>0) {
        _priceLabel.hidden = NO;
        _backgroundLabel.hidden = NO;
        _priceLabel.text = [NSString stringWithFormat:@"Total Price: %d",total];
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
