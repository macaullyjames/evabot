# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  return unless $("body").hasClass "settings"

  $("table.repos").on "change", "input[type=checkbox]", (e) ->
    $input = $(@)
    $form = $input.closest "form"
    data = $form.serialize()

    $spinner = $ "<i>", class: "fa fa-circle-o-notch fa-spin fa-fw"
    $input.replaceWith $spinner

    $.post(
      url: $form.attr "action"
      data: data
    )
      .fail ->
        $input.prop "checked", (_, val) -> not val
      .always ->
        $spinner.replaceWith $input


