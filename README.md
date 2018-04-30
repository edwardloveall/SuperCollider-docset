# SuperCollider Dash DocSet generator

Generate a [Dash](https://kapeli.com/dash) [docset](https://kapeli.com/docsets#dashDocset) from the [SuperCollider](https://supercollider.github.io) [help files](http://doc.sccode.org).

**Created by** [Edward Loveall](https://edwardloveall.com)

## Usage

* Open SuperCollider and run `SCDoc.renderAll` to generate HTML help files
* Clone this repo and `cd` into the directory
* Run `bundle install`
* Run `ruby generate.rb`

This generator is based on the assumptoin that HTML versions of all the SuperCollider help files exist at: `~/Library/Application Support/SuperCollider/Help`. If this is not the case you can find the `Help` directory by running `Platform.userAppSupportDir` in SuperCollider. If there is no `Help` directory in that location, you can regenerate the documentation by running `SCDoc.renderAll`. One you have help files, change the line near the end of the `generator.rb` file to reflect the correct path for your system.

The generator takes a while to run. Perhaps minutes, depending on your computer.

## Help

If you find something that is broken, missing, or wrong, please submit an [issue](https://github.com/edwardloveall/SuperCollider-docset/issues) or create a [pull request](https://github.com/edwardloveall/SuperCollider-docset/pulls) for consideration. Thanks!
