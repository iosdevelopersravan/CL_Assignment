//
//  ProductsViewController.m
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import "ProductsViewController.h"
#import "Constants.h"
#import "WebServiceCall.h"
#import "Utility.h"
#import "ProductObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Cart.h"
#import <MBProgressHUD.h>
@interface ProductsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak) IBOutlet UICollectionView *collection_View;
@property(nonatomic,strong)NSMutableArray *productsArray;
@end

@implementation ProductCell
@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  NSLOCALIZEDSTRING(@"PRODUCTS");
    [self deleteAllCartObjects];
    self.productsArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getProductsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)getProductsData{

    [[WebServiceCall sharedInstance] serviceCallWithRequestType:@"GET" webServiceUrl:@"https://mobiletest-hackathon.herokuapp.com/getdata/" SuccessfulBlock:^(NSInteger responseCode, id responseObject) {
        NSLog(@"");
        NSString *responseString = responseObject;
        NSDictionary* responseDictionary = [Utility dictionaryFromJSON:responseString];
        NSArray *results = [responseDictionary objectForKey:KPRODUCTS];
        if(results != nil)
        {
            [self.productsArray removeAllObjects];
            for (NSDictionary *productDict in results) {
                ProductObject *pObj = [ProductObject new];
                pObj.productnameString =[productDict objectForKey:KPRODUCT_NAME];
                pObj.priceString =[productDict objectForKey:KPRICE];
                pObj.vendornameString =[productDict objectForKey:KVENDOR_NAME];
                pObj.vendoraddressString =[productDict objectForKey:KVENDOR_ADDRESS];
                pObj.productImageUrlString =[productDict objectForKey:KPRODUCT_IMG];
                [self.productsArray addObject:pObj];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.collection_View reloadData];
            });
        }
        else
        {
        }
        
    } FailedCallBack:^(id responseObject, NSInteger responseCode, NSError *error) {
        
    }];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.collection_View.frame.size.width/2;
    return CGSizeMake(width-10, 240);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductCell *cell = (ProductCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    ProductObject *productObject = [self.productsArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = productObject.productnameString;
    cell.priceLabel.text = productObject.priceString;
    cell.vendorNameLabel.text = productObject.vendornameString;
    cell.vendorAddressLabel.text = productObject.vendoraddressString;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productObject.productImageUrlString]
                      placeholderImage:nil];
    [cell.addToCartButton addTarget:self action:@selector(addToCartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.addToCartButton.tag = indexPath.row;
    
    if(productObject.isProductAdded){
        [cell.addToCartButton setTitle:@"Remove from Cart" forState:UIControlStateNormal];
    }
    else{
        [cell.addToCartButton setTitle:@"Add to cart" forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)addToCartButtonPressed:(UIButton *)sender{
    
    ProductObject *pObj = [self.productsArray objectAtIndex:sender.tag];
    
    ProductCell *cell = (ProductCell *)[self.collection_View cellForItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    if ([cell.addToCartButton.titleLabel.text isEqualToString:@"Remove from Cart"]) {
        pObj.isProductAdded = NO;
        [self.productsArray replaceObjectAtIndex:sender.tag withObject:pObj];
        [self removeSelectedProduct:pObj.productnameString];
        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [self.collection_View reloadItemsAtIndexPaths:@[index]];
        return;
    }
    
    NSNumberFormatter * numberformatter = [[NSNumberFormatter alloc] init];
    [numberformatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    Cart *cartManagedObj = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:App_Delegate.managedObjectContext];
    [cartManagedObj setPrice:[numberformatter numberFromString:pObj.priceString]];
    [cartManagedObj setProductname:pObj.productnameString];
    [cartManagedObj setVendorName:pObj.vendornameString];
    [cartManagedObj setVendorAddress:pObj.vendoraddressString];
    [cartManagedObj setPhoneNumber:pObj.phoneNumberString];
    [cartManagedObj setProductImage:pObj.productImageUrlString];
    NSError *error = nil;
    if (![App_Delegate.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else{
        pObj.isProductAdded = YES;
        [self.productsArray replaceObjectAtIndex:sender.tag withObject:pObj];
        [self.collection_View reloadItemsAtIndexPaths:@[index]];
    }
}

-(void)removeSelectedProduct:(NSString *)productName{
    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:App_Delegate.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"productname == %@", productName];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[App_Delegate.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [App_Delegate.managedObjectContext deleteObject:product];
    }
    [App_Delegate.managedObjectContext save:&error];
}

- (void) deleteAllCartObjects  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:App_Delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [App_Delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [App_Delegate.managedObjectContext deleteObject:managedObject];
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
