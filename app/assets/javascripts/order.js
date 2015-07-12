$(document).ready(function() {
  $(".jerky .product-quantity select").on("change", function() {
    var quantity = 0;
    var total = 0;
    $(".product-quantity select").each(function() {
      var $this = $(this);
      quantity += parseInt($this.val());
      total += $this.val() * parseFloat($this.closest(".product-box").find(".price").text());
    });
    $(".packs").text(Math.floor(quantity/8));
    packless = quantity%8;
    if(packless == 0) {
      $(".packless").text(0);
    } else {
      $(".packless").text(8 - quantity%8);
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

  $(".orders.edit .product-quantity select").on("change", function() {
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
          $(".packless").text(8 - data.packless);
        }
        $(".total").text((data.total_price/100).toFixed(2))
      }
    });
  });

  $(".review_cart #order_zipcode").on("change", function() {
    checkShipping(function() {});
  });

  $(document).on("click", ".review_cart .purchase", function(e) {
    e.preventDefault();
    callback = function() {
      Stripe.setPublishableKey($(".stripe-data").data("key"));
      Stripe.card.createToken({
        number: $("#card_number").val(),
        cvc: $("#card_cvc").val(),
        exp_month: $("#card_exp_month").val(),
        exp_year: $("#card_exp_year").val()
      }, function(status, response) {
        if(response.error) {
          alert(response.error.message);
        } else {
          if(confirm("Your credit card will be charged for $" + $(".total").text() + ".")) {
            $form = $("#purchase-order");
            $form.append($('<input type="hidden" name="card_token" />').val(response.id));
            $form.get(0).submit();
          }
        }
      });
    }
    checkShipping(callback);
    return false;
  });

  if($("#order_zipcode").length) {
    checkShipping(function() {});
  }
});

function checkShipping(callback) {
  var zipcode = $("#order_zipcode").val();
  if(zipcode != "") {
    $.post("/update_shipping", { zipcode: zipcode }, function(data) {
      $(".shipping-total").text("$" + (data.shipping_total/100).toFixed(2))
      $(".total").text((data.total/100).toFixed(2))
      callback();
    });
  } else {
    callback();
  }
}
