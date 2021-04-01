/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import '../stylesheets/application'

require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('channels');
require('jquery');
require('timeago');
require('js-cookie');
require('jquery-dateformat/dist/jquery-dateformat.min');
require('datatables.net-bs4');

import 'bootstrap';
import 'popper.js';

import $ from 'jquery';

$(document).on('turbolinks:load', function() {
    $(function () {
        $('[data-toggle="tooltip"]').tooltip();
        $('.dataTable').DataTable({
            'ordering': false,
            'lengthMenu': [[5, 10, 25, 50, -1], [5, 10, 25, 50, 'All']],
            'pagingType': 'simple',
        });
    });

    $('#darkModeSwitch').on('change', function(){
        var state = $(this).prop('checked');
        state ? switchTheme('dark') : switchTheme('default');
    });

    $('.contest-time').each(function() {
        localTimeFromUtc($(this));
    });

    $('.contest-duration').each(function() {
        durationToText($(this));
    });

    $('.add-to-calendar').each(function() {
        formatCalendarUrl($(this));
    });

    var loader = setTimeout(removeLoader, 1000);
})

window.redirectUrl = function(obj) {
    if (history.pushState) {
        var newUrl = window.location.protocol + '//' + window.location.host + window.location.pathname + '?site_class=' + obj.firstElementChild.dataset.site;
        window.history.pushState({path:newUrl}, '', newUrl);
    }
}

function removeLoader() {
    $('.lazyLoader').removeClass('lazyLoader');
}

function localTimeFromUtc(obj) {
    var tagText = obj.html();

    if(tagText === '-') return;

    var givenDate = new Date(tagText);
    var localDateString = $.format.date(givenDate, 'dd MMM yyyy HH:mm');
    obj.html(localDateString);
}

function durationToText(obj) {
    var tagText = obj.html();

    if(tagText === '-') return;

    var seconds = parseInt(tagText);

    var days = Math.floor(seconds / (24 * 60 * 60));
    var days_s = 'days';
    if(days == 1) days_s = 'day';
    seconds %= (24 * 60 * 60);

    var hours = Math.floor(seconds / (60 * 60));
    hours = ('0' + hours).slice(-2);
    seconds %= (60 * 60);

    var minutes = Math.floor(seconds / 60);
    minutes = ('0' + minutes).slice(-2);

    if(days > 0) {
        var duration = days + ' ' + days_s + ' and ' + hours + ':' + minutes
        obj.html(duration);
    } else {
        var duration = hours + ':' + minutes
        obj.html(duration);
    }
}

function formatCalendarUrl(obj) {
    var href = obj[0].getAttribute('href');
    href = href.slice(0, 60) + href.slice(61, 63) + href.slice(64, 69) + href.slice(70, 72) + href.slice(73, 75) + href.slice(79);
    href = href.slice(0, 77) + href.slice(78, 80) + href.slice(81, 86) + href.slice(87, 89) + href.slice(90, 92) + href.slice(96);
    var text_index = href.indexOf('&text=') + 6;
    var location_index = href.indexOf('&location=');
    var name = href.slice(text_index, location_index);
    name = name.replace('#', '%23');
    name = name.replace('&', '%26');
    name = name.replace('+', '%2B');
    name = name.replace('?', '%3F');
    href = href.slice(0, text_index) + name + href.slice(location_index);
    obj[0].setAttribute('href', href);
}

function switchTheme(theme){
    if(theme == 'dark'){
        $('body').addClass('dark-theme');
        Cookies.set('theme', 'dark');
    } else if(theme == 'default') {
        $('body').removeClass('dark-theme');
        Cookies.set('theme', 'default');
    }
}
