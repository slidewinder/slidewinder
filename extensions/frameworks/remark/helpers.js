
module.exports = {
    slidewinder: function(all){
      var bodies = all.data.root.slideset.map(function(x) {
        return x.body;
      });
      return bodies.join('\n---\n');
    });
}
