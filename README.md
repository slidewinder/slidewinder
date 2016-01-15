![slidewinder](https://raw.githubusercontent.com/slidewinder/slidewinder/master/assets/logo_name.png)

# Instant pick-and-mix slide decks

Get help: [![Join the chat at https://gitter.im/slidewinder/slidewinder](https://badges.gitter.im/slidewinder/slidewinder.svg)](https://gitter.im/slidewinder/slidewinder?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![community docs](https://img.shields.io/badge/docs-community-ff69b4.svg)](http://slidewinder.io)

Basic info: [![npm](https://img.shields.io/npm/v/slidewinder.svg)](https://www.npmjs.com/package/slidewinder)
[![npm](https://img.shields.io/npm/l/slidewinder.svg)](https://github.com/slidewinder/slidewinder/blob/master/LICENSE.md)
[![npm](https://img.shields.io/npm/dt/slidewinder.svg)](https://www.npmjs.com/package/slidewinder)


Code quality: [![Travis](https://img.shields.io/travis/slidewinder/slidewinder.svg)](https://travis-ci.org/slidewinder/slidewinder)
[![Code Climate](https://img.shields.io/codeclimate/github/slidewinder/slidewinder.svg)](https://codeclimate.com/github/slidewinder/slidewinder)
[![Codecov](https://img.shields.io/codecov/c/github/slidewinder/slidewinder.svg)](https://codecov.io/github/slidewinder/slidewinder)

**Make a remark.js slide deck by remixing slides from a collection.**

### Installation

```
npm install --global slidewinder
```

### Usage

You'll want a collection of slides - see [examples](https://github.com/slidewinder/slidewinder/tree/master/examples).

Then...

```bash
$ slidewinder \
  --collection ./examples \
  --slides code,data,list \
  --title Test \
  --author Me \
  --output test_deck
info: loaded 3 slides from examples
info: picked 3 slides from collection
info: deck (index.html) and data (deck.json) saved to test_deck
$ open test_deck/index.html
```

Your browser should open with the first slide visible:

![slideshow screenshot](https://raw.githubusercontent.com/slidewinder/slidewinder/master/assets/normal_view.png)

If you hit 'p', you'll switch to presenter mode:

![presenter mode](https://raw.githubusercontent.com/slidewinder/slidewinder/master/assets/presenter_view.png)

### Contributing

Interested in contributing to this project? That's great! We'd love to have you.

Please read our [contributor community documentation](http://slidewinder.io/docs) to find out how to get involved.

### Slide decks made with slidewinder

- **How BioJulia is building for the future** by @Ward950 http://biojulia.github.io/talks/EBDM2015/
