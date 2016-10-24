# jQuery UI Widget: Webfont selector


Based on agoragames [GWFSelect](https://github.com/tommoor/fontselect-jquery-plugin)
for creating an easy to implement google font's selector using Google's WebFont framework.
This version has been rewritten in CoffeeScript and designed to take a [WebFontConfig](https://github.com/typekit/webfontloader)
JSON object and load in all font sources supported by WebFontLoader.

Google has been first tested, with Custom Sources to be test next.

## Usage

1. Include jQuery, jQuery UI, and the [Google WebFont loader](http://code.google.com/apis/webfonts/docs/webfont_loader.html) on your page.
2. Create a regular text input to use as the font selector (it may be prefilled with the name of a font).
3. Invoke `$.wfselect` on the input. Info on the inputs will be coming soon

## Example

View index.html or src/index.haml for an example

## Changelog

* 2016-10-24 -- v0.1.0 -- Initial public release with tested Google support

## Author

Copyright (c) 2016 [Nicholas Ollis](http://ollis.me). 
Released under the MIT License. 
See LICENSE.txt for license info.