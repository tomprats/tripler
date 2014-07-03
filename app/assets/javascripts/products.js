$(document).ready(function() {
  $(".create-product").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    $productForm = $(".product-form");

    if($productForm.hasClass("hide")) {
      $productForm.removeClass("hide");
      $(document).on("click.toggle-product-form", function(e){
        if(!($productForm.is(e.target) || $productForm.has(e.target).length)){
          $productForm.addClass("hide");
        }
      });
    } else {
      $productForm.addClass("hide");
      $(document).off("click.toggle-product-form");
    }

    return false;
  });

  $(document).on("ajax:success", ".product-form", function(e, data) {
    if(data.status == 200) {
      location.reload();
    } else {
      $(".form-errors").remove();
      var div = ""
      $(data.message).each(function() {
        div += "<div class=\"form-errors margin-bottom-5\">" + this + "</div>";
      });
      $(".product-form form").before($(div));
    }
  });
});
