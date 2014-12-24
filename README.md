# Mathematical-Node

Quickly convert math equations into beautiful SVGs (or PNGs/MathML). A port of [the Ruby Mathematical](https://github.com/gjtorikian/mathematical) for Node.js.

[![Build Status](https://travis-ci.org/gjtorikian/mathematical-node.svg?branch=master)](https://travis-ci.org/gjtorikian/mathematical-node)

![Mathematical](https://cloud.githubusercontent.com/assets/64050/5330532/c85e81fe-7e03-11e4-95d8-06a551b5f240.gif)

## Installation

```
npm install mathematical
```

## Usage

The simplest way to do this is

``` javascript
Mathematical = require 'mathematical'

new Mathematical.render(string_with_math)
```

`string_with_math` should just be a string of math TeX inline (`$..$`) or display (`$$..$$`) style math.

The output will be a hash, with keys that depend on the format you want:

* If you asked for an SVG, you'll get:
  * `width`: the width of the resulting image
  * `height`: the height of the resulting image
  * `svg`: the actual string of SVG
* If you asked for a PNG, you'll get:
  * `width`: the width of the resulting image
  * `height`: the height of the resulting image
  * `png`: the PNG data
* If you asked for MathML, you'll get:
  * `mathml`: the MathML data

### Options

`new Mathematical` takes an optional object to define a few options:

* `ppi` - A double determining the pixels per inch of the resulting SVG (default: `72.0`).
* `zoom` - A double determining the zoom level of the resulting SVG (default: `1.0`).
* `base64` - A boolean determining whether Mathematical's output should be a base64-encoded SVG string (default: `false`).
* `maxsize` - A numeral indicating the `MAXSIZE` the output string can be. (default: `unsigned long`).
* `format` - A string indicating whether you want an "svg", "png", or "mathml" output. (default: `svg`).

Pass these in like this:

``` javascript
opts = { ppi: 200.0, zoom: 5.0, base64: true }
renderer = new Mathematical(opts)
renderer.render('$a \ne b$')
```

## Building

Before building this gem, you must install the following libraries:

* glib-2.0
* gdk-pixbuf-2.0
* xml2
* cairo
* pango

You will also need fonts for cmr10, cmmi10, cmex10, and cmsy10.

### Mac install

To install these dependencies on a Mac, everything can be installed via Homebrew:

```
brew install glib gdk-pixbuf cairo pango
```

Install the fonts with:

```
cd ~/Library/Fonts
curl -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cmex10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cmmi10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cmr10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cmsy10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/esint10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/eufm10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/msam10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/msbm10.ttf \
     -LO http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cmmi10.ttf
```

`xml2` should already be on your machine.

### *nix install

To install these dependencies on a *nix machine, fetch the packages through your package manager. For example:

```
sudo apt-get -qq -y install libglib2.0-dev libxml2-dev libcairo2-dev libpango1.0-dev ttf-lyx libgdk-pixbuf2.0-dev
```

### Windows install

On a Windows machine, I have no idea. Pull requests welcome!

## Hacking

After cloning the repo:

```
npm install
grunt
```

If there were no errors, you're done! Otherwise, make sure to follow the dependency instructions.
