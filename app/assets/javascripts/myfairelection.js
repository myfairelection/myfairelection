/* Normalized hide address bar for iOS & Android (c) Scott Jehl, scottjehl.com MIT License */
(function(a){var b=a.document;if(!location.hash&&a.addEventListener){window.scrollTo(0,1);var c=1,d=function(){return a.pageYOffset||b.compatMode==="CSS1Compat"&&b.documentElement.scrollTop||b.body.scrollTop||0},e=setInterval(function(){if(b.body){clearInterval(e);c=d();a.scrollTo(0,c===1?0:1)}},15);a.addEventListener("load",function(){setTimeout(function(){if(d()<20){a.scrollTo(0,c===1?0:1)}},0)})}})(this);

/*! A fix for the iOS orientationchange zoom bug. Script by @scottjehl, rebound by @wilto.MIT License.*/
(function(m){var l=m.document;if(!l.querySelector){return}var n=l.querySelector("meta[name=viewport]"),a=n&&n.getAttribute("content"),k=a+",maximum-scale=1",d=a+",maximum-scale=10",g=true,j,i,h,c;if(!n){return}function f(){n.setAttribute("content",d);g=true}function b(){n.setAttribute("content",k);g=false}function e(o){c=o.accelerationIncludingGravity;j=Math.abs(c.x);i=Math.abs(c.y);h=Math.abs(c.z);if(!m.orientation&&(j>7||((h>6&&i<8||h<8&&i>6)&&j>5))){if(g){b()}}else{if(!g){f()}}}m.addEventListener("orientationchange",f,false);m.addEventListener("devicemotion",e,false)})(this); 

(function(w){
	//form toggle for radio buttons
	$('body').on('click','.radio-group .radio-btn', function() {
		$(this).children('input[type=radio]').attr('checked',true);
		$(this).closest('.radio-group').children().removeClass('btn-inverse');
		$(this).closest('.radio-btn').addClass('btn-inverse');
	});

	//star rating
	$('body').on('click','.rating-group .rating-btn', function() {
		$(this).children('input[type=radio]').attr('checked',true);
		$(this).closest('.rating-group').children().removeClass('active');
		//loop through each button
		var x = true;
		$(this).closest('.rating-group').children('.rating-btn').each(function() {
			//turn on buttons until this is reached
			if (x) {
				$(this).addClass('active');
				if ($(this).children('input[type=radio]').attr('checked')) {
					x = false;
				}
			}
		});
	});

	//slide toggle
	$('body').on('click','.slide-toggle', function() {
		var x = $(this).attr('data-target');
		if ($('#'+x)) {
			$('#'+x).slideToggle();
		}
	});

	var cw = document.body.clientWidth;

	$(document).ready(function() {
		$('body').append('<div id="test-size"></div>');

		$('.js-hide').hide();
		$('.js-show').show();

		$('.click_toggle').click(function() {
			var t = $(this).attr('data-target');
			$('#' + t).slideToggle();
			return false;
		});

		checkSize();
	});

	$(w).resize(function(){ //Update dimensions on resize
		var nw = document.body.clientWidth;
		//see if the window size has changed
		if (nw != cw) {
			checkSize();
		}
	});

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
		$('#signin').show();
	}

	function isSmall() {
		$('.signin-btn a').show();
		$('#signin').hide();
	}
})(this);
