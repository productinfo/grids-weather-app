ShinobiGrids Weather Demo App (Objective-C)
=====================

The ShinobiDataGrid, new in ShinobiGrids version 2.0, provides a more powerful and flexible way of displaying your tabular data than its previous iteration the ShinobiGrid. This weather demo app demonstrates how to make the most of the ShinobiDataGrid!

![Screenshot](screenshot.png?raw=true)

Building the project
------------------

In order to build this project you'll need a copy of ShinobiGrids. If you don't have it yet, you can download a free trial from the [ShinobiGrids website](http://www.shinobicontrols.com/shinobigrids/price-plans/shinobigrids/shinobigrids-free-trial-form/).

Once you've downloaded and unzipped ShinobiGrids, open up the project in Xcode, and drag ShinobiGrids.embeddedframework from the finder into Xcode's 'frameworks' group, and Xcode will sort out all the header and linker paths for you.

If you're using the trial version you'll need to add your license key. To do so, open up ViewController.m and add the following lines in the setupTopView: and setupBottomView: methods respectively after each grid has been initialised:

    _topGrid.licenseKey=@"your license key";
	_bottomGrid.licenseKey=@"your license key";
	
Contributing
------------

We'd love to see your contributions to this project - please go ahead and fork it and send us a pull request when you're done! Or if you have a new project you think we should include here, email info@shinobicontrols.com to tell us about it.

License
-------

The [Apache License, Version 2.0](license.txt) applies to everything in this repository, and will apply to any user contributions.

