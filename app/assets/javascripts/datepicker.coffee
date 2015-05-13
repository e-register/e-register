$ ->
  # initialize the datepicker
  $('.date').datepicker
    format: 'dd/mm/yyyy'
    weekStart: 1
    daysOfWeekDisabled: "0"
    autoclose: true
    todayHighlight: true
    orientation: 'auto'

  # prevent the smartphone keyboard to be shown
  $('.date, .date input').focus ->
    $(this).blur();
