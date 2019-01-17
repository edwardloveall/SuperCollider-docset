# SuperCollider Dash DocSet generator

Generate a [Dash] [docset] from the [SuperCollider] [help files].

[Dash]: https://kapeli.com/dash
[docset]: https://kapeli.com/docsets#dashDocset
[SuperCollider]: (https://supercollider.github.io)
[help files]: (http://doc.sccode.org)

**Created by** [Edward Loveall](https://edwardloveall.com)

## Usage

* Open SuperCollider and run `SCDoc.renderAll` to generate HTML help files
* Clone this repo and `cd` into the directory
* Run `bundle install`
* Run `ruby generate.rb`

This generator is based on the assumption that HTML versions of all the SuperCollider help files exist at: `~/Library/Application Support/SuperCollider/Help`. If this is not the case you can find the `Help` directory by running `Platform.userAppSupportDir` in SuperCollider. Go there and look for the `Help` folder. If they exist, change the line near the end of the `generator.rb` file to reflect the correct path for your system.

The generator takes a while to run. Perhaps minutes, depending on your computer.

## Submit the docset

See [here] for to submit it to the Dash user contributions.

[here]: https://github.com/Kapeli/Dash-User-Contributions#contribute-a-new-docset

## Help

If you find something that is broken, missing, or wrong, please submit an [issue](https://github.com/edwardloveall/SuperCollider-docset/issues) or create a [pull request](https://github.com/edwardloveall/SuperCollider-docset/pulls) for consideration. Thanks!
