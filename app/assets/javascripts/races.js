// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener('turbolinks:load', function () {
  if ($('#add-info-toggler').length > 0) {
    document.getElementById('add-info-toggler').addEventListener('click', function () {
      var additionalInformation = document.getElementById('additional-information');
      var expandMore = document.getElementById('expand-more');
      var expandLess = document.getElementById('expand-less');
      
      if (additionalInformation.style.display != 'none') {
        additionalInformation.style.display = 'none';
        expandLess.style.display = 'none';
        expandMore.style.display = 'block';
      }
      else {
        additionalInformation.style.display = 'block';
        expandLess.style.display = 'block';
        expandMore.style.display = 'none';
      }
    });
  }

  // Ad banners...
  if ($('[data-images]').length > 0) {
    setInterval(function() {
      $('[data-images]').each(function (index, image) {
        const images = $(image).data('images');
        
        if (images.length < 2) {
          return;
        }

        const thisImage = $(image).data('current-image');
        const imageSrcs = images.map(function (newImage) { return newImage[0]; });
        
        const position = $.inArray(thisImage, imageSrcs);
        const newPosition = images.length == position + 1 ? 0 : (position + 1)

        $(image).css('background-image', `url('${images[newPosition][0]}')`);
        $(image).parent().attr('href', images[newPosition][1]);
        $(image).data('current-image', images[newPosition][0]);
      });
    }, 10 * 1000);
  }
});
