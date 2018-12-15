$(window).load(function() {
  $('.go_top').bind('click', function (e) {
    $("html,body").scrollTop(0);
    return false;
  });
});
