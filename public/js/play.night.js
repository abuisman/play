jQuery(document).ready(function(){
	
	function action(action, data, success){
		data = (data === undefined) ? {} : data;
		type = (data === {}) ? 'get' : 'post';
		success = (success === undefined) ? function(){} : success;
		jQuery.ajax({
			url: '/api/'+action,
			type: type,
			data: data
		});
	}

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
	
});