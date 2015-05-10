$ ->
  score_selector = '#evaluation_score'
  score_id_selector = '#evaluation_score_id'

  # initialize the score selector popup
  $('#score-dialog').modal
    show: false
    keyboard: true

  # event triggered when the user focus on the score field
  $(score_selector).focus ->
    $(this).blur()
    $('#score-dialog').modal('show')

  # general case, if the page is the group insert
  $('.evaluation_score_group').focus ->
    $(this).blur()
    id = $(this).data('id')
    score_selector = "#group_#{id}_score"
    score_id_selector = "#group_#{id}_score_id"
    $('#score-dialog').modal('show')

  # listen when the score is selected
  $('.btn-score').click ->
    score = $(this)
    id = score.data('id')
    # convert from success-danger-default to success-error-x
    scoreSufficient = switch score.data('sufficient')
      when 'success' then 'success'
      when 'danger' then 'error'
      else null
    group = $(score_selector).parent()

    # set the text and the id of the score
    if id
      $(score_selector).val(score.text().trim())
    else
      $(score_selector).val('')
    $(score_id_selector).val(id)

    # reset the validation of the score field
    group.removeClass('has-success').removeClass('has-error')
    group.addClass("has-#{scoreSufficient}") if scoreSufficient

    # close the modal window
    $('#score-dialog').modal('hide')
