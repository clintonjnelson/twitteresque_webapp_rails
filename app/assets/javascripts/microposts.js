function updateCountdown() {
  var maxCharacters = 140;
  // .micropost_content is the classname of the textfield we're using.
  var remainingCharacters = maxCharacters - jQuery('#micropost_content').val().length;

  // Text to go with the characters output
  if(remainingCharacters >= 0 ) {
    var charactersFeedback = ' characters remaining.'
  }
  else{
    var charactersFeedback = ' characters too many.'
  }

  // Return the text output of the characters concatenated with string
  // .countdown is the CSS label it will fall under for incorporation
  jQuery('.countdown').text(Math.abs(remainingCharacters) + charactersFeedback);
}

// On ready, load the countdown & update it per additional listeners
// Using .on('_listenerName_', function(_functionName_) {}) if current best-practice
jQuery(document).ready(function($) {
  updateCountdown();
  $('#micropost_content').on("change keyup input", updateCountdown);
});
