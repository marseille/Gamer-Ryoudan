$(function() { 
  $("#add_to_list").attr("checked", false)
})

function show_hide() {
  if($("#add_this_game_to_list").is(":visible")){
    $("#add_this_game_to_list").fadeOut("slow")
  } else {
    $("#add_this_game_to_list").fadeIn("slow")
  }
}