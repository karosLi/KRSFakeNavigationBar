# KRSFakeNavigationBar
A fake navigation bar for each view controller, so that you can customlize nav bar style on different screen 

![demo](https://github.com/karosLi/KRSFakeNavigationBar/blob/master/demo.gif)  

## How To Use?
1. Here is the switch which can turn on/off the fake navigation bar function.
```Object-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
}
```

2. You just use origin way to set navigation bar style, no complex grammer, so easy.
```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
    
    self.title = @"Third";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RandomColor;
}
```

## Note
1. You should put all navigation bar style settings into method viewDidLoad.

