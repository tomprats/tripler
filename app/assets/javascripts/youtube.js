$(document).ready(function() {
  // Find all YouTube videos
  var $allVideos = $("iframe.youtube")

  // The element that is fluid width
  // Figure out and save aspect ratio for each video
  $allVideos.each(function() {
    $(this)
      .data("aspectRatio", this.height / this.width)
      // and remove the hard coded width/height
      .removeAttr("height")
      .removeAttr("width");
  });

  // When the window is resized
  $(window).resize(function() {
    // Resize all videos according to their own aspect ratio
    $allVideos.each(function() {
      var $this = $(this);
      var newWidth = $this.parent().width();

      $this
        .width(newWidth)
        .height(newWidth * $this.data("aspectRatio"));
    });

    // Kick off one resize to fix all videos on page load
  }).resize();
});
