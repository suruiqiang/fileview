## Datasource ##

The basic datasource implementation is similar to NSTableView and other datasource-using views, with two required methods for a read-only source ([FileViewDataSource informal protocol](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView.h)).  If you want to make the view editable (for dropping files/URLs on it), you need to implement the [FileViewDragDataSource informal protocol](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView.h).

Presently, the only formal documentation is the [FileView.h](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView.h) header.  However, the "FileView Program" example's [Controller.m](http://code.google.com/p/fileview/source/browse/trunk/fileview/FileView%20Program/Controller.m) object demonstrates how to implement the editing methods, and to establish bindings in code.

If you want to display something other than standard URLs, you could define your own private scheme and add an FVIcon subclass to the class cluster.  That may or may not be easier than just drawing your content instead of an FVIcon in the view itself.

## Bindings ##

Now that an IB plugin exists, it's easiest to set everything up in the nib.  Bind "Content" to an array of NSURL objects, and set other properties as desired.

**NOTE:** _Even if you use bindings, you still need to implement the datasource informal protocol in order for editing (i.e. drag-and-drop) to work_!