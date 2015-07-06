# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('vote').on 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $(vote.rating_id).text(vote.rating)
    if vote.good then $(vote.good_id).removeClass('disabled') else $(vote.good_id).addClass('disabled')
    if vote.revoke then $(vote.revoke_id).removeClass('disabled') else $(vote.revoke_id).addClass('disabled')
    if vote.shit then $(vote.shit_id).removeClass('disabled') else $(vote.shit_id).addClass('disabled')
    $('.alert').html('')
$(document).on('page:update', ready)

$ ->
    userId = $('body').data('userId')
    questionId = $('.question').data('questionId')
    questionAuthor = $('.question').data('author')
    answers = '/question/' + questionId + '/answers'
    PrivatePub.subscribe answers, (data, channel) ->
        answer = $.parseJSON(data['answer'])
        ansDivId = 'answer_' + answer.id
        $('.answers').append("<p id= #{ansDivId} >" + answer.body + '</p>')

        $("##{ansDivId}").append('<attachments id="attachments_' + ansDivId + '"></attachments>')
        atts = answer.attachments
        for att in atts
            do (att) ->
              linkSt = '<a class="btn btn-link" href="' + att.url + '">' + att.name + '</a>'
              $("#attachments_#{ansDivId}").append(linkSt)

        if questionAuthor
            $("##{ansDivId}").append('<a class="btn btn-success btn-xs" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + answer.id + '/solution">Mark as Solution</a>')

        if answer.user_id == userId
            $('.new_answer #answer_body').val('');
            editSt = '<a class="btn btn-warning btn-xs" data-remote="true" href="/answers/' + answer.id + '/edit">edit</a>'
            deleteSt = '<a class="btn btn-danger btn-xs" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + answer.id + '">delete</a>'
            $("##{ansDivId}").append(editSt + deleteSt)
        else
            goodSt = '<a data-type="json" class="btn btn-link " id="good_' + ansDivId + '" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + answer.id + '/good">+</a>/'
            shitSt = '<a data-type="json" class="btn btn-link " id="shit_' + ansDivId + '" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + answer.id + '/shit">-</a>'
            revokeSt = '<a data-type="json" class="btn btn-link " id="revoke' + ansDivId + '" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + answer.id + '/revoke>X</a>/'
            ratingSt = '<strong id="rating_' + ansDivId + '">0</strong>'
            voteSt = '<vote id="vote_' + ansDivId + '"></vote>'
            $("##{ansDivId}").append(voteSt)
            $("#vote_#{ansDivId}").append('<br>' + goodSt + shitSt + ratingSt + revokeSt)

    PrivatePub.subscribe "/questions", (data, channel) ->
      question = $.parseJSON(data['question'])
      $('#questions').append(
        '<tr><td><a href="/questions/' +
        question.id + '">' +
        question.title +
        '</a></td><td>' +
        question.body +
        '</td></tr>')
