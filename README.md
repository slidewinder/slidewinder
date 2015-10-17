Slidewinder - Instant pick-and-mix slide decks

Make a remark.js slide deck by remixing slides from a collection.

### Installation

```
npm install --global slidewinder
```

### Usage

You'll want a collection of slides - see examples.

Then...

```bash
$ slidewinder --collection examples --slides list,code,data --title Test --author Me --output test_deck
info: loaded 3 slides from examples
info: picked 3 slides from collection
info: deck (index.html) and data (deck.json) saved to  test_output
$ open test_deck/index.html
```
