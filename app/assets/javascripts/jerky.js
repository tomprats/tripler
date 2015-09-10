$(document).ready(function() {
  if($(".pages.jerky, .pages.home").length > 0) {
    $(".product-quantity .quantity").on("change", function() {
      var quantity = 0;
      var total = 0;
      $(".product-quantity .quantity").each(function() {
        var $this = $(this);
        quantity += parseInt($this.val());
        total += $this.val() * parseFloat($this.closest(".product-box").find(".price").text());
      });
      $(".total").text((total).toFixed(2));
    });

    $(".checkout").click(function(e) {
      e.preventDefault();
      var order = {};
      order["order_items_attributes"] = [];
      $(".product-box").each(function() {
        var $this = $(this);
        order["order_items_attributes"].push({
          product_id: $this.data("id"),
          quantity: $this.find(".quantity").val()
        });
      });
      $.post("/order", { order: order }, function(data) {
        location.href = data.href;
      });
      return false;
    });
  }
});
