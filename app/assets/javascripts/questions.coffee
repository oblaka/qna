# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.vote').on 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $(vote.rating_id).text(vote.rating)
    if vote.good then $(vote.good_id).removeClass('disabled') else $(vote.good_id).addClass('disabled')
    if vote.revoke then $(vote.revoke_id).removeClass('disabled') else $(vote.revoke_id).addClass('disabled')
    if vote.shit then $(vote.shit_id).removeClass('disabled') else $(vote.shit_id).addClass('disabled')
    $('.alert').html('')
$(document).on('page:load', ready)
$(document).on('page:update', ready)