# HexMap
Based off the excellent HexMap tutorial by Jasper Flick at https://catlikecoding.com/unity/tutorials/hex-map

Requires Unity 2019.3.0b6.

The C# code ports over perfectly, but the shaders do not.  I implemented the shaders using shader graph and the URP.  Most of the shader code is implemented in shader graph custom functions, which is then wrapped in a shader sub graph. 
