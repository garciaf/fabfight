#= require vendor/jquery-1.11.2
#= require vendor/casper

$ ->
  $('iframe').css
    width: $('.post-content').innerWidth() + 'px'
    height: ($('.post-content').innerWidth()*0.57) + 'px'
  $(window).resize ->
    $('iframe').css
      width: $('.post-content').innerWidth() + 'px'
      height: ($('.post-content').innerWidth()*0.57) + 'px'