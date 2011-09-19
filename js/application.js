/* Adapted from http://www.fluidbyte.net/simple-jquery-expandcollapse-unordered-lists */

jQuery.fn.not_exists = function () {
	return jQuery(this).length === 0;
};

jQuery.fn.jqcollapse = function (o) {

	// Defaults
	var o = jQuery.extend({
		slide: false
	}, o);

	$(this).each(function () {

		var e = $(this).attr('id');

		$('#' + e + ' li > ol').each(function (i) {
			var parent_li = $(this).parent('li');
			var sub_ol = $(this).remove();

			// Create 'a' tag for parent if DNE
			if (parent_li.children('a').not_exists()) {
				parent_li.wrapInner('<a/>');
			}

			parent_li.find('a').addClass('jqcNode').css('cursor', 'pointer').click(function () {
				if (o.slide === true) {
					sub_ol.slideToggle(o.speed, o.easing);
				} else {
					sub_ol.toggle();
				}
			});
			parent_li.append(sub_ol);
		});

		//Hide all sub-lists
		$('#' + e + ' ol').hide();

		//Hide collapse button
		$('#collapse').hide();

		//Toggle all
		$('#expand').click(function() {
			$('#' + e + ' ol').show();
			$('#expand').hide();
			$('#collapse').show();
		});
		$('#collapse').click(function() {
			$('#' + e + ' ol').hide();
			$('#collapse').hide();
			$('#expand').show();
		});

	});

};

$(function () {
	$('#tractatus').jqcollapse();
	// Preload
	$(window).load(function() {
		$('header, #tractatus, section.document, body').addClass('complete');
	});
});