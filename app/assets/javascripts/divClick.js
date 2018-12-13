$(document).ready(function() {
  $(".idwebs").click(function() {
    // alert($(this).parent().parent().parent().is("div"))
    window.location = $(this).parent().parent().parent().find("a").attr("href");
    return false;
  });
  $(".iname").click(function() {
    // alert($(this).parent().parent().parent().is("div"))
    window.location = $(this).parent().parent().parent().find("a").attr("href");
    return false;
  });

});
