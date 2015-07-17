window.popupLink = function(linkClass, popupClass) {
  $(linkClass).click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    openPopup(popupClass);

    return false;
  });
};

window.openPopup = function(popupClass) {
  var $popup = $(popupClass);

  if($popup.hasClass("hide")) {
    $(".popup").addClass("hide");
    $popup.removeClass("hide");
    $(document).on("click" + popupClass, function(e){
      if(!($popup.is(e.target) || $popup.has(e.target).length)){
        closePopup(popupClass);
      }
    });
    $(document).on("click", ".close-modal", function(e){
      e.preventDefault();

      closePopup(popupClass);

      return false;
    });
  } else {
    closePopup(popupClass);
  }
};

window.closePopup = function(popupClass) {
  var $popup = $(popupClass);

  $popup.addClass("hide");
  $(document).off("click" + popupClass);
  $(document).off("click", ".close-modal");
};
