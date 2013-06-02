$(function(){
  $('.display-thumb').hover(
    function(){
      var src = $(this).find("img").attr("src");
      var alt = $(this).find("img").attr("alt");
      var url = $(this).find("a").attr("href");
      var title = $(this).find(".title").text();
      var subtitle = $(this).find(".subtitle").text();
      $('#display-main').find("img").attr("src", src);
      $('#display-main').find("img").attr("alt", alt);
      $('#display-main').find(".title").text(title);
      $('#display-main').find(".subtitle").text(subtitle);
      $('#display-main').find("a").attr("href", url);
    }, undefined
  );
});

// twitter
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");
