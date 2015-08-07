$(document).ready(function() {
  if($(".order_purchase.new").length > 0) {
    Stripe.setPublishableKey($(".stripe-data").data("key"));

    var formSubmitted = false;
    $(document).on("submit", "#card-form", function(e) {
      e.preventDefault();

      var continueButton = $("#card-form .continue").clone();
      var loadingButton = $('<div class="btn btn-green">Purchase <div class="fa fa-spin fa-spinner"></div></div>')
      $("#card-form .continue").replaceWith(loadingButton);
      if(!formSubmitted) {
        formSubmitted = true;
        Stripe.card.createToken({
          name: $("#card_name").val(),
          number: $("#card_number").val(),
          cvc: $("#card_cvc").val(),
          exp_month: $("#card_exp_month").val(),
          exp_year: $("#card_exp_year").val()
        }, function(status, response) {
          if(response.error) {
            loadingButton.replaceWith(continueButton);
            formSubmitted = false;
            $(".error").removeClass("hide").text(response.error.message)
          } else {
            if(confirm("Your credit card will be charged for $" + $(".total").text() + ".")) {
              $form = $("#order-purchase");
              $form.append($('<input type="hidden" name="card_token" />').val(response.id));
              $form.get(0).submit();
            } else {
              loadingButton.replaceWith(continueButton);
              formSubmitted = false;
            }
          }
        });
      }

      return false;
    });
  }
});
