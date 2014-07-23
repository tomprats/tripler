$(document).ready(function() {
  $(".product-quantity select").on("change", function() {
    var total = 0;
    $(".product-quantity select").each(function() {
      var $this = $(this);
      total += $this.val() * parseInt($this.closest(".product-box").find(".price").text());
    });
    $(".total").text(total);
  });

  $(".checkout").click(function(e) {
    e.preventDefault();
    var cart = {};
    $(".product-box").each(function() {
      var $this = $(this);
      cart[$this.data("id")] = $this.find("select").val();
    });
    $.post("/update_cart", { cart: cart }, function(data) {
      location.href = data.href;
    });
    return false;
  });
});

