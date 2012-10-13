function checkSize() {
	var s = $('#test-size').css('width');
	s = s.substring(0, 2); //remove the 'px' from the returned width
	//em sizes are currently: 0, 31.25em, 50em, 75em
	//test sizes are currently: 10, 20, 30, 40
	if (s == 40) {
		Modernizr.screenSize = "huge";
		isBig();
	}else{
		if (s == 30) {
			Modernizr.screenSize = "large";
			isBig();
		}else{
			if (s == 20) {
				Modernizr.screenSize = "medium";
				isSmall();
			}else{
				Modernizr.screenSize = "small";
				isSmall();
			}
		}
	}
}

function isBig() {
	$('.signin-btn a').hide();
	$('.signin').show();
}

function isSmall() {
	$('.signin-btn a').show();
	$('.signin').hide();
}

$(document).ready(function() {
	$('body').append('<div id="test-size"></div>');

	$('.signin-btn a').click(function() {
		$('.signin').slideToggle();
	});

	checkSize();
});

$(window).resize(function() {
	checkSize();
});
