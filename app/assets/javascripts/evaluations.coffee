$ ->
  # initialize the datepicker
  $('.date').datepicker
    format: 'dd/mm/yyyy'
    weekStart: 1
    daysOfWeekDisabled: "0"
    autoclose: true
    todayHighlight: true

  # initialize the score selector popup
  $('#score-dialog').modal
    show: false
    keyboard: true

  # event triggered when the user focus on the score field
  $('#evaluation_score').focus ->
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
    group = $('#evaluation_score').parent()

    # set the text and the id of the score
    $('#evaluation_score').val(score.text().trim())
    $('#evaluation_score_id').val(id)

    # reset the validation of the score field
    group.removeClass('has-success').removeClass('has-error')
    group.addClass("has-#{scoreSufficient}") if scoreSufficient

    # close the modal window
    $('#score-dialog').modal('hide')
