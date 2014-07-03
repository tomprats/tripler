$(document).ready(function() {
  $(".create-product").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    var $productForm = $(".product-form");

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

  $(".product-form form").ajaxForm({
    success: function(data) {
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
    }
  });

  $(".edit-product").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    var id = $(this).data("id");
    var $productForm = $(".edit-product-form.product-" + id);

    if($productForm.hasClass("hide")) {
      $(".edit-product-form").addClass("hide");
      $productForm.removeClass("hide");
      $(document).on("click.toggle-edit-product-form-" + id, function(e){
        if(!($productForm.is(e.target) || $productForm.has(e.target).length)){
          $productForm.addClass("hide");
        }
      });
    } else {
      $productForm.addClass("hide");
      $(document).off("click.toggle-edit-product-form-" + id);
    }

    return false;
  });

  $(".edit-product-form form").ajaxForm({
    success: function(data) {
      if(data.status == 200) {
        location.reload();
      } else {
        $(".form-errors").remove();
        var div = ""
        $(data.message).each(function() {
          div += "<div class=\"form-errors margin-bottom-5\">" + this + "</div>";
        });
        $(".edit-product-form form").before($(div));
      }
    }
  });
});
