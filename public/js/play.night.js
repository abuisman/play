jQuery(document).ready(function(){
	
	function action(action, data, success){
    var type = (data === undefined) ? 'get' : 'post';
		success = (success === undefined) ? function(){} : success;
		jQuery.ajax({
			url: '/api/'+action,
			type: type,
      dataType: 'json',
			data: (data === undefined) ? {} : data,
      success: success
		});
	}
	
	// Button for importing (indexing) new songs.
	var import_button = jQuery('#control-songs-import');
	// Bind the click on the import button
	import_button.click(function(){
		jQuery.ajax({
			url: '/api/import',
			type: 'get',
			dataType: 'json'
		});
	});

	// Set volume button actions:
	jQuery('.control-volume').live('click', function(){
		var button = jQuery(this);
		var volume_level = button.attr('data-volume-level');
		action('volume', {level: volume_level});
	});

  action('volume', undefined, function(resp) {
    $( "#slider-range-min" ).slider({
      range: "min",
      change: function(event, ui) { action('volume', {'level': $(this).slider('value')}); },
      value: resp.volume,
      min: 0,
      max: 100,
    });
  });

/*
  var mute_button = jQuery('#control-volume-mute');

  jQuery.ajax({
    url: '/api/volume',
    type: 'get',
    dataType: 'json',
    success: function(results){
      console.log(results);
      if(results['volume'] === 0){
        mute_button.html('Unmute');
      } else {
        mute_button.html('Mute');
      }
    }
  });

  mute_button.live('click', function(e){
    e.preventDefault();

    jQuery.ajax({
      url: '/api/volume',
      type: 'get',
      dataType: 'json',
      success: function(results){
        if(results['volume'] === 0){
          action('volume', {level: 5});
          mute_button.html('Mute');
        } else {
          action('volume', {level: 0});
          mute_button.html('Unmute');
        }
      }
    });

    return false;		
  });
*/
});
