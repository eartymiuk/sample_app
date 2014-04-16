function updateCharCount() {
    var currCount = 140 - jQuery('#micropost_content').val().length;
    if (currCount >= 0)
    {
    	jQuery('.count').text('Count Down:' + currCount);
    }
    else
   	{
   		jQuery('.count').text('Count Down:0');
   	}
}

jQuery(document).ready(function($) {
    updateCharCount();
    $('#micropost_content').keyup(updateCharCount);
});