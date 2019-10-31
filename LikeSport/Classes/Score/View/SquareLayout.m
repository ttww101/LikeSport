//
//  SquareLayout.m
//  01-百思不得其姐
//
//  Created by 李攀祥 on 16/3/8.
//  Copyright © 2016年 李攀祥. All rights reserved.
//

#import "SquareLayout.h"

@interface SquareLayout ()
/** attrs的数组 */
@property(nonatomic,strong)NSMutableArray * attrsArr;
@end
@implementation SquareLayout

-(NSMutableArray *)attrsArr
{
    if(!_attrsArr){
        _attrsArr=[[NSMutableArray alloc] init];
    }
    return _attrsArr;
}

-(void)prepareLayout
{
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
    NSInteger count =[self.collectionView   numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        NSIndexPath *  indexPath =[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.attrsArr;
}

#pragma mark ---- 返回CollectionView的内容大小
/*!
 * 如果不设置这个的话  CollectionView就不能滑动
 */
-(CGSize)collectionViewContentSize
{
    int count =(int)[self.collectionView numberOfItemsInSection:0];
    int rows=(count +3 -1)/3;
    CGFloat rowH = self.collectionView.frame.size.width/2;
    if ((count)%6==2|(count)%6==4) {
        return CGSizeMake(0, rows * rowH-rowH/2);
    }else{
        return CGSizeMake(0, rows*rowH);
    }
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =self.collectionView.frame.size.width*0.5;
    UICollectionViewLayoutAttributes * attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat height =width;
    NSInteger i=indexPath.item;
    if (i==0) {
        attrs.frame = CGRectMake(0, 0, width, height);
    }else if (i==1){
        attrs.frame = CGRectMake(width, 0, width, height/2);
    }else if (i==2){
        attrs.frame = CGRectMake(width, height/2, width, height/2);
    }else if (i==3){
        attrs.frame = CGRectMake(0, height, width, height/2);
    }else if (i==4){
        attrs.frame = CGRectMake(0, height+height/2, width, height/2);
    }else if (i==5){
        attrs.frame = CGRectMake(width, height, width, height);
    }else{
        UICollectionViewLayoutAttributes *lastAttrs = self.attrsArr[i-6];
        CGRect frame  = lastAttrs.frame;
        frame.origin.y+=2 * height;
        attrs.frame=frame;
    }
    
//    UICollectionViewLayoutAttributes *lastAttrs = self.attrsArr[i-1];
//    CGFloat width = CGRectGetMaxX(lastAttrs.frame) + 10;
//    if (width + lastAttrs.frame.size.width > kSceenWidth) {
//        attrs.frame = CGRectMake(0, 20*i, attrs.frame.size.width, attrs.frame.size.height);
//    }

   
    return attrs;
}

@end
