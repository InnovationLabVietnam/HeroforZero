/**
 * Ajax Image Upload with jQuery
 *
 * @see jQuery Form Plugin
 * http://malsup.com/jquery/form/
 */

$(document).ready(function() {
	
	
	var f = $('form');
	var l = $('#loader'); // loder.gif image
	var b = $('#button'); // upload button
	var p = $('#preview'); // preview area

	b.click(function(){
		// implement with ajaxForm Plugin
		f.ajaxForm({
			beforeSend: function(){
				l.show();
				b.attr('disabled', 'disabled');
				p.fadeOut();
			},
			success: function(e){
				l.hide();
				b.removeAttr('disabled');
				p.html(e).fadeIn();
				//p.attr('src', e).fadeIn();
				$('form#form_quest input#photoUrl').val(e);
			},
			error: function(e){
				b.removeAttr('disabled');
				p.html(e).fadeIn();
			}
		});
	});	
	
});

var lat;
var lon;

function initialize() {
	
	var myLatlng = new google.maps.LatLng(lat, lon);
	var myOptions = {
		zoom: 18,
		center: myLatlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	
	$('#map_canvas').fadeOut(300, function() {
		
		var map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);
		var marker = new google.maps.Marker({
			position: myLatlng
		});
		marker.setMap(map);
		$(this).fadeIn(300);
	});
}

jQuery(document).ready(function($) {
	var initial = window.location.hash;
	if(initial == '') initial = '#theform';
	$('#tab-container div.tab').css('display', 'none');
	$('#tab-nav a').removeClass('active');
	$('#tab-nav a[href='+ initial +']').addClass('active');
	$(initial + '_tab').css('display', 'block');
	
	$('a.tab-nav').bind('click', function(){
		$('#tab-container div.tab').css('display', 'none');
		$('#tab-nav a').removeClass('active');
		var hash = $(this).attr('href');
		$('#tab-nav a[href='+ hash +']').addClass('active');
		$(hash + '_tab').css('display', 'block');
	});
	
	$('#form_quest button#searchAddress').click(function() {
		var pc = $('#address').val();
		if (pc != '') {
			$.getJSON('gg.php?pc=' + pc, function(data) {
				lat = data.results[0].geometry.location.lat;
				lon = data.results[0].geometry.location.lng;
				$('#latitude').val(lat);
				$('#longitude').val(lon);
				$.getScript('http://maps.google.com/maps/api/js?sensor=false&callback=initialize');
				
			});
		}
		return false;
	});

	$('#submit').bind('click', function(){
		$('#fp_message').removeClass('success');
		$('#fp_message').removeClass('error');
		$('#fp_message').html('Sending...');
		
		$.ajax({
			type: "POST",
			url: "http://"+window.location.host+"/formquest/process.php", 
			data: $('#form_quest').serialize(), 
			success: function(data){
                            console.log("lalasd"+"http://"+window.location.host+"/formquest/process.php"+data);
				if(data == 'OK'){
					$('#fp_message').addClass('success');
					$('#fp_message').html('<p style="color: blue">Your Form Has Been Submitted</p>');
				} else {
					$('#fp_message').addClass('error');
					$('#fp_message').html('<p style="color: red"><strong>Error:</strong> ' + data + '</p>');
				}
			},
			error: function () {
				$('#fp_message').addClass('error');
				$('#fp_message').html('<p style="color: red"><strong>Error:</strong> There seems to be an error with the form processor</p>');
			}
		});
		return false;
	});
});

	