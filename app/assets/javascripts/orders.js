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

  $(".review_cart .product-quantity select").on("change", function() {
    var $this = $(this);
    var quantity = $this.val();
    var id = $this.closest("tr").data("id");
    var product = { quantity: quantity, id: id }
    $.post("/update_cart", { product: product }, function(data) {
      $this.parent().siblings(".product-total").text("$" + (data.product_total/100).toFixed(2));
      if(data.shipping) {
        $(".shipping-total").text("$" + (data.shipping_total/100).toFixed(2))
      }
      $(".packs").text(data.packs)
      if(data.packless == 0) {
        $(".packless").text(0);
      } else {
        $(".packless").text(8 - data.packless);
      }
      $(".total").text((data.total/100).toFixed(2))
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

  checkShipping(function() {});
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
