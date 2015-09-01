## Three test programs are included ##

  1. [FileView Program](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView%20Program) (target in FileView.xcodeproj)
  1. [FVIBPluginTest](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVIBPluginTest)
  1. [ImageShear](http://code.google.com/p/fileview/source/browse/trunk/fileview/ImageShear)

### FileView Program ###

![http://fileview.googlecode.com/svn/wiki/images/FileViewProgram.png](http://fileview.googlecode.com/svn/wiki/images/FileViewProgram.png)

This is the first and primary test interface.  It demonstrates multiple views in a splitview, and allows switching between grid/column view via a tabless tabview.  Also demonstrates drag-and-drop, and usage of bindings in code.

**If you use NSSplitView, be sure to check out the [NSSplitView category](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView%20Program/Controller.m) hack to make mouse dragging work.**  Yes, class posing and method swizzling are evil, but so is a container view that runs a modal loop in mouseDown: and breaks event tracking!

### FVIBPluginTest ###

![http://fileview.googlecode.com/svn/wiki/images/FVIBPluginTest.png](http://fileview.googlecode.com/svn/wiki/images/FVIBPluginTest.png)

This is the newest test program, and was mainly intended to test bindings established in the IB plugin.  It doesn't support editing, but allows changing background color and setting scale via text entry.

### ImageShear ###

![http://fileview.googlecode.com/svn/wiki/images/ImageShear.png](http://fileview.googlecode.com/svn/wiki/images/ImageShear.png)

This is for testing and debugging the tiling and scaling code in [FVCGImageUtilities.mm](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVCGImageUtilities.mm).  It allows showing the tile strips used, and changing canvas backgrounds to see if the scaled image is sized correctly.