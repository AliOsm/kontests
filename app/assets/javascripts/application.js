// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap
//= require rails-timeago
//= require activestorage
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
    $('.contest-time').each(function() {
        localTimeFromUtc($(this));
    });

    $('.contest-duration').each(function() {
        durationToText($(this));
    });
})

function redirectUrl(obj) {
	if (history.pushState) {
	    var newUrl = window.location.protocol + '//' + window.location.host + window.location.pathname + '?site_class=' + obj.firstElementChild.dataset.site;
	    window.history.pushState({path:newUrl}, '', newUrl);
	}
}

function localTimeFromUtc(obj) {
    var tagText = obj.html();

    if(tagText === '-') return;

    var givenDate = new Date(tagText);
    var localDateString = DateFormat.format.date(givenDate, 'dd MMM yyyy HH:mm');
    obj.html(localDateString);
}

function durationToText(obj) {
    var tagText = obj.html();

    if(tagText === '-') return;

    seconds = parseInt(tagText);

    days = Math.floor(seconds / (24 * 60 * 60));
    days_s = 'days';
    if(days == 1) days_s = 'day';
    seconds %= (24 * 60 * 60);

    hours = Math.floor(seconds / (60 * 60));
    hours = ('0' + hours).slice(-2);
    seconds %= (60 * 60);

    minutes = Math.floor(seconds / 60);
    minutes = ('0' + minutes).slice(-2);

    if(days > 0)
        obj.html(`${days} ${days_s} and ${hours}:${minutes}`);
    else
        obj.html(`${hours}:${minutes}`);
}
