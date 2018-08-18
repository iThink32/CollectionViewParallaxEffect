# CollectionView with a simple parallax effect

## Usage:-

1) In the storyboard set the layout to custom and specify this class below it.
2) There are two IBInspectable properties :-
    
   - No Of Cells Per Page - specify how many cells you want to show per page
   - standard height - what should the height of non-featured(small) cells be.

Thats it nothing else needed.Handle your cells the way you want , no questions asked , just set this class in the storboard and your good to go.

#### Note:-

Based on the standard cell height , the featured cell height will automatically be calculated and fill the space.

#### Note:-

This project works with / without a navigation controller on iOS 11+.

### Sample :-

![Alt Text](https://github.com/iThink32/CollectionViewParallaxEffect/blob/master/ParallaxEffect1.gif)

#### Note :-

This is based on a tutorial i found online but struggled to understand it or make it work properly so used my own logic and created this.

