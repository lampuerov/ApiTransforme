$(window).load(function() {
  $('.webstorm_div').hide();
  $('.idea_div').hide();
  $('.webstorm-titulo').unbind('click').bind('click', function (e) {
    var id =  $(this).attr('id')
    // alert($(this).attr('id'))
    // alert($(this).parent().children(".webstorm_div").children(".webstorm").is("table"))
    $('#webstorm_div_' + id).toggle();
    $("html,body").scrollTop($('#webstorm_div_' + id).position().top);
    // setTimeout(function() {
    //   $("html, body").animate({ scrollTop: $('#webstorm_div_' + id).scrollTop() }, "slow");
    // }, 3000);
    return false;
  });

  $('.idea-titulo').unbind('click').bind('click', function (e) {
  // alert($(this).attr('id'))
  // alert($(this).parent().children(".webstorm_div").children(".webstorm").is("table"))
  $('#idea_div_' + $(this).attr('id')).toggle();
  $("html,body").scrollTop($('#idea_div_' + $(this).attr('id')).position().top);
  return false;
  });
});
