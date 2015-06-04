$ ->
  $('.presence_type_selector').click (e)->
    e.preventDefault()
    type = $(this)

    klass = type.data('class')
    id = type.data('id')
    justificable = type.data('justificable')

    if justificable
      $('.justification-box').show()
    else
      $('.justification-box').hide()
      $('#presence_note').val('')

    $('.presence_type_selector').removeClass('bg-success').removeClass('bg-danger')
    type.addClass("bg-#{klass}")

    $('#presence_presence_type_id').val(id)

  $('.justification_selector').click (e)->
    e.preventDefault()
    just = $(this)

    id = just.data('id')

    $('.justification_selector').removeClass('bg-success')
    just.addClass('bg-success')

    $('#presence_justification_id').val(id)
