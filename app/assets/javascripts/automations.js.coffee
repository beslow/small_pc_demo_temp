# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->

  $("#part_tree").on 'click', '.ep_select', ->
    $(".ep_select").css("backgroundColor","white")
    this.style.backgroundColor = "#C8E4F8"


  $("tr.select").click ->
    $("tr.select").css("backgroundColor","white");
    this.style.backgroundColor = "#357ebd"
    $("#part_id").val($(this).data("part_id"));



