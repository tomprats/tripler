$(document).ready(function() {
  if($(".pages.jerky").length > 0) {
    $(".product-quantity select").on("change", function() {
      var quantity = 0;
      var total = 0;
      $(".product-quantity select").each(function() {
        var $this = $(this);
        quantity += parseInt($this.val());
        total += $this.val() * parseFloat($this.closest(".product-box").find(".price").text());
      });
      $(".packs").text(Math.floor(quantity/orderSize));
      packless = quantity%orderSize;
      if(packless == 0) {
        $(".packless").text(0);
      } else {
        $(".packless").text(orderSize - quantity%orderSize);
      }
      $(".total").text((total).toFixed(2));
    });

    $(".jerky .checkout").click(function(e) {
      e.preventDefault();
      var order = {};
      order["order_items_attributes"] = [];
      $(".product-box").each(function() {
        var $this = $(this);
        order["order_items_attributes"].push({
          product_id: $this.data("id"),
          quantity: $this.find("select").val()
        });
      });
      $.post("/order", { order: order }, function(data) {
        location.href = data.href;
      });
      return false;
    });
  }

  if($(".order.edit").length > 0) {
    $(".product-quantity select").on("change", function() {
      var $this = $(this);
      var quantity = $this.val();
      var id = $this.closest("tr").data("id");
      var product = { product_id: id, quantity: quantity }
      $.ajax({
        url: "/order",
        type: "PUT",
        data: { product: product },
        success: function(data) {
          product = $(data.order_items).each(function() {
            $("tr[data-id='" + this.product_id + "'] .product-total").text("$" + (this.total_price/100).toFixed(2));
          });
          if(data.shipping) {
            $(".shipping-total").text("$" + (data.shipping_total/100).toFixed(2))
          }
          $(".packs").text(data.packs)
          if(data.packless == 0) {
            $(".packless").text(0);
          } else {
            $(".packless").text(orderSize - data.packless);
          }
          $(".total").text((data.total_price/100).toFixed(2))
        }
      });
    });
  }

  if($(".order_address.new").length > 0) {
    $(document).on("ajax:success", "#new_order", function(e, data) {
      if(data.status == 200) {
        location.href = data.location
      } else {
        $(this).find(".error").text(data.message)
      }
    });
  }

  if($(".order_address.create").length > 0) {
    $(document).on("click", "#order-address .override", function(e) {
      e.preventDefault();

      $("#order-address #override").val(true);
      $("#order-address").submit();

      return false;
    });
  }

  if($(".order_rates.index").length > 0) {
    $(document).on("click", "#order-rates .select-rate", function(e) {
      e.preventDefault();

      rate = $(this).closest("tr").data("rate");
      $("#order-rates #rate").val(rate);
      $("#order-rates").submit();

      return false;
    });
  }
});
