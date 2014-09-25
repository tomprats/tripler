$(document).ready(function(){
  if($(".owl-carousel").length) {
    $(".owl-carousel").owlCarousel({
      items: 1,
      dots: true,
      loop: true,
      autoplay: true
    });
  }
});
