//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require bootstrap
//= require users
//= require jquery-ui
//= require jquery-ui/widgets/datepicker

$(document).ready(() => {
  $("table > tbody tr td a.expand").click((e) => {
    $(e.target).closest('tr').next().slideToggle( "slow", function() {
      $(this).toggleClass('d-none')
    });
  })

  $(".ui-datepicker").attr('style','display: none')

  $("#report-date-selector input").on('click', (event) => {
    $(".ui-datepicker").attr('style','display: block')
  })

  $("#report-date-selector").datepicker({
    defaultDate: new Date(),
    formate: 'dd:mm:yyyy hh:mm A',
    onSelect: (value, options) => {
      var date = $("#report-date-selector").datepicker('getDate');
      $(options.input).find('input').val(date);
      $(".ui-datepicker").attr('style','display: none')
    }
  });
})