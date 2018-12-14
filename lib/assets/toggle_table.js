$(document).ready(function() {
  $('.webstorm_div').hide();
  $('.idea_div').hide();
  $('.webstorm-titulo').unbind('click').bind('click', function (e) {
    // alert($(this).attr('id'))
    // alert($(this).parent().children(".webstorm_div").children(".webstorm").is("table"))
      $('#webstorm_div_' + $(this).attr('id')).toggle();
    });
  $('.idea-titulo').unbind('click').bind('click', function (e) {
    // alert($(this).attr('id'))
    // alert($(this).parent().children(".webstorm_div").children(".webstorm").is("table"))
      $('#idea_div_' + $(this).attr('id')).toggle();
    });
});
