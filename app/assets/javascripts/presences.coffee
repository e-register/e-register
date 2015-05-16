$ ->
  $('.presence_type_selector').click (e)->
    e.preventDefault()
    type = $(this)

    klass = type.data('class')
    id = type.data('id')

    $('.presence_type_selector').removeClass('bg-success').removeClass('bg-danger')
    type.addClass("bg-#{klass}")

    $('#presence_presence_type_id').val(id)
