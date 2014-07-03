$(document).ready(function() {
  $(".toggle-user-forms").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    var $userForms = $(".user-forms");

    if($userForms.hasClass("hide")) {
      $userForms.removeClass("hide");
      $(document).on("click.toggle-user-forms", function(e){
        if(!($userForms.is(e.target) || $userForms.has(e.target).length)){
          $userForms.addClass("hide");
        }
      });
    } else {
      $userForms.addClass("hide");
      $(document).off("click.toggle-user-forms");
    }

    return false;
  });

  $(document).on("ajax:success", ".sign-in form, .sign-up form", function(e, data) {
    if(data.status == 200) {
      location.reload();
    } else {
      $(".form-errors").remove();
      var div = ""
      $(data.message).each(function() {
        div += "<div class=\"form-errors margin-bottom-10\">" + this + "</div>";
      });
      $(".sign-in").after($(div));
    }
  });
});
