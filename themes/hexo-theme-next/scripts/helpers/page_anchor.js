/* global hexo */
// Usage: {% page_anchor(page.content) %}

var cheerio = require('cheerio');

hexo.extend.helper.register('page_anchor', function(str){
  var $ = cheerio.load(str, {decodeEntities: false});
  var headings = $('h1, h2, h3, h4, h5, h6');

  if (!headings.length) return str;

  headings.each(function(){
    var id = $(this).attr('id');

    $(this)
      .addClass('article-heading')
      .prepend('<a class="article-anchor" href="#' + id + '" aria-hidden="true"></a>');
  });

  return $.html();
});