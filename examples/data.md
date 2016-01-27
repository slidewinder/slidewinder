---
title: Contextual Data
author: Richard Smith-Unna ([@blahah404](https://twitter.com/blahah404))
data:
  some_key: 'some_value'
---
# {{slide.title}}

This slide is rendered from the metadata of both the slide and the deck!

```\{{slide.author}}```

Slide by: {{slide.author}}

Talk by: {{deck.author}}

Arbitrary data: `\{{slide.data.some_key}}` maps to {{slide.data.some_key}}
