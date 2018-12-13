$(document).ready(function() {
  $(".idwebs").click(function() {
    alert($(this).parent().parent().find("a").attr("href"))
    window.location = $(this).parent().parent().find("a").attr("href");
    return false;
  });
});
