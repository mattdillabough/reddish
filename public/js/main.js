$(function() {
  $('.link-upvote').click(function() {
    $.ajax('/link/32/upvote', {
      success: function() {
        alert('it was successful');
      },
      error: function() {
        alert('there was an error with link id = ');
      }
    })
  });
});