## Using the framework in your app ##

If you're familiar with adding frameworks to a project in Xcode, skip to the last step below.  If not, this is mostly pretty standard stuff that's in the documentation.

You'll also need to read PopulatingTheView in order to actually display icons.

## Adding the framework in Xcode ##

  1. [Pull](http://code.google.com/p/fileview/source/checkout) the FileView source from svn and put it somewhere convenient
  1. Open your program's Xcode project
  1. Add a cross-project reference to FileView.xcodeproj
  1. Add a "Copy Files" build phase to your application's target, and set it to "Frameworks"
  1. Expand the FileView cross-project reference in your Xcode project, and drag the FileView.framework to the "Copy Files" build phase just added
  1. Get Info on your target and add the "Framework+Plugins" target from FileView as a direct dependency
  1. Add a shell script build phase to your target (before codesign scripts), and add the following /bin/sh script:
```
  /usr/bin/install_name_tool -change \
  '@loader_path/../../../../../../../FileView.framework/Versions/A/FileView' \
  '@executable_path/../Frameworks/FileView.framework/Versions/A/FileView'   \
  "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_PATH}"
```

That install\_name\_tool nastiness is required to make the framework 10.4 compatible, yet still work with the IB plugin.  Using @rpath would be better, but it's only supported on 10.5.

## Using the IB plugin ##

Xcode seems to require that you add a reference to the compiled framework (typically Built Product relative path) in the "Linked Frameworks" group before it automagically finds the .ibplugin bundle inside the framework.  Once you've compiled it and done that, open up one of your nibs in IB and you should see a "FileView" library item with two objects (FileView and FVColumnView).

## Sample Project ##

Take a look at the FVIBPluginTest.xcodeproj sample project, which demonstrates all of the points made here.