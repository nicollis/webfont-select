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
* 2016-10-26 -- v0.1.5 -- Added URL generation in config, and support for per font url object
* 2016-10-31 -- v0.1.6 -- Fixed issue with font generation when font had 3+ words
* 2016-11-01 -- v0.2.0 -- Enabled type-to-filter input
* 2016-11-01 -- v0.3.0 -- Enabled load_all_fonts option to enable loading all fonts on page load
* 2016-11-01 -- v0.3.2 -- Fixed load bug when pre-loading large font list, fixed bug with downloading already downloaded fonts
* 2016-11-03 -- v0.3.3 -- Added timeout to all fonts load to help break up large font load-ins
* 2016-11-07 -- v0.4.0 -- First font in list is now selected while typing, enter key selects first font and closes dropdown
* 2016-11-07 -- v0.4.1 -- Changed font_url to updated to highlighted font while typing in font name, before hitting enter
* 2016-11-07 -- v0.4.2 -- Moved trigger to end of select font call so element is fully updated before triggering callback
* 2016-11-08 -- v0.5.0 -- Implemented default_font_name option to generate url when unknown font is typed; Also implemented a "default" trigger that triggers when default_font_name is used
* 2016-11-08 -- v0.5.1 -- Updated trigger to work via bind and include same payload data as "change"

## Author

Copyright (c) 2016 [Nicholas Ollis](http://ollis.me). 
Released under the MIT License. 
See LICENSE.txt for license info.