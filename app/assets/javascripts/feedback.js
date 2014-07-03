$(document).ready(function() {
  $(document).on("ajax:success", "form.feedback-form", function(e, data) {
    $(".form-message").remove();
    var message = ""
    if(data.status == 200) {
      $(".feedback-form").trigger("reset");
      message = "<div class=\"form-message green margin-bottom-10\">" + data.message + "</div>";
    } else {
      $(data.message).each(function() {
        message += "<div class=\"form-message green margin-bottom-10\">" + this + "</div>";
      });
    }
    console.log(message)
    $(".feedback-form").before($(message));
  });
});
