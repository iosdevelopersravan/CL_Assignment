//
//  ProductsViewController.h
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UILabel *productNameLabel;
@property(nonatomic,weak) IBOutlet UILabel *priceLabel;
@property(nonatomic,weak) IBOutlet UILabel *vendorNameLabel;
@property(nonatomic,weak) IBOutlet UILabel *vendorAddressLabel;
@property(nonatomic,weak) IBOutlet UIImageView *productImageView;
@property(nonatomic,weak) IBOutlet UIButton *addToCartButton;
@end

@interface ProductsViewController : UIViewController

@end
