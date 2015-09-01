# Concept #
Similar to [IKImageBrowserView](http://developer.apple.com/documentation/GraphicsImaging/Reference/IKImageBrowserView/IKImageBrowserView_Reference.html), but supports arbitrary drawing via icon subclasses, and is compatible with 10.4.  A single-column view that scales icons to fit containers is also available.  The view scales to several thousand icons with no problem, and takes advantage of multiple processors/cores when possible.  Memory usage for the framework should remain low.

Here's a screenshot of one of the SamplePrograms:

![http://fileview.googlecode.com/svn/wiki/images/FVIBPluginTest.png](http://fileview.googlecode.com/svn/wiki/images/FVIBPluginTest.png)

# Supported File and URL Types #
  * PDF/PostScript
  * [Skim](http://skim.sourceforge.net/) PDFD
  * Anything NSAttributedString can read
  * http/ftp URLs and local HTML files using WebView
  * QuickTime movies
  * Anything ImageIO can read
  * Quick Look thumbnails (on 10.5)
  * Icon Services as a last resort

# Availability #
The framework will run on 10.4 and later.  Compilation requires 10.5 or later, for weak-linking the Quick Look framework.

# Why Use This? #
If you're only supporting Leopard, IKImageBrowserView is probably faster, and will likely improve in future.  FileView is designed to be more flexible (icons scale as large or small as you need), and of course the source is available for modification.  It was originally intended for use in [BibDesk](http://bibdesk.sourceforge.net/), so some of the functionality is problem-specific.

The icon grid dynamically adjusts layout, so the number of rows and columns will change as you resize the view.  Spacing between icons remains uniform, and is slightly "stretchy."  This was all very tricky to get right, especially with NSScrollView, so may be useful to others.

If you want to draw other objects, you can add your own FVIcon subclass to the FVIcon class cluster and make use of asynchronous drawing and graphics caching.  If you want to just draw NSCells, you would likely find it easier to ignore the async caching/drawing code, as NSCell is painful enough in its own right.

# Code for Dumpster-Divers #
  * [FVOperationQueue](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVOperationQueue.h) and [FVOperation](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVOperation.h), similar to NSOperation
  * [priority queue with fast enumeration](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVPriorityQueue.h)
  * [thread-safe disk cache](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVCacheFile.h) for arbitrary data
  * [CGImage scaling](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVCGImageUtilities.h) with [vImage](http://developer.apple.com/documentation/Performance/Conceptual/vImage/index.html)
  * [Finder icon label control](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVColorMenuView.h)
  * [Malloc zone for reusing large blocks of memory](http://code.google.com/p/fileview/source/browse/trunk/fileview/fv_zone.cpp)
  * [Thread pooling](http://code.google.com/p/fileview/source/browse/trunk/fileview/FVThread.h)
  * demonstrates two-way view binding implementation
  * demonstrates IBPlugin implementation
  * demonstrates CFRunLoop sources (v0 and v1)

Any or all of these may be improved upon significantly, of course!  Bug fixes and performance improvements are welcome, and feel free to e-mail with questions or comments.

# API Documentation #
There are only three public classes in the framework, but most of them are commented.  See FrameworkDocumentation for a link to the Xcode docset.

# Known Problems #
  * There are certainly bugs in the code, but I'm not aware of anything critical at this time.
  * Apple's ATS code has a memory corruption bug or bugs that can cause a deadlock after it stomps on memory.  FVCoreTextIcon seems to avoid this to some extent since it doesn't get the same font change notifications as the AppKit string drawing mechanism, but it's only available on 10.5.  PDF files with embedded fonts are a likely culprit.
  * Garbage collection is not supported, nor will it be supported unless someone volunteers to do it.  With the present mix of Cocoa, CoreFoundation, and CoreGraphics using Obj-C, C, and C++, writing a dual-mode framework is outside the scope of a hobby project.

# Users #
[BibDesk](http://bibdesk.sourceforge.net) is using an older version with a bunch of local changes.  [TeX Live Utility](http://mactlmgr.googlecode.com/) is using it to display documentation thumbnails, and a few people are using the Finder label drawing code.

# Support #
Feel free to email with questions: amaxwell at mac dot com.