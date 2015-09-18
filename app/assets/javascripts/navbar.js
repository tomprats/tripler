$(document).on("click", ".mobile-nav a", function(e) {
  e.preventDefault();
  $(".normal-nav").toggleClass("active");
  return false;
});
