A simple frosty loader, similar to the one used in the <a href="https://github.com/typhoon-framework/Typhoon-Swift-Example">Typhoon Sample Application</a>

#Setup

```Objective-C

//Required : The logo image to display
[ICLoader setImageName:anImageName]; 

//Optional
[ICLoader setFontname:aFontName];
```

#Usage

```Objective-C
[ICLoader present];

//do some things

[ICLoader dismiss];
```

ICLoader is presented in the root view controller. 
