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
  $(".entel").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".transforme").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".bdp").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".esb").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".abastible").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".coordinador").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".cencosud").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".bicevida").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });
  $(".empresa-webstorms").click(function() {
    window.location = $(this).find("a").attr("href");
    return false;
  });

});
