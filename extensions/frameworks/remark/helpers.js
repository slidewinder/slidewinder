
yaml = require('js-yaml');

module.exports = {
    slidewinder: function(context){
      slideData = context.data.root;
      var bodies = slideData.slides.map(function(x) {
        Object.keys(slideData.deck).forEach(function(key){
            x.attributes[key] = slideData.deck[key];
        });
        completeBody = yaml.dump(x.attributes) + '\n' + x.body
        return completeBody;
      });
      bodies.join('\n---\n');
      return bodies.join('\n---\n');
    }
}
