![slidewinder](https://raw.githubusercontent.com/slidewinder/slidewinder/master/assets/logo_name.png)

# Instant pick-and-mix slide decks

[![Join the chat at https://gitter.im/slidewinder/slidewinder](https://badges.gitter.im/slidewinder/slidewinder.svg)](https://gitter.im/slidewinder/slidewinder?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Make a remark.js slide deck by remixing slides from a collection.

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

- BioJulia by @Ward950 http://biojulia.github.io/talks/EBDM2015/
