# KeiAnimatedPath

With this class you can animate different paths (CGPath).

#LEGEND

- `targetView` - any UIView you want toput the animation on
- `duration` - the time the animation will end the job
- `lineWidth` - width of the line and also the thickness of the text
- `fontName` - a string name of the font you want to apply
- `numberOfSides` - in polygon drawing this in the number of how many equal-sized sides it will have
- `rotationAngle` - with this parameter you can rotate the path with any angle in range 0 -360
- `polygonCornerRadius` - with this parapeter you define how are the polygon path corners rounded

#USAGE

###Rectangle path:
```
KeiAnimatedPath().drawAnimatedRectanglePath(in: targetView, duration: 10, lineWidth: 20, lineColor: UIColor.red)
```

###Polygon path: 
Here you can animate a path of a polygon with a custom number of sides and a custom rotation angle. 
```
KeiAnimatedPath().drawAnimatedPolygonPath(in: targetView, numberOfSides: 8, rotationAngle: 30, polygonCornerRadius: 8, duration: 10, lineWidth: 5, lineColor: UIColor.gray)
```

###Text animation:
```
KeiAnimatedPath().drawAnimatedText(in: targetView, with: "Keisyrzk", duration: 10, lineWidth: 2, textColor: UIColor.blue, fontName: "anyFontName", fontSize: 50)
```

###Custom path
```
KeiAnimatedPath().drawAnimatedCustomPath(in: targetView, path: myPath, duration: 15, lineWidth: 5, lineColor: UIColor.blue)
```

###If you prefer not creating seperated instances you can also use a singleton like so:
```
KeiAnimatedPath.shared.drawAnimatedRectanglePath(in: targetView, duration: 10, lineWidth: 20, lineColor: UIColor.red)
```

#PREVIEW
![](https://github.com/keisyrzk/KeiAnimatedPath/blob/master/preview.gif)

