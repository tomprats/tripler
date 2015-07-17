$(document).ready(function() {
  if($(".order_purchase.new").length > 0) {
    Stripe.setPublishableKey($(".stripe-data").data("key"));
    $(document).on("submit", "#card-form", function(e) {
      e.preventDefault();

      Stripe.card.createToken({
        number: $("#card_number").val(),
        cvc: $("#card_cvc").val(),
        exp_month: $("#card_exp_month").val(),
        exp_year: $("#card_exp_year").val()
      }, function(status, response) {
        if(response.error) {
          $(".error").removeClass("hide").text(response.error.message)
        } else {
          if(confirm("Your credit card will be charged for $" + $(".total").text() + ".")) {
            $form = $("#order-purchase");
            $form.append($('<input type="hidden" name="card_token" />').val(response.id));
            $form.get(0).submit();
          }
        }
      });

      return false;
    });
  }
});
