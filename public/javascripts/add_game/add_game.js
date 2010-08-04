$(function() { 
  $("#add_to_list").attr("checked", false)
})

function show_hide () {
  if($("#add-game").is(":visible")){
    $("#add-game").fadeOut("slow")
  } else {
    $("#add-game").fadeIn("slow")
  }
}