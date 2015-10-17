# Slidewinder - Instant pick-and-mix slide decks

Make a remark.js slide deck by remixing slides from a collection.

### Installation

```
npm install --global slidewinder
```

### Usage

You'll want a collection of slides - see [examples](https://github.com/Blahah/slidewinder/tree/master/examples).

Then...

```bash
$ slidewinder --collection examples --slides list,code,data --title Test --author Me --output test_deck
info: loaded 3 slides from examples
info: picked 3 slides from collection
info: deck (index.html) and data (deck.json) saved to test_deck
$ open test_deck/index.html
```
