# Brodsky's Hex Map
An addon for generating hex maps in Godot. This addon is based on the implementation of HexMaps by RedBlobGames, found here https://www.redblobgames.com/grids/hexagons/implementation.html.

There are other addons that do this same thing, but I wasn't satisfied with the level of documentation and organization and thus decided to make my own. 
Hopefully, the code within this addon is adequately documented that there is no confusion for how to use it. 
If you find something that can be improved (code or documentation), please let me know. Thanks.

## What's Inside
### Hex
The main class for representing a hexagons object. 
This classes use cube coordinates (although some axial coordinate support exists) and contains all the operations you might want to perform on hexagons within the abstract context of a hexagon tiling. 
Hex has no concept of screen or pixels, only cube coordinates. Hex also mostly has no concept of orientation (flat vs pointy).

### Hex Orientation
A static class used to retrieve data about hexagon orientations. 
It's called "HexOrientation" because the data it stores is for each of the two orientations of hexagons, flat and pointy.

Includes:
- conversion matrices for converting between cube coordinates (those found in Hex) and pixel coordinates (used by HexDraw)
- starting angles used when calculating the pixel coordinates of hexagon corners
- neighbor and diagonal coordinate (cube) offsets used by Hex to get other, nearby hexagons

### HexLayout
A class which performs the conversion between cube coordinates and pixel coordinates and which provides the necessary *information* to draw hexagons (but does not draw them itself).
HexLayout is the bridge between Hex and HexDraw, and it uses HexOrientation as a tool to make that bridge.

### HexMap
A data structure class which stores Hex objects and information for different ways of organizing those hexes onto a single tiling.
HexMap has no concept of screen or pixels, only cube coordinates. HexMap also mosthas no concept of orientation (flat vs pointy).

### HexDraw
A class used to actually draw hexagons.

## How to Use
If all you need to do is draw a hex map, this can do it for you. 
But if you need to store data alongside those hexes, you'll need to either set up another data structure that maps cube coordinates to your data, or you'll need to make a class which inherits from Hex (or possibly HexMap) that stores that data. 
This addon is meant to be a common foundation for all HexMap-related applications rather than a singular solution to them.

## Methods
Instead of documenting methods here, which would be exhausting, I did my best to make sure that methods each have documentation comments, descriptive names, and static typing. If you want to know what a method does, you should be able to tell by looking at its signature + doc comment.
