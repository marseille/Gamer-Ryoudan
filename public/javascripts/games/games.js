$(function() { 
  $("#add_to_list").attr("checked", false)  

  $(".set_difficulty").live("click", function(event) {
    event.preventDefault()
    var selector_id = $(event.target).attr("selector_id")
    var div_id = selector_id + "_div"
    $("#"+div_id).empty()
    $("#"+div_id).data("previous", $(event.target).text())    
    $("#"+div_id).append("<input id="+selector_id+"_input size=3></input>")
    $("#"+div_id).append("<a href='#' class='save_difficulty'> <img selector_id="+selector_id+" border=0 src=/images/save_icon.png class=image_icon></a>")
  });    
  
  $(".save_difficulty").live("click", function(event) {
    event.preventDefault()
    var div_id = $(event.target).attr("selector_id")
    $("#"+div_id + "_div").empty()
    if($("#"+div_id+"_input").text() == ""){
      var previous = $("#"+div_id+"_div").data("previous")
      $("#"+div_id + "_div").append("<a href='#' selector_id="+ div_id +" class=set_difficulty left_align>" + previous + " </a>")
    } else {
      $("#"+div_id + "_div").append("<a href='#' selector_id="+ div_id +" class=set_difficulty left_align> bleh </a>")
    }
  });
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