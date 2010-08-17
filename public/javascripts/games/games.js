$(function() { 
  $("#add_to_list").attr("checked", false)
})

function show_hide() {  
  if($("#add_this_game_to_list").is(":visible")){    
    if($("#add_game_button")) {
      $("#add_game_button").text("add!")
    }
    $("#add_this_game_to_list").fadeOut("slow")
  } else {    
    if($("#add_game_button")){
      $("#add_game_button").text("cancel!")
    }
    $("#add_this_game_to_list").fadeIn("slow")
  }
}

function find_game() {
  var game = $("#search_tag").val()
  
  $.ajax({
    "url": "../games/find_game",
    "dataType": "html",
    "type": "GET",
    "data": {"search_tag" : game},
    "success": function(json) {
        $("#search-results").empty()
        $("#search-results").hide()
        $("#search-results").append("<h3> Search results: </h3>")
        $("#search-results").append(json)    
        $("#search-results").animate({width: 'show', duration : '3000' });
    },
    "error": function (event, XMLHttpRequest, ajaxOptions, thrownError)  {
      console.log(event)
      console.log("CRAP!")
    },
    "processData":"false",
    "contentType":"application/json"
  });
    
}